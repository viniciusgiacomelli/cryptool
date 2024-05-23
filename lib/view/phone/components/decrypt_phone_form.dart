import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class DecryptPhoneForm extends StatefulWidget {
  const DecryptPhoneForm({super.key});

  @override
  State<DecryptPhoneForm> createState() => _DecryptPhoneFormState();
}

class _DecryptPhoneFormState extends State<DecryptPhoneForm> {
  GetIt getIt = GetIt.instance;

  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController privateKeyTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _privateKey = false;

  Future<void> _dialogBuilder(BuildContext context, String privacyType) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chave $privacyType'),
          content: SingleChildScrollView(child: Text(privateKeyTextController.text)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Copiar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    var cryptoService = getIt.get<CryptoService>();
    return Form(
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Texto criptografado",
                        hintText: "Insira seu texto",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8
                        )
                      ),
                      controller: cleanTextController,
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Texto claro",
                        hintText: "Seu texto aparecerá aqui",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8
                        )
                      ),
                      controller: secretTextController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: (){},
                child: Text("Descriptografar")
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: (){
                        _dialogBuilder(context, "privada");
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Column(
                          children: [
                            Text("Chave privada"),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey,
                                    width: 2.0
                                ),
                              ),
                              child: Center(
                                child: _privateKey ?
                                Icon( Icons.key_rounded, size: 80,) :
                                Text("Carregar chave"),
                              ),
                            ),
                            Text("Clique para abrir", style: TextStyle(fontSize: 10),),
                          ],
                        ),
                      )
                  ),
                  ElevatedButton(
                    child: Text("Carregar ... "),
                    onPressed: () async {
                      KeyPair keyPair = await cryptoService.generateKeryPair();
                      privateKeyTextController.text = keyPair.privateKey;
                    },
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }
}

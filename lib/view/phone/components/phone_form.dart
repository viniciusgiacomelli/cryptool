import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({super.key});

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  GetIt getIt = GetIt.instance;

  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController publicKeyTextController = TextEditingController();
  final TextEditingController privateKeyTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> algorithms = <String>["RSA", "AES", "MD5"];
  late String _algorithm;

  @override
  void initState() {
    _algorithm = algorithms[0];
    super.initState();
  }


  Future<String> _getPublicKey() async {
    if(publicKeyTextController.text == ""){
      var cryptoService = getIt.get<CryptoService>();
      KeyPair keyPair = await cryptoService.generateKeryPair();
      publicKeyTextController.text = keyPair.publicKey;
      privateKeyTextController.text = keyPair.privateKey;
      return publicKeyTextController.text;
    }
    return publicKeyTextController.text;
  }

  Future<void> _dialogBuilder(BuildContext context, String privacyType) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chave $privacyType'),
          content: privacyType == "pública" ?
            Text(publicKeyTextController.text):
            SingleChildScrollView(child: Text(privateKeyTextController.text)),
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
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Texto claro",
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
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Texto criptografado",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DropdownButton(
                      iconSize: 40.0,
                      isExpanded: true,
                      isDense: true,
                      iconEnabledColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      borderRadius: BorderRadius.circular(10),
                      items: algorithms.map<DropdownMenuItem<String>>((String? brandValue) =>
                          DropdownMenuItem<String>(
                              value:brandValue,
                              child: Text("$brandValue")
                          )
                      ).toList(),
                      value: _algorithm,
                      onChanged: (String? brandValue){
                        setState(() {
                          _algorithm = brandValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox( width: 12,),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          var secretText = await cryptoService.cryptograph(
                              message: cleanTextController.text,
                              publicKey: await _getPublicKey()
                          );
                          secretTextController.text = secretText;
                        },
                        child: Text("Aplicar")
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text("Gerar par de chaves"),
                onPressed: () async {
                  KeyPair keyPair = await cryptoService.generateKeryPair();
                  publicKeyTextController.text = keyPair.publicKey;
                  privateKeyTextController.text = keyPair.privateKey;
                },
              ),
              SizedBox(height: 16,),
              TextFormField(
                onTap: (){
                  _dialogBuilder(context, "pública");
                },
                readOnly: true,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Chave publica",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8
                  )
                ),
                controller: publicKeyTextController,
              ),
              SizedBox(height: 8,),
              TextFormField(
                onTap: (){
                  _dialogBuilder(context, "privada");
                },
                readOnly: true,
                maxLines: 6,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "chave privada",
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8
                    )
                ),
                controller: privateKeyTextController,
              ),
            ],
          ),
        ),
    );
  }
}

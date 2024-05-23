import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  GetIt getIt = GetIt.instance;

  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController publicKeyTextController = TextEditingController();
  final TextEditingController privateKeyTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> algorithms = <String>["RSA", "AES"];

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
          padding: EdgeInsets.all(16.0),
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
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("algoritmo"),
                          DropdownButton(
                            iconSize: 40.0,
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
                          ElevatedButton(
                            onPressed: () async {
                              var secretText = await cryptoService.cryptograph(
                                algorithm: _algorithm,
                                message: cleanTextController.text,
                                publicKey: await _getPublicKey()
                              );
                              secretTextController.text = secretText!;
                            },
                            child: Text("Aplicar"),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                )
                              )
                            )
                          )
                        ],
                      )
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Texto criptografado",
                        hintText: "O texto criptografado aparecerá aqui",
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
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: (){},
                          child: Text("Procurar"),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              )
                            )
                          )
                        ),
                      ],
                    )
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("algoritmo"),
                      ],
                    )
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        ElevatedButton(onPressed: (){}, child: Text("Download")),
                        ElevatedButton(onPressed: (){}, child: Text("Copiar"))
                      ],
                    )
                  ),
                ],
              ),
              SizedBox(height: 30,),
              _algorithm == "RSA" ?  Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      _dialogBuilder(context, "privada");
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 2.0
                        ),
                      ),
                      child: Center(
                        child: Icon( Icons.lock, size: 100,),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: TextFormField(
                  //     onTap: (){
                  //       _dialogBuilder(context, "privada");
                  //     },
                  //     readOnly: true,
                  //     maxLines: 6,
                  //     decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: "Chave privada",
                  //       hintText: "Key ID:",
                  //       contentPadding: EdgeInsets.symmetric(
                  //         vertical: 12,
                  //         horizontal: 8
                  //       )
                  //     ),
                  //     controller: privateKeyTextController,
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text("Gerar nova chave"),
                          onPressed: () async {
                            KeyPair keyPair = await cryptoService.generateKeryPair();
                            publicKeyTextController.text = keyPair.publicKey;
                            privateKeyTextController.text = keyPair.privateKey;
                          },
                        )
                      ],
                    )
                  ),
                  Expanded(
                    child: TextFormField(
                      onTap: (){
                        _dialogBuilder(context, "pública");
                      },
                      readOnly: true,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Chave pública",
                        hintText: "Key ID:",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8
                        )
                      ),
                      controller: publicKeyTextController,
                    ),
                  ),
                ],
              ) : SizedBox()
            ],
          ),
        )
    );
  }
}

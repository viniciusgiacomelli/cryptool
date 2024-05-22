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

  List<String> algorithms = <String>["RSA", "AES", "MD5"];

  late String _algorithm;

  @override
  void initState() {
    _algorithm = algorithms[0];
    super.initState();
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
                            onPressed: (){},
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
                  Expanded(
                    child: TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Chave privada",
                          hintText: "Key ID:",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8
                          )
                      ),
                      controller: privateKeyTextController,
                    ),
                  ),
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

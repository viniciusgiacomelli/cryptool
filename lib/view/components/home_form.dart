import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController secretPhraseController = TextEditingController();

  List<String> algorithms = <String>["RSA", "AES"];

  late String _algorithm;

  @override
  void initState() {
    _algorithm = algorithms[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      controller: secretPhraseController,
                    ),
                  ),
                  Expanded(
                      child: Column(
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
                      controller: secretPhraseController,
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
                        ElevatedButton(onPressed: (){}, child: Text("Procurar")),
                      ],
                    )
                  ),
                  Expanded(
                      child: Column(
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
              Row(
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
                      controller: secretPhraseController,
                    ),
                  ),
                  Expanded(
                      child: Text("Text")
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
                      controller: secretPhraseController,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}

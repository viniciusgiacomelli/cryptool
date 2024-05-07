import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController secretPhraseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Texto claro"),
                  TextFormField(
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "segredo",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8
                        )
                    ),
                    controller: secretPhraseController,
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: (){},
                      child: Text("Carregar ... ")
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    maxLines: 6,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Chave Publica",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8
                        )
                    ),
                    controller: secretPhraseController,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Algoritmo"),
                  Icon(Icons.arrow_forward_rounded),
                  SizedBox(height: 200,),
                  ElevatedButton(
                      onPressed: (){},
                      child: Text("Gerar novo par de chaves")
                  )
                ],
              ),
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Texto criptografado"),
                    TextFormField(
                      maxLines: 6,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "s@e%4Fg_R54rgT",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8
                          )
                      ),
                      controller: secretPhraseController,
                    ),
                    SizedBox(height: 10,),
                    Row(
                        children: [
                          ElevatedButton(
                              onPressed: (){},
                              child: Text("Download")
                          ),
                          ElevatedButton(
                              onPressed: (){},
                              child: Text("Copiar")
                          ),
                        ],
                      ),
                    SizedBox(height: 10,),
                    TextFormField(
                      maxLines: 6,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Chave Privada",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8
                          )
                      ),
                      controller: secretPhraseController,
                    ),
                  ],
                )
            )
          ],
        )
    );
  }
}

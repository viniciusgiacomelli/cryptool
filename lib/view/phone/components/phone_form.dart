import 'package:flutter/material.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({super.key});

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {

  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController secretTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              ElevatedButton(
                  onPressed: (){},
                  child: Text("Aplicar")
              ),
              SizedBox(height: 16,),
              TextFormField(
                maxLines: 6,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Chave publica",
                    hintText: "Insira seu texto",
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8
                    )
                ),
                controller: cleanTextController,
              ),
              SizedBox(height: 8,),
              TextFormField(
                maxLines: 6,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "chave privada",
                    hintText: "Insira seu texto",
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8
                    )
                ),
                controller: cleanTextController,
              ),
            ],
          ),
        ),
    );
  }
}

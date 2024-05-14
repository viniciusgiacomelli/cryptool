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
              ElevatedButton(
                onPressed: (){},
                child: Text("Decript")
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text("Gerar par de chaves"),
                onPressed: () async {
                  KeyPair keyPair = await cryptoService.generateKeryPair();
                  privateKeyTextController.text = keyPair.privateKey;
                },
              ),
              SizedBox(height: 8,),
              TextFormField(
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

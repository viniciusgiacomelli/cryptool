import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PhoneAesForm extends StatefulWidget {
  const PhoneAesForm({super.key});

  @override
  State<PhoneAesForm> createState() => _PhoneAesFormState();
}

class _PhoneAesFormState extends State<PhoneAesForm> {
  GetIt getIt = GetIt.instance;
  late CryptoService _cryptoService;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController cleanTextController      = TextEditingController();
  final TextEditingController secretTextController     = TextEditingController();
  final TextEditingController publicKeyTextController  = TextEditingController();
  final TextEditingController privateKeyTextController = TextEditingController();

  List<String> algorithms = <String>["512", "256"];
  late String _algorithm;

  @override
  void initState() {
    _cryptoService = getIt.get<CryptoService>();
    _algorithm = algorithms[0];
    super.initState();
  }


  Future<void> _dialogBuilder({
    required BuildContext context,
    required String title,
    required String content,
    required bool activeDownload,
    required String fileName,
    TextEditingController? field
  }){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              IconButton(
                icon: Icon(Icons.close_rounded, color: Colors.indigoAccent,),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
              child: Text(content)
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.download),
                label: Text("Baixar"),
                onPressed: activeDownload ?  (){
                  _cryptoService.save(
                      content: content,
                      type: fileName
                  );
                  Navigator.of(context).pop();
                } : null,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.delete_forever),
              label: Text("Limpar"),
              onPressed: activeDownload ?  (){
                field?.text = "";
                Navigator.of(context).pop();
              } : null,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Text("Texto claro")),
                  Expanded(child: Text("Texto criptografado"))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
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
                      onTap: (){
                        _dialogBuilder(
                          context: context,
                          title: "Texto criptografado",
                          content: secretTextController.text != "" ?
                            secretTextController.text :
                            "Seu texto criptografado aparecerá aqui",
                          activeDownload: secretTextController.text != "",
                          fileName: _algorithm == "RSA" ? "secret_text" : "hash",
                          field: secretTextController
                        );
                      },
                      readOnly: true,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Seu texto criptografado aparecerá aqui",
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
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                      },
                      child: Text("Aplicar", style: TextStyle(
                          color: Colors.white
                      ),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                      onTap: (){
                        _dialogBuilder(
                            context: context,
                            title: "Secret key",
                            content: secretTextController.text != "" ?
                            secretTextController.text :
                            "Insira seu segredo",
                            activeDownload: secretTextController.text != "",
                            fileName: _algorithm == "RSA" ? "secret_text" : "hash",
                            field: secretTextController
                        );
                      },
                      readOnly: true,
                      maxLines: 1,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Seu texto criptografado aparecerá aqui",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8
                          )
                      ),
                      controller: secretTextController,
                    ),
                  ),
                  SizedBox( width: 12,),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                        },
                        child: Text("Gerar secret", style: TextStyle(
                            color: Colors.white
                        ),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            )
                        ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
    );
  }
}

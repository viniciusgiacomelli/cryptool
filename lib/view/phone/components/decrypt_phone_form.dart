import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DecryptPhoneForm extends StatefulWidget {
  const DecryptPhoneForm({super.key});

  @override
  State<DecryptPhoneForm> createState() => _DecryptPhoneFormState();
}

class _DecryptPhoneFormState extends State<DecryptPhoneForm> {
  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController privateKeyTextController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _privateKey = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _dialogBuilder(
      {required BuildContext context,
      required String title,
      required String content,
      required bool activeDownload,
      required String fileName,
      TextEditingController? field}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.indigoAccent,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(child: Text(content)),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text("Baixar"),
              onPressed: activeDownload
                  ? () {
                      context
                          .read<CryptoService>()
                          .save(content: content, type: fileName);
                      Navigator.of(context).pop();
                    }
                  : null,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.delete_forever),
              label: Text("Limpar"),
              onPressed: activeDownload
                  ? () {
                      setState(() {
                        field?.text = "";
                        _privateKey = false;
                      });
                      Navigator.of(context).pop();
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }

  _handleDecrypt() async {
    String? errors;
    if (secretTextController.text == "") {
      errors = "- Cole o texto secreto para descriptografar \n";
    }
    if (!_privateKey) {
      errors = "$errors - Carregue uma chave privada";
    }
    if (errors != null) {
      _dialogBuilder(
          context: context,
          title: "Atenção",
          content: errors,
          activeDownload: false,
          fileName: "");
    } else {
      var cleanText = await context.read<CryptoService>().decryptPKCS(
          secret: secretTextController.text,
          privateKey: privateKeyTextController.text);
      if (cleanText != null) {
        cleanTextController.text = cleanText;
      } else {
        _dialogBuilder(
            context: context,
            title: "Erro",
            content: "Erro ao descriptogarafar",
            activeDownload: false,
            fileName: "Verifique a chave e o texto enviados e tente novamente");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Text("Texto criptografado")),
                Expanded(child: Text("Texto claro")),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: 6,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Insira o texto criptografado",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                    controller: secretTextController,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      _dialogBuilder(
                          context: context,
                          title: "Texto claro",
                          content: cleanTextController.text != ""
                              ? cleanTextController.text
                              : "Seu texto descriptografado aparecerá aqui",
                          activeDownload: cleanTextController.text != "",
                          fileName: "clear_text",
                          field: cleanTextController);
                    },
                    readOnly: true,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Seu texto descriptografado aparecerá aqui",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                    controller: cleanTextController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.upload,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Carregar ... ",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () async {
                    String? secretText =
                        await context.read<CryptoService>().uploadFile();
                    if (secretText != null) {
                      setState(() {
                        secretTextController.text = secretText;
                      });
                    }
                  },
                )),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _handleDecrypt();
                    },
                    child: Text(
                      "Descriptografar",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: () {
                      _dialogBuilder(
                          context: context,
                          title: _privateKey
                              ? "Chave privada"
                              : "Carregue uma chave",
                          content: privateKeyTextController.text != ""
                              ? privateKeyTextController.text
                              : "Carregue uma chave privada",
                          activeDownload: _privateKey,
                          fileName: "private_key",
                          field: privateKeyTextController);
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
                              border:
                                  Border.all(color: Colors.grey, width: 2.0),
                            ),
                            child: Center(
                              child: _privateKey
                                  ? Icon(
                                      Icons.key_rounded,
                                      size: 80,
                                    )
                                  : Icon(Icons.key_rounded,
                                      size: 80, color: Colors.black26),
                            ),
                          ),
                          Text(
                            _privateKey
                                ? "Clique para abrir"
                                : "Carregue uma chave",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    )),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.upload,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Carregar ",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () async {
                    String? publicKey =
                        await context.read<CryptoService>().uploadFile();
                    if (publicKey != null) {
                      setState(() {
                        privateKeyTextController.text = publicKey;
                        _privateKey = true;
                      });
                    }
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

import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({super.key});

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController publicKeyTextController = TextEditingController();
  final TextEditingController privateKeyTextController =
      TextEditingController();

  List<String> algorithms = <String>["RSA", "AES"];
  late String _algorithm;
  bool _publicKey = false;
  bool _privateKey = false;
  bool _generating = false;

  @override
  void initState() {
    _algorithm = algorithms[0];
    super.initState();
  }

  Future<String?> _generateKeyPair() async {
    setState(() {
      _generating = true;
    });
    KeyPair keyPair = await context.read<CryptoService>().generateKeryPair();
    setState(() {
      privateKeyTextController.text = keyPair.privateKey;
      publicKeyTextController.text = keyPair.publicKey;
      _privateKey = true;
      _publicKey = true;
      _generating = false;
    });
    return null;
  }

  Future<bool> _handleUpload(
      {required TextEditingController controller,
      required String field}) async {
    String? publicKey = await context.read<CryptoService>().uploadFile();
    if (publicKey != null) {
      setState(() {
        controller.text = publicKey;
        if (field == "private") {
          _privateKey = true;
        } else {
          _publicKey = true;
        }
      });
      return true;
    }
    return false;
  }

  Future<String> _getPublicKey() async {
    if (publicKeyTextController.text == "") {
      await _generateKeyPair();
      return publicKeyTextController.text;
    }
    return publicKeyTextController.text;
  }

  Future<bool> _applyCriptography() async {
    if (cleanTextController.text == "") {
      _dialogBuilder(
          context: context,
          title: "Atenção",
          content: "Escreva um texto para ser criptografado",
          activeDownload: false,
          fileName: "");
    } else {
      var publicKey = await _getPublicKey();
      var secret = await context.read<CryptoService>().cryptograph(
          message: cleanTextController.text,
          publicKey: _algorithm == "RSA" ? publicKey : null);
      if (secret != null) {
        secretTextController.text = secret;
        return true;
      }
    }
    return false;
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
                      field?.text = "";
                      if (field == privateKeyTextController) {
                        setState(() {
                          _privateKey = false;
                        });
                      } else if (field == publicKeyTextController) {
                        setState(() {
                          _publicKey = false;
                        });
                      }
                      Navigator.of(context).pop();
                    }
                  : null,
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
        padding: EdgeInsets.all(16.0),
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                    controller: cleanTextController,
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
                          title: _algorithm == "RSA"
                              ? "Texto criptografado"
                              : "Hash",
                          content: secretTextController.text != ""
                              ? secretTextController.text
                              : "Seu texto criptografado aparecerá aqui",
                          activeDownload: secretTextController.text != "",
                          fileName:
                              _algorithm == "RSA" ? "secret_text" : "hash",
                          field: secretTextController);
                    },
                    readOnly: true,
                    maxLines: 6,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Seu texto criptografado aparecerá aqui",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
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
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var applied = await _applyCriptography();
                      }
                    },
                    child: Text(
                      "Criptografar",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _handleDecrypt();
                    },
                    child: Text(
                      "Descriptografar",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Gerar novo par de chaves",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        _generating
                            ? SizedBox(
                                height: 17,
                                width: 17,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.cached_rounded,
                                color: Colors.white,
                              )
                      ],
                    ),
                    onPressed: () async {
                      await _generateKeyPair();
                    },
                  ),
                ),
              ],
            ),
            Visibility(
                visible: _algorithm == "RSA",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _dialogBuilder(
                              context: context,
                              title: "Chave pública",
                              content: _publicKey
                                  ? publicKeyTextController.text
                                  : "Carregue ou gere uma nova chave pública",
                              activeDownload: _publicKey,
                              fileName: "public_key",
                              field: publicKeyTextController);
                        },
                        child: Container(
                          width: 140,
                          height: 250,
                          child: Column(
                            children: [
                              Text("Chave publica"),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 2.0),
                                ),
                                child: Center(
                                  child: _publicKey
                                      ? Icon(
                                          Icons.lock,
                                          size: 80,
                                        )
                                      : Icon(
                                          Icons.lock,
                                          size: 80,
                                          color: Colors.black12,
                                        ),
                                  // Text("Gerar chave"),
                                ),
                              ),
                              Text(
                                "Clique para abrir",
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.upload,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Carregar",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigoAccent,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () async {
                                  String? publicKey = await context
                                      .read<CryptoService>()
                                      .uploadFile();
                                  if (publicKey != null) {
                                    setState(() {
                                      publicKeyTextController.text = publicKey;
                                      _publicKey = true;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        )),
                    GestureDetector(
                        onTap: () {
                          _dialogBuilder(
                              context: context,
                              title: _privateKey ? "Chave privada" : "Atenção",
                              content: _privateKey
                                  ? privateKeyTextController.text
                                  : "Carregue ou gere uma chave privada",
                              activeDownload: _privateKey,
                              fileName: "private_key",
                              field: privateKeyTextController);
                        },
                        child: Container(
                          width: 140,
                          height: 250,
                          child: Column(
                            children: [
                              Text("Chave privada"),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 2.0),
                                ),
                                child: Center(
                                  child: _privateKey
                                      ? Icon(
                                          Icons.key_rounded,
                                          size: 80,
                                        )
                                      : Icon(
                                          Icons.key_rounded,
                                          size: 80,
                                          color: Colors.black12,
                                        ),
                                ),
                              ),
                              Text(
                                "Clique para abrir",
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.upload,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Carregar",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigoAccent,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () async {
                                  await _handleUpload(
                                      controller: privateKeyTextController,
                                      field: "private");
                                  //String? privateKey = await _cryptoService.uploadFile();
                                  // if(privateKey != null){
                                  //   setState(() {
                                  //     privateKeyTextController.text = privateKey;
                                  //     _privateKey = true;
                                  //   });
                                  // }
                                },
                              )
                            ],
                          ),
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

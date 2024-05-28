import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  GetIt getIt = GetIt.instance;
  late CryptoService _cryptoService;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController cleanTextController      = TextEditingController();
  final TextEditingController secretTextController     = TextEditingController();
  final TextEditingController publicKeyTextController  = TextEditingController();
  final TextEditingController privateKeyTextController = TextEditingController();

  List<String> algorithms = <String>["RSA", "AES"];
  late String _algorithm;
  bool _privateKey = false;
  bool _publicKey = false;
  bool _generating = false;

  @override
  void initState() {
    _cryptoService = getIt.get<CryptoService>();
    _algorithm = algorithms[0];

    super.initState();
  }

  _clear(){
    cleanTextController.text = "";
    secretTextController.text = "";
    publicKeyTextController.text = "";
    privateKeyTextController.text = "";
    setState(() {
      _privateKey = false;
      _publicKey = false;
    });
  }

  Future<bool> _handleUpload({
    required TextEditingController controller,
    required String field
  }) async {
    String? publicKey = await _cryptoService.uploadFile();
    if(publicKey != null){
      setState(() {
          controller.text = publicKey;
        if(field == "privada"){
          _privateKey = true;
        } else {
          _publicKey = true;
        }
      });
      return true;
    } return false;
  }

  Future<bool> _handleDownload({
    required String content,
    required String fileName
}) async {
      return await _cryptoService.save(
          content: content,
          type: fileName
      );
  }

  Future<String?> _generateKeyPair() async {
    setState(() {
      _generating = true;
      _publicKey = false;
      _privateKey = false;
      publicKeyTextController.text = "";
      privateKeyTextController.text = "";
    });
    KeyPair keyPair = await _cryptoService.generateKeryPair();
    setState(() {
      _generating = false;
      _publicKey = true;
      _privateKey = true;
      publicKeyTextController.text = keyPair.publicKey;
      privateKeyTextController.text = keyPair.privateKey;
    });
    return null;
  }

  Future<bool> _applyCriptography() async {
    var publicKey = await _getPublicKey();
    var secret = await _cryptoService.cryptograph(
        algorithm: _algorithm,
        message: cleanTextController.text,
        publicKey: _algorithm == "RSA" ? publicKey : null
    );
    if(secret != null){
      secretTextController.text = secret;
      return true;
    }
    return false;
  }

  Future<String> _getPublicKey() async {
    if(!_publicKey){
      await _generateKeyPair();
      return publicKeyTextController.text;
    }
    return publicKeyTextController.text;
  }

  _handleDecrypt() async {
    String? errors;
    if(secretTextController.text == ""){
      errors = "- Cole o texto secreto para decrifrar \n";
    }
    if(!_privateKey){
      errors = "$errors - Carregue uma chave privada";
    }
    if(errors != null){
      cleanTextController.text = errors;
    } else {
      var cleanText = await _cryptoService.decryptPKCS(
          secret: secretTextController.text,
          privateKey: privateKeyTextController.text
      );
      if(cleanText != null){
        cleanTextController.text = cleanText;
      } else{
        cleanTextController.text = "ERRO! Esta chave não foi capaz de descriptografar o texto";
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 1400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: TextStyle( color: Colors.white),
                          dropdownColor: Colors.indigoAccent,
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
                              _clear();
                              _algorithm = brandValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox( width: 8,),
                    Text("algoritmo", style:
                      GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 18,
                        )
                      )
                    ),
                  ],
                ),
                SizedBox( height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded( flex:2, child: Text("Texto claro" ,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 18
                        )
                      ),
                    )),
                    Expanded( flex:1, child: SizedBox()),
                    Expanded( flex:2, child: Text("Texto criptografado",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 18
                          )
                      ),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        maxLines: 8,
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
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                                width: double.maxFinite,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await _applyCriptography();
                                    },
                                    label: Text("Criptografar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.keyboard_double_arrow_right_rounded,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigoAccent,
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        )
                                    ),
                                  ),
                                ),
                            ),
                            SizedBox(height: 6,),
                            Visibility(
                              visible: _algorithm == "RSA",
                              child: SizedBox(
                                  width: double.maxFinite,
                                  child: ElevatedButton.icon(
                                    onPressed: (){
                                      _handleDecrypt();
                                    },
                                    label: Text("Descriptografar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
                                    ),
                                    icon: Icon(Icons.keyboard_double_arrow_left_rounded,
                                      color: Colors.white,
                                      textDirection: TextDirection.ltr,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigoAccent,
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        )
                                    ),
                                  ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        maxLines: 8,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                SizedBox(height: 15,),
                Visibility(
                  visible: _algorithm == "RSA",
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                          child:Container(
                            padding: EdgeInsets.all(8),
                            height: 400,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1)
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey,
                                              width: 2.0
                                          ),
                                        ),
                                        child: Center(
                                          child: _publicKey ?
                                          Icon( Icons.key_rounded, size: 80,) :
                                          Icon( Icons.key_rounded, size: 80, color: Colors.black12,),
                                          // Text("Gerar chave"),
                                        ),
                                      ), // ChaveIcon
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text("Chave publica",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w200
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton.icon(
                                                        onPressed:(){
                                                          _handleUpload(
                                                              controller: publicKeyTextController,
                                                              field: "publica"
                                                          );
                                                        },
                                                        icon: Icon(Icons.upload, color: Colors.white,),
                                                        label: Text("Upload",
                                                          style: TextStyle(
                                                              color: Colors.white
                                                          ),
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.indigoAccent,
                                                            padding: EdgeInsets.symmetric(vertical: 15),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8)
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8,),
                                                    Expanded(
                                                      child: ElevatedButton.icon(
                                                        onPressed: _publicKey ? (){
                                                          _handleDownload(
                                                              content: publicKeyTextController.text,
                                                              fileName: "public_key"
                                                          );
                                                        } : null,
                                                        icon: Icon(Icons.download, color: Colors.white,),
                                                        label: Text("Download",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
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
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8,),
                                TextFormField(
                                  readOnly: true,
                                  maxLines: 10,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Carregue ou gere uma chave publica",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 8
                                      )
                                  ),
                                  controller: publicKeyTextController,
                                ),
                              ],
                            ),
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Visibility(
                            visible: _algorithm == "RSA",
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigoAccent,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Gerar novo par\n de chaves",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox( width: 8,),
                                  _generating ?
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  ) :
                                  Icon(Icons.cached_rounded, color: Colors.white,)
                                ],
                              ),
                              onPressed: () async {
                                await _generateKeyPair();
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 400,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1)
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey,
                                              width: 2.0
                                          ),
                                        ),
                                        child: Center(
                                          child: _privateKey ?
                                          Icon( Icons.lock, size: 80,) :
                                          Icon( Icons.lock, size: 80, color: Colors.black12,),
                                          // Text("Gerar chave"),
                                        ),
                                      ), // ChaveIcon
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text("Chave privada",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w200
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton.icon(
                                                        onPressed:(){
                                                          _handleUpload(
                                                              controller: privateKeyTextController,
                                                              field: "privada"
                                                          );
                                                        },
                                                        icon: Icon(Icons.upload, color: Colors.white,),
                                                        label: Text("Upload",
                                                          style: TextStyle(
                                                              color: Colors.white
                                                          ),
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.indigoAccent,
                                                            padding: EdgeInsets.symmetric(vertical: 15),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8)
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8,),
                                                    Expanded(
                                                      child: ElevatedButton.icon(
                                                        onPressed: _privateKey ? (){
                                                          _handleDownload(
                                                              content: privateKeyTextController.text,
                                                              fileName: "private_key"
                                                          );
                                                        } : null,
                                                        icon: Icon(Icons.download, color: Colors.white,),
                                                        label: Text("Download",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
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
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8,),
                                TextFormField(
                                  readOnly: true,
                                  maxLines: 10,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Carregue ou gere uma chave privada",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 8
                                      )
                                  ),
                                  controller: privateKeyTextController,
                                ),
                              ],
                            ),
                          )
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}

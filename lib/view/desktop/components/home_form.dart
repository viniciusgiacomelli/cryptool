import 'package:cryptool/view/desktop/components/key_card.dart';
import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

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
  bool _generatedKeys = false;
  bool _generating = false;

  @override
  void initState() {
    _cryptoService = getIt.get<CryptoService>();
    _algorithm = algorithms[0];
    super.initState();
  }

  Future<String?> _generateKeyPair() async {
    setState(() {
      _generating = true;
    });
    KeyPair keyPair = await _cryptoService.generateKeryPair();
    publicKeyTextController.text = keyPair.publicKey;
    privateKeyTextController.text = keyPair.privateKey;
    setState(() {
      _generating = false;
      _generatedKeys = true;
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
    if(publicKeyTextController.text == ""){
      await _generateKeyPair();
      return publicKeyTextController.text;
    }
    return publicKeyTextController.text;
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
                Column(
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
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
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
                                    onPressed: (){},
                                    label: Text("Criptografar"),
                                    icon: Icon(Icons.arrow_back),
                                  ),
                                ),
                            ),
                            SizedBox(height: 6,),
                            SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton.icon(
                                  onPressed: (){},
                                  label: Text("Descriptografar"),
                                  icon: Icon(Icons.arrow_back),
                                ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
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
                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                        child: KeyCard(
                          textController: publicKeyTextController,
                          active: publicKeyTextController.text != "",
                          iconData: Icons.key_rounded,
                        ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Visibility(
                          visible: _algorithm == "RSA",
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Gerar novo par\n de chaves"),
                                SizedBox( width: 8,),
                                _generating ?
                                SizedBox(
                                  height: 8,
                                  width: 8,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ) :
                                SizedBox( width: 8,)
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
                        child: KeyCard(
                          textController: privateKeyTextController,
                          active: privateKeyTextController.text != "",
                          iconData: Icons.lock,
                        ),
                    ),

                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}

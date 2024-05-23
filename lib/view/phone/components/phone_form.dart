import 'package:cryptool/viewmodel/services/crypto_service.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({super.key});

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
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

  Future<String> _getPublicKey() async {
    if(publicKeyTextController.text == ""){
      await _generateKeyPair();
      return publicKeyTextController.text;
    }
    return publicKeyTextController.text;
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

  Future<void> _dialogBuilder(
      BuildContext context,
      String title,
      String content
    ){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
              child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Copiar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                      onTap: (){
                        _dialogBuilder(
                          context,
                          _algorithm == "RSA" ? "Texto secreto" : "Hash",
                          secretTextController.text
                        );
                      },
                      readOnly: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: DropdownButton(
                      iconSize: 40.0,
                      isExpanded: true,
                      isDense: true,
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
                          cleanTextController.text = "";
                          secretTextController.text = "";
                        });
                      },
                    ),
                  ),
                  SizedBox( width: 12,),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          var applied = await _applyCriptography();
                        },
                        child: Text("Aplicar")
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Visibility(
                visible: _algorithm == "RSA",
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Gerar novo par de chaves"),
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
              SizedBox(height: 16,),
              Visibility(
                visible: _algorithm == "RSA",
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: (){
                            _dialogBuilder(
                              context,
                              "Chave pública",
                              publicKeyTextController.text
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 250,
                            child: Column(
                              children: [
                                Text("Chave publica"),
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
                                    child: _generatedKeys ?
                                    Icon( Icons.lock, size: 80,) :
                                    Text("Gerar chave"),
                                    // Text("Gerar chave"),
                                  ),
                                ),
                                Text("Clique para abrir", style: TextStyle(fontSize: 10),),
                                SizedBox(height: 6,),
                                ElevatedButton(
                                    onPressed: _generatedKeys ? (){} : null,
                                    child: Text("Baixar")
                                )
                              ],
                            ),
                          )
                      ),
                      GestureDetector(
                          onTap: (){
                            _dialogBuilder(
                                context,
                                "Chave privada",
                              privateKeyTextController.text
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 250,
                            child: Column(
                              children: [
                                Text("Chave privada"),
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
                                    child: _generatedKeys ?
                                    Icon( Icons.key_rounded, size: 80,) :
                                    Text("Gerar chave"),
                                  ),
                                ),
                                Text("Clique para abrir", style: TextStyle(fontSize: 10),),
                                SizedBox(height: 6,),
                                ElevatedButton(
                                    onPressed: _generatedKeys ? (){} : null,
                                    child: Text("Baixar")
                                )
                              ],
                            ),
                          )
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
    );
  }
}

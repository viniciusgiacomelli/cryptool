import 'dart:math';
import 'dart:typed_data';

import 'package:cryptool/viewmodel/services/cripto_service_aes.dart';
import 'package:cryptool/viewmodel/services/crypto_service_hash.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopHashForm extends StatefulWidget {
  const DesktopHashForm({super.key});

  @override
  State<DesktopHashForm> createState() => _DesktopHashFormState();
}

class _DesktopHashFormState extends State<DesktopHashForm> {
  GetIt getIt = GetIt.instance;
  late CryptoServiceHash _cryptoServiceHash;

  final _formKey = GlobalKey<FormState>();


  final TextEditingController cleanTextController      = TextEditingController();
  final TextEditingController secretTextController     = TextEditingController();
  final TextEditingController keyController            = TextEditingController();

  List<String> hashes = <String>["512", "256", "MD5"];
  late String _hash;

  @override
  void initState() {
    _cryptoServiceHash = getIt.get<CryptoServiceHash>();
    _hash = hashes[0];
    super.initState();
  }

  _handleEncrypt() async {
    String secret = await _cryptoServiceHash.cryptograph(
        message: cleanTextController.text,
        hash: _hash
    );
    secretTextController.text = secret;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
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
                  SizedBox( width: 32,),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      maxLines: 6,
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
              SizedBox( height: 32,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Hash size:"),
                  SizedBox( width: 16,),
                  SizedBox(
                    width: 250,
                    child: DropdownButton(
                      iconSize: 40.0,
                      isExpanded: true,
                      isDense: true,
                      iconEnabledColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      borderRadius: BorderRadius.circular(10),
                      items: hashes.map<DropdownMenuItem<String>>((String? sizeValue) =>
                          DropdownMenuItem<String>(
                              value:sizeValue,
                              child: Text("$sizeValue")
                          )
                      ).toList(),
                      value: _hash,
                      onChanged: (String? sizeValue){
                        setState(() {
                          _hash = sizeValue!;
                          cleanTextController.text = "";
                          secretTextController.text = "";
                        });
                      },
                    ),
                  ),
                  SizedBox( width: 32,),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        _handleEncrypt();
                      },
                      label: Text("Gerar hash",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      icon: Icon(
                        Icons.calculate_outlined,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cryptool/viewmodel/services/crypto_service_hash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneHashForm extends StatefulWidget {
  const PhoneHashForm({super.key});

  @override
  State<PhoneHashForm> createState() => _PhoneHashFormState();
}

class _PhoneHashFormState extends State<PhoneHashForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cleanTextController = TextEditingController();
  final TextEditingController secretTextController = TextEditingController();
  final TextEditingController publicKeyTextController = TextEditingController();
  final TextEditingController privateKeyTextController =
      TextEditingController();

  List<String> hashes = <String>["512 bytes", "256 bytes", "MD5"];
  late String _hash;

  @override
  void initState() {
    _hash = hashes[0];
    super.initState();
  }

  _handleEncrypt() async {
    String secret = await context
        .read<CryptoServiceHash>()
        .cryptograph(message: cleanTextController.text, hash: _hash);
    secretTextController.text = secret;
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
                Expanded(child: Text("Hash do texto"))
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
                  child: DropdownButton(
                    iconSize: 40.0,
                    isExpanded: true,
                    isDense: true,
                    iconEnabledColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    borderRadius: BorderRadius.circular(10),
                    items: hashes
                        .map<DropdownMenuItem<String>>((String? hashValue) =>
                            DropdownMenuItem<String>(
                                value: hashValue,
                                child: Text("Hash $hashValue")))
                        .toList(),
                    value: _hash,
                    onChanged: (String? hashValue) {
                      setState(() {
                        _hash = hashValue!;
                        cleanTextController.text = "";
                        secretTextController.text = "";
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _handleEncrypt();
                    },
                    child: Text(
                      "Aplicar",
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
          ],
        ),
      ),
    );
  }
}

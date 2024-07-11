import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class CryptoServiceAes{

  Encrypted encrypt({required String message, required String secret}){
    final key = Key.fromUtf8(secret);
    final iv = IV.allZerosOfLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(message, iv: iv);
    return encrypted;
  }

  decrypt({required Encrypted encrypted, required String secret}){
    //String cypher = String.fromCharCodes(base64Decode(message));
    final key = Key.fromUtf8(secret);
    final iv = IV.allZerosOfLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final plainMessage = encrypter.decrypt(encrypted, iv:iv);
    return plainMessage;
  }
}
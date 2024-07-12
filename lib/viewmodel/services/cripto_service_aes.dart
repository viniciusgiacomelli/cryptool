import 'dart:convert';
import 'dart:math';

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
    try{
      //String cypher = String.fromCharCodes(base64Decode(message));
      final key = Key.fromUtf8(secret);
      final iv = IV.allZerosOfLength(16);

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      final plainMessage = encrypter.decrypt(encrypted, iv:iv);
      return plainMessage;
    }catch(e){
      return "Nao foi possivel descriptografar a mensagem";
    }
  }

  String generateKey(){
    Random _rnd = Random();
    var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    String key = String.fromCharCodes(Iterable.generate(32, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return key;
  }

}
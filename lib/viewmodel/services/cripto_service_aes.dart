import 'package:encrypt/encrypt.dart';

class CryptoServiceAes{

  String encrypt({required String message, required String secret}){
    final key = Key.fromUtf8(secret);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(message, iv: iv);
    return encrypted.base64;
  }

  decrypt({required String message, required String secret}){
    final key = Key.fromUtf8(secret);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final plainMessage = encrypter.decrypt64(message, iv:iv);
    return plainMessage;
  }
}
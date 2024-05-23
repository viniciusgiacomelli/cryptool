import 'dart:convert';
import 'dart:io';

import 'package:fast_rsa/fast_rsa.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'web_downloader_service.dart';

class CryptoService {

  Future<KeyPair> generateKeryPair() async {
    KeyPair keyPair = await RSA.generate(2048);
    return keyPair;
  }

  Future<String?> cryptograph({
    required String algorithm,
    required String message,
    String? publicKey
  }) async {
    switch(algorithm){
      case "RSA":
        var result = await RSA.encryptPKCS1v15(message,publicKey!);
        return result;
      case "AES":
        var result = await RSA.hash(message, Hash.SHA512);
        return result;
      default:
        return null;
    }
  }

  Future<String?> decryptPKCS({
    required String secret,
    required String privateKey
  }) async {

    var message = await RSA.decryptPKCS1v15(secret, privateKey);
    return message;

  }

  Future<bool> saveKey({required String key, required String type}) async {
    //var file = File("$key.pub");
    if(kIsWeb){
      var bytes = utf8.encode(key);
      WebDownloaderService.download(bytes, downloadName: "$type.txt");
    }

    return false;
  }

  Future<String?> uploadKey() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? unit8List = result.files.single.bytes;
      String string = String.fromCharCodes(unit8List!);
      return string;
    } else {
      return null;
    }
  }


}
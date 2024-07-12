import 'dart:convert';

import 'dart:io' show Platform;
import 'package:fast_rsa/fast_rsa.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'web_downloader_service.dart';

class CryptoServiceHash {

  Future<String> cryptograph({
    required String message,
    String? hash
  }) async {
    try{
      switch(hash){
        case "512":
          var result = await RSA.hash(message, Hash.SHA512);
          return result;
        case "256":
          var result = await RSA.hash(message, Hash.SHA256);
          return result;
        case "MD5":
          var result = await RSA.hash(message, Hash.MD5);
          return result;
        default:
          var result = await RSA.hash(message, Hash.SHA512);
          return result;
      }
    } on Exception {
      return "ERRO! - Não foi possível criptografar corretamente a mensagem";
    }
  }




}
import 'dart:convert';

import 'package:fast_rsa/fast_rsa.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'web_downloader_service.dart';

class CryptoService extends ChangeNotifier {
  Future<KeyPair> generateKeryPair() async {
    KeyPair keyPair = await RSA.generate(2048);
    return keyPair;
  }

  Future<String?> cryptograph(
      {required String message, String? publicKey}) async {
    try {
      var result = await RSA.encryptPKCS1v15(message, publicKey!);
      return result;
    } on Exception {
      return "ERRO! - Não foi possível criptografar corretamente a mensagem";
    }
  }

  Future<String?> decryptPKCS(
      {required String secret, required String privateKey}) async {
    try {
      var message = await RSA.decryptPKCS1v15(secret, privateKey);
      return message;
    } on Exception {
      return null;
    }
  }

  Future<bool> save({required String content, required String type}) async {
    if (kIsWeb) {
      var bytes = utf8.encode(content);
      WebDownloaderService.download(bytes, downloadName: "$type.txt");
    }

    return false;
  }

  Future<String?> uploadFile() async {
    FilePickerResult? result;
    if (kIsWeb) {
      result = await FilePicker.platform.pickFiles();
    } else {
      result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
    }

    if (result != null) {
      Uint8List? unit8List = result.files.single.bytes;
      String string = String.fromCharCodes(unit8List!);
      return string;
    } else {
      return null;
    }
  }
}

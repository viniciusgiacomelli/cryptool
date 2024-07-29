import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;

class CryptoServiceAes extends ChangeNotifier {
  Encrypted encrypt({required String message, required String secret}) {
    final key = Key.fromUtf8(secret);
    final iv = IV.allZerosOfLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(message, iv: iv);
    return encrypted;
  }

  decrypt({required Encrypted encrypted, required String secret}) {
    try {
      final key = Key.fromUtf8(secret);
      final iv = IV.allZerosOfLength(16);

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      final plainMessage = encrypter.decrypt(encrypted, iv: iv);
      return plainMessage;
    } catch (e) {
      return "Nao foi possivel descriptografar a mensagem";
    }
  }

  String generateKey({int? length}) {
    Random _rnd = Random();
    var _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    String key = String.fromCharCodes(
      Iterable.generate(
        length ?? 32,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
    return key;
  }
}

import 'package:fast_rsa/fast_rsa.dart';

class CryptoService {

  Future<KeyPair> generateKeryPair() async {
    KeyPair keyPair = await RSA.generate(2048);
    return keyPair;
  }

  Future<String> cryptograph({required String message, required String publicKey}) async {
    var result = await RSA.encryptPKCS1v15(message,publicKey);
    return result;
  }

}
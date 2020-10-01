class RSA {
  final int _p1;
  final int _p2;

  var _n;
  var _publicKey;
  var _privateKey;

  int get publicKey => _publicKey;
  int get privateKey => _privateKey;

  RSA(this._p1, this._p2) {
    _n = _p1 * _p2;
    _generateKeys();
  }

  void _generateKeys() {
    var phi = (_p1 - 1) * (_p2 - 1);

    for (_publicKey = 2; _publicKey.gcd(phi) > 1; _publicKey++) {}

    var e = phi + 1;
    while (e % _publicKey > 0) {
      e += phi;
    }

    _privateKey = e ~/ _publicKey;
  }

  List<int> decrypt(List<int> msg) =>
      msg.map((n) => n.modPow(_publicKey, _n)).toList();

  List<int> encrypt(List<int> msg) =>
      msg.map((n) => n.modPow(_privateKey, _n)).toList();
}

class SymmetricKey {
  final _publicKey;

  SymmetricKey(this._publicKey);

  List<int> decrypt(List<int> msg) => msg.map((n) => n ^ _publicKey).toList();

  List<int> encrypt(List<int> msg) => decrypt(msg);
}

void main() {
  var msg = "Hello!";
  var symmetricKey = SymmetricKey(192);
  var rsa = RSA(101, 103);

  var decrypted = rsa.decrypt(symmetricKey.decrypt(msg.codeUnits.toList()));
  print(decrypted);

  var encrypted = symmetricKey
      .encrypt(rsa.encrypt(decrypted))
      .fold("", (i, j) => i + String.fromCharCode(j));
  print(encrypted);
}

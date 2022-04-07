import 'package:jose/jose.dart';

class Token {
  final String token;
  final String refreshToken;

  List<String> roles;
  String username;

  Token({this.token, this.refreshToken}) {
    var jwt = new JsonWebToken.unverified(this.token);
    var claims = jwt.claims.toJson();
    var us = claims['username'] ?? 'Gast';
    List<dynamic> roles = claims['roles'];
    this.roles = roles.cast<String>().toList(growable: false);
    this.username = us;
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }

  bool isValid() {
    var jwt = new JsonWebToken.unverified(this.token);
    print("claims: ${jwt.claims}");
    print("Created At ${jwt.claims.issuedAt.toIso8601String()}");
    print("Valid until ${jwt.claims.expiry.toIso8601String()}");

    // Verify that the token is still valid
    if (jwt.claims.expiry.isBefore(new DateTime.now())) {
      return false;
    }

    return true;

  }

  bool isRefreshTokenValid() {
    return this.refreshToken.isNotEmpty;
  }

  bool hasRole(String role) {
    return this.roles.contains(role);
  }

  @override
  String toString() => 'LoggedIn { token: $token ; refresh_token $refreshToken }';
}
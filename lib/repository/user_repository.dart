import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:flutterhomejobs/model/token.dart';

class UserRepository {
  static const URL = 'https://home-jobs.simple-student.de/mobile-app';
  final storage = new FlutterSecureStorage();
  static String lastUsername = '';

  Future<Token> authenticate({
    @required String username,
    @required String password,
  }) async {
    var response = await http.post(URL + '/login_check', body: {
      '_username': username, '_password': password
    });

    print('URL: ${URL + '/login_check'}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Throws error if login failed
    if (response.statusCode != 200 || response.body.isEmpty) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'refresh_token');

      throw new Exception('Authentication Failed!');
    }

    return _handleRequest(json.decode(response.body));
  }


  Future<Token> refreshToken(Token token) async {

    print('Refresh access token...');

    var response = await http.post(URL + '/token/refresh', body: {
      'refresh_token': token.refreshToken
    });

    print('URL: ${URL + '/token/refresh'}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Throws error if login failed
    if (response.statusCode != 200 || response.body.isEmpty) {
      await this.deleteToken();

      throw new Exception('Authentication failed!');
    }

    return _handleRequest(json.decode(response.body));
  }

  Future<Token> _handleRequest(dynamic data) async {
    var token = Token.fromJson(data);

    if(!token.isValid()) {
      await this.deleteToken();
      throw new Exception('Invalid api token received!');
    }
    await this.persistToken(token);
    UserRepository.lastUsername = token.username;

    return token;
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await storage.delete(key: 'token');
    await storage.delete(key: 'refresh_token');
    await storage.delete(key: 'username');
    UserRepository.lastUsername = null;

    return;
  }

  Future<void> persistToken(Token token) async {

    await storage.write(key: 'token', value: token.token);
    await storage.write(key: 'refresh_token', value: token.refreshToken);
    await storage.write(key: 'username', value: token.username);

    return;
  }

  Future<bool> hasToken() async {
    return null != await this.getToken();
  }

  Future<Token> getToken() async {
    final token = await storage.read(key: 'token');
    final refreshToken = await storage.read(key: 'refresh_token');

    if(null == token && null == refreshToken) {
      UserRepository.lastUsername = null;
      return null;
    }

    try {
      var t = Token(token: token, refreshToken: refreshToken);

      if (!t.isValid() && !t.isRefreshTokenValid()) {
        UserRepository.lastUsername = null;
        return null;
      }

      if (!t.isValid() && t.isRefreshTokenValid()) {
        return this.refreshToken(t);
      }

      UserRepository.lastUsername = t.username;
      return t;
    } catch(_) {
      print(_);
      await this.deleteToken();
      return null;
    }
  }
}
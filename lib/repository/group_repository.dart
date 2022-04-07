import 'dart:convert';
import 'dart:io';

import 'package:flutterhomejobs/model/group.dart';
import 'package:flutterhomejobs/repository/user_repository.dart';
import 'package:http/http.dart' as http;

class GroupRepository {
  static const URL = 'home-jobs.simple-student.de';
  final UserRepository userRepository;

  GroupRepository(this.userRepository);

  Future<List<Group>> getGroups() async {
    var uri = Uri.https(URL, '/mobile-app/group');
    var token = await this.userRepository.getToken();

    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.token
    });

    print('URL: ${uri.toString()}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Group.fromJson(rawPost);
      }).toList();
    }

    throw Exception('Error fetching groups data');
  }

  Future<Group> getGroup(int groupId) async {
    var uri = Uri.https(URL, '/mobile-app/group/show/' + groupId.toString());
    var token = await this.userRepository.getToken();

    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.token
    });

    print('URL: ${uri.toString()}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Group.fromJson(data);
    }

    throw Exception('Error fetching group details data');
  }
}
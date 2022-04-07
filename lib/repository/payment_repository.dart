import 'dart:convert';
import 'dart:io';

import 'package:flutterhomejobs/model/payment.dart';
import 'package:flutterhomejobs/model/payment_category.dart';
import 'package:flutterhomejobs/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PaymentRepository {
  static const URL = 'home-jobs.simple-student.de';
  final UserRepository userRepository;

  PaymentRepository(this.userRepository);

  Future<List<Payment>> getPayments(int wallet) async {
    var uri = Uri.https(URL, '/mobile-app/payment/' + wallet.toString());
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
        return Payment.fromJson(rawPost);
      }).toList();
    }

    throw Exception('Error fetching payment data');
  }

  Future<Payment> getPayment(int id) async {
    var uri = Uri.https(URL, '/mobile-app/payment/show/' + id.toString());
    var token = await this.userRepository.getToken();

    var response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.token
    });

    print('URL: ${uri.toString()}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Payment.fromJson(data);
    }

    throw Exception('Error fetching payment');
  }

  Future<void> createPayment(Payment payment, int wallet) async {
    var uri = Uri.https(URL, '/mobile-app/payment/add/' + wallet.toString());
    var token = await this.userRepository.getToken();

    final format = DateFormat('yyyy-MM-dd');

    var body = {
      'name': payment.name,
      'amount': payment.amount.toString(),
      'description': payment.description,
      'paymentCategory': payment.paymentCategory.toString(),
      'paymentDate': format.format(payment.paymentDate),
    };

    print('Body: $body');

    var response = await http.post(uri, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.token
    }, body: body);

    print('URL: ${uri.toString()}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw new Exception("Error create payment!");
    }
  }

  Future<bool> deletePayment(Payment payment) async {
    var uri = Uri.https(URL, '/mobile-app/payment/remove/' + payment.id.toString());
    var token = await this.userRepository.getToken();

    var response = await http.delete(uri, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token.token
    });

    print('URL: ${uri.toString()}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw new Exception("Error deleting payment!");
    }

    return true;
  }

  Future<void> patchPayment(Payment payment) async {
    var uri = Uri.https(URL, '/mobile-app/payment/edit/' + payment.id.toString());
    var token = await this.userRepository.getToken();

    var format = DateFormat('yyyy-MM-dd');

    var body = {
      'name': payment.name.toString(),
      'amount': payment.amount.toString(),
      'description': payment.description.toString(),
      'paymentDate': format.format(payment.paymentDate),
      'paymentCategory': payment.paymentCategory.toString(),
    };

    var response = await http.patch(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' + token.token
    }, body: body);

    print('URL: ${uri.toString()}');
    print('Body: ${body.toString()}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw new Exception("Error update payment!");
    }
  }

  Future<List<PaymentCategory>> getCategories() async {
    var uri = Uri.https(URL, '/mobile-app/payment-category');
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
        return PaymentCategory.fromJson(rawPost);
      }).toList();
    }

    throw Exception('Error fetching payment category data');
  }
}
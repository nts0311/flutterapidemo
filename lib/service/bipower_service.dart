import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterapidemo/model/attendance_history.dart';
import 'package:flutterapidemo/screen/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import '../viewmodel/login_viewmodel.dart';

class Result<T> {
  final T? value;
  final String? error;

  bool get isSuccess => error == null;
  Result({this.value, this.error});
}

typedef JsonMap = Map<String, dynamic>;

class NetworkService {
  static String baseUrl = "gw-bipower.biplus.com.vn";

  static NetworkService? _instance;

  NetworkService._();

  static NetworkService get instance => _instance ??= NetworkService._();

  BuildContext? buildContext;

  String? jwtToken;

  Future<Map<String, String>> getDefaultHeaders() async {
    var dict = {
      'Accept':'application/json, text/plain, */*',
      'Accept-Language':'vi-VN',
      'Content-Type': 'application/json'
    };

    if (jwtToken == null) {
      final prefs = await SharedPreferences.getInstance();
      jwtToken = prefs.getString('jwt');
    }

    dict['Authorization'] = 'Bearer $jwtToken';

    return dict;
  }

  Future<JsonMap?> postJson<T>(String endpoint, {Map<String, String>? header, JsonMap? body}) async {
    print('request: $endpoint');
    final uri = Uri.https(baseUrl, endpoint);
    final finalHeaders = (header != null) ? header : await getDefaultHeaders();
    final response = await http.post(
      uri,
      headers: finalHeaders,
      body: jsonEncode(body)
    );

    return checkResponse(response);
  }

  Future<JsonMap?> postFormData<T>(String endpoint, {Map<String, String>? headers, Map<String, String>? body}) async {
    final uri = Uri.https(baseUrl, endpoint);
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll((headers != null) ? headers : await getDefaultHeaders())
      ..fields.addAll(body ?? {});

    var responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    return checkResponse(response);
  }

  JsonMap? checkResponse(http.Response response) {
    if (response.statusCode == 401) {

      if (buildContext != null) {
        LoginScreen.toLoginScreen(buildContext!);
      }
    } else {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<Result<User>> login(String username, String password) async {
    var headers = await getDefaultHeaders();
    headers['Authorization'] = 'Basic YXV0aG9yaXphdGlvbl9jbGllbnRfaWQ6YmNjczM=';
    var formData = {
      'grant_type': 'password',
      'username': username,
      'password': password
    };
    final json = await postFormData('/oauth/token', headers: headers, body: formData);

    if (json != null) {
      return Result(value: User.fromJson(json), error: null);
    } else {
      return Result(value: null, error: 'Có lỗi xảy ra');
    }
  }

  Future<Result<List<AttendanceHistory>>> getHistory() async {
    final date = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final body = {
      'historyInMonth': DateFormat('dd/MM/yyyy').format(date)
    };

    final json = await postJson('salary/attendance/history', body: body);

    if (json != null) {

      bool isSuccess = json['success'] as bool? ?? false;

      if (isSuccess) {
        final listAttendanceHistory = AttendanceHistory.recipesFromSnapshot(json['data']['workingTimeDetails']);
        return Result(value: listAttendanceHistory);
      } else {
        return Result(value: null, error: 'Có lỗi xảy ra');
      }

    } else {
      return Result(value: null, error: 'Có lỗi xảy ra');
    }
  }

  Future<Result<bool>> checkin() async {

    final json = await postJson('salary/attendance/checkin');

    if (json != null) {

      bool isSuccess = json['success'] as bool? ?? false;

      if (isSuccess) {
        return Result(value: isSuccess);
      } else {
        return Result(value: null, error: 'Có lỗi xảy ra');
      }

    } else {
      return Result(value: null, error: 'Có lỗi xảy ra');
    }
  }

  Future<Result<bool>> checkout() async {

    final json = await postJson('salary/attendance/checkout');

    if (json != null) {

      bool isSuccess = json['success'] as bool? ?? false;

      if (isSuccess) {
        return Result(value: isSuccess);
      } else {
        return Result(value: null, error: 'Có lỗi xảy ra');
      }

    } else {
      return Result(value: null, error: 'Có lỗi xảy ra');
    }
  }

  Future<Result<bool>> logout() async {

    final json = await postJson('oauth/logout');

    if (json != null) {

      bool isSuccess = json['status']['success'] as bool? ?? false;

      if (isSuccess) {
        return Result(value: isSuccess);
      } else {
        return Result(value: null, error: 'Có lỗi xảy ra');
      }

    } else {
      return Result(value: null, error: 'Có lỗi xảy ra');
    }
  }

  Future<Result<bool>> editTime(Map<String, dynamic> params) async {

    final json = await postJson('saga/salary/attendance/create-request-add-new-working-time', body: params);

    if (json != null) {

      bool isSuccess = json['success'] as bool? ?? false;

      if (isSuccess) {
        return Result(value: isSuccess);
      } else {
        return Result(value: null, error: json['message']);
      }

    } else {
      return Result(value: null, error: 'Có lỗi xảy ra');
    }
  }

}



extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}
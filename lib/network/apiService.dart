import 'package:dio/dio.dart';

class Apiservice {
  static const String baseUrl =
      "https://4e55-197-132-247-156.ngrok-free.app/api/";

  final dio = Dio();
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    final response = await dio.post(baseUrl + endpoint, data: data);
    return response;
  }
}

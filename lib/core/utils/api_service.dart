import 'package:dio/dio.dart';

class ApiService {
  final _baseUrl = "https://www.googleapis.com/books/v1/";
  final _apiKey = 'AIzaSyBhPP6ZSLrcChbm5HZEW02aWwYM9xmryu8';
  final Dio _dio;

  ApiService(this._dio);
  Future<Map<String, dynamic>> get({required String endpoint , required Map<String, String> queryParameters}) async {
    try {
      var response = await _dio.get(
        '$_baseUrl$endpoint',
        queryParameters: {'key': _apiKey, ...queryParameters},
      );

      return response.data;
    } on DioException catch (e) {
     
      return e.response?.data ?? {'error': 'Unknown error occurred'};
    }
  }
}

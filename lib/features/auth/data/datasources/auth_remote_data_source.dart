import 'package:flutter_feeder/core/network/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> login(String email) async {
    final response = await _dioClient.dio.post(
      '/api/mahasiswa/login',
      data: {'email': email},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getBiodata() async {
    final response = await _dioClient.dio.get('/api/mahasiswa/biodata');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await _dioClient.dio.post('/api/mahasiswa/logout');
    return response.data as Map<String, dynamic>;
  }
}

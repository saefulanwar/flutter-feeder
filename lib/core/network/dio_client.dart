import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Do something before request is sent
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Do something with response data
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Do something with response error
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}

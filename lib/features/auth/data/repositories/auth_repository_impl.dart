import 'package:either_dart/either.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/storage/secure_storage_client.dart';

class AuthRepositoryImpl {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageClient _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  Future<Either<String, String>> loginWithEmail(String email) async {
    try {
      final data = await _remoteDataSource.login(email);
      if (data['success'] == true && data['data'] != null && data['data']['token'] != null) {
        final token = data['data']['token'] as String;
        await _secureStorage.saveToken(token);
        return Right(token);
      } else {
        return Left(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> getBiodata() async {
    try {
      final data = await _remoteDataSource.getBiodata();
      if (data['success'] == true && data['data'] != null) {
        return Right(data['data'] as Map<String, dynamic>);
      } else {
        return Left(data['message'] ?? 'Failed to get biodata');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> logout() async {
    try {
      final data = await _remoteDataSource.logout();
      await _secureStorage.deleteToken();
      if (data['success'] == true) {
        return const Right(true);
      } else {
        return const Right(true);
      }
    } catch (e) {
      await _secureStorage.deleteToken();
      return const Right(true);
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getToken();
    return token != null;
  }
}

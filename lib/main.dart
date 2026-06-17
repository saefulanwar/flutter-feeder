import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/routing/app_router.dart';
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependensi
  const secureStorage = FlutterSecureStorage();
  final storageClient = SecureStorageClient(secureStorage);
  final dioClient = DioClient(Dio(), storageClient);
  final remoteDataSource = AuthRemoteDataSource(dioClient);
  final authRepository = AuthRepositoryImpl(remoteDataSource, storageClient);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository)..add(AuthCheckRequested()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Feeder UNY',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}

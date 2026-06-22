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
import 'features/mahasiswa/data/datasources/mahasiswa_remote_data_source.dart';
import 'features/mahasiswa/data/repositories/mahasiswa_repository_impl.dart';
import 'features/mahasiswa/presentation/bloc/mahasiswa_bloc.dart';
import 'features/mahasiswa/presentation/bloc/ticket_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependensi
  const secureStorage = FlutterSecureStorage();
  final storageClient = SecureStorageClient(secureStorage);
  final dioClient = DioClient(Dio(), storageClient);
  final remoteDataSource = AuthRemoteDataSource(dioClient);
  final authRepository = AuthRepositoryImpl(remoteDataSource, storageClient);
  
  final mahasiswaRemoteDataSource = MahasiswaRemoteDataSource(dioClient);
  final mahasiswaRepository = MahasiswaRepositoryImpl(mahasiswaRemoteDataSource);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),
        RepositoryProvider<MahasiswaRepositoryImpl>.value(value: mahasiswaRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository)..add(AuthCheckRequested()),
          ),
          BlocProvider<MahasiswaBloc>(
            create: (context) => MahasiswaBloc(mahasiswaRepository),
          ),
          BlocProvider<TicketBloc>(
            create: (context) => TicketBloc(mahasiswaRepository),
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

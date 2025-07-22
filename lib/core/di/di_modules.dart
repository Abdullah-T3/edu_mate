import 'package:edu_mate/core/network/dio_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  DioClient dioClient() =>
      DioClient(baseUrl: 'https://687f8002efe65e520089f9b5.mockapi.io/api/');

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}

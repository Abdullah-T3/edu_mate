import 'package:dio/dio.dart';
import 'package:edu_mate/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class CoursesRemoteDatasource {
  final DioClient _dioClient;
  CoursesRemoteDatasource(this._dioClient);

  Future<Response> fetchCourses() async {
    return await _dioClient.get('courses');
  }

  Future<Response> fetchEntolledCourses() async {
    return await _dioClient.get('enrolledCourses');
  }
}

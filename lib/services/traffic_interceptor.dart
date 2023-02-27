import 'package:dio/dio.dart';

class TrafficInterceptor extends Interceptor {
  final access_token =
      'pk.eyJ1IjoibHVjYXNydXNtYW4iLCJhIjoiY2xlNDdsOHVjMDBhdjNxbXA1YXYyem1hNiJ9.bV6xbT4aWXMERe3mQO_njQ';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': access_token
    });
    super.onRequest(options, handler);
  }
}

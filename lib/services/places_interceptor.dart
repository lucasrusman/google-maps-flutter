import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final access_token =
      'pk.eyJ1IjoibHVjYXNydXNtYW4iLCJhIjoiY2xlNDdsOHVjMDBhdjNxbXA1YXYyem1hNiJ9.bV6xbT4aWXMERe3mQO_njQ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final locationBloc = BlocProvider.of<LocationBloc>(context);
    options.queryParameters
        .addAll({'language': 'es', 'access_token': access_token});
    super.onRequest(options, handler);
  }
}

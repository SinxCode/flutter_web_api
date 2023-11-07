import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';

//Modularizando o serviço de comunicação com o servidor
class WebClient {
  static const String url = 'http://192.168.40.234:3000/';

  //Criando um cliente HTTP para utilizar os interceptadores.
  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
    requestTimeout: Duration(seconds: 5),
  );
}

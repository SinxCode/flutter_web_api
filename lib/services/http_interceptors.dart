import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

//Os interceptadores irão interceptar as requisções e nos trazer informações de requisições e respostas
class LoggingInterceptor implements InterceptorContract {
  
  //O Logger cria uma forma mais visual de enxergar o que como estão funcionando as nossas resquisições e respostas
  //Ele nos mostras os status de cada método indo para API.
  Logger logger = Logger();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    logger.v("Resposta de ${data.baseUrl}\nCabeçalhos: ${data.headers}\nCorpo: ${data.body}");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    //Verificando se o código de retorno é um erro.
    //o ~/100 significa que independente do número que receber ele irá divir por 100
    if(data.statusCode ~/100 ==2 ){
      logger.i("Requisição para ${data.url}\nStatus: ${data.statusCode}\nCabeçalhos: ${data.headers}\nCorpo: ${data.body}");
     
    }else{
      logger.e("Requisição para ${data.url}\nStatus: ${data.statusCode}\nCabeçalhos: ${data.headers}\nCorpo: ${data.body}");
    }

      return data;
  }

}
import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class JournalService {
  //Se conectando na API
  static const String url = 'http://192.168.40.234:3000/';
  static const String resource = 'journals/';

  //Criando um cliente HTTP para utilizar os interceptadores.
  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getUrl() {
    return '$url$resource';
  }

  //Criando um controller de registro (POST)
  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );
    if (response.statusCode != 201) {
      if (json.decode(response.body)  == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  //Criando Controller de edição (PUT)
  Future<bool> edit(String id, Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );

     if (response.statusCode != 201) {
      if (json.decode(response.body)  == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  //Criando um controller de leitura (GET)
  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/journals"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode != 200) {
      if (json.decode(response.body)  == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    
    List<Journal> list = [];

    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }
    //print(list.length);
    return list;
  }

  //Criando um controller de Deletar (DELETE)
  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(Uri.parse("${getUrl()}$id"),
        headers: {"Authorization": "Bearer $token"});
     if (response.statusCode != 201) {
      if (json.decode(response.body)  == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }
    return true;
 }
}

class TokenNotValidException implements Exception{

}

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/login_Screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen/home_screen.dart';

void main() async{
  //Assegurando para o flutter que a função main é assync
  WidgetsFlutterBinding.ensureInitialized();

  //Utilizando função se está logado na main
  bool isLogged = await verifyToken();
  //Passando a função como parametro no my app
  runApp( MyApp(isLogged: isLogged,));
}

//Função para verificar se o usuário está logado.
Future<bool> verifyToken() async{
  SharedPreferences  prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("accessToken");
  if (token != null) {
    return true;
  }
  return false;

}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({Key? key, required this.isLogged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      //Define como o tema da aplicação irá funcionar
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(color: Colors.white)
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: (isLogged)? "home": "login",
      routes: {
        "home": (context) =>  HomeScreen(),
        "login": (context) =>  LoginScreen(),
          
      },
      //chamando a tela de add-journal, isso identifica qual rota foi chamada e pega os argumentos que vieram com ela
      onGenerateRoute: (settings){
          if(settings.name == 'add-journal'){
            Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
            final Journal journal = map["journal"] as Journal; 
            final bool isEditing = map["is_editing"];
            return MaterialPageRoute(builder: (context) {
              return AddJournalScreen(journal: journal, isEditing: isEditing,);
            });
          }
          return null;
      },
    );
  }
}

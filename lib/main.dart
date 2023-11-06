import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/login_Screen/login_screen.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());

  JournalService service = JournalService();
  SharedPreferences.setMockInitialValues({});
  //service.register(Journal.empty());
  //service.getAll();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
      initialRoute: "login",
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

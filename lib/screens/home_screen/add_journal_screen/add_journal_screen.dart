import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/logout.dart';
import '../commom/exception_dialog.dart';

class AddJournalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEditing;
  AddJournalScreen({Key? key, required this.journal, required this.isEditing}) : super(key: key);
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${WeekDay(journal.createdAt.weekday).long.toLowerCase()}, ${journal.createdAt.day}  |   ${journal.createdAt.month}   ${journal.createdAt.year}"),
        actions: [
          IconButton(
              onPressed: () {
                registerJournal(context);
              },
              icon: const Icon(Icons.check)),
        ],
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 24),
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ),
    );
  }

  //Função que registra uma nova entrada no diário
  registerJournal(BuildContext context) async{
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString("accessToken");
      if (token !=null) {
          String content = _contentController.text;

    journal.content = content;

    JournalService service = JournalService();
    if(isEditing){
      service.register(journal, token).then((value){
        Navigator.pop(context, value);
      }).catchError(
                (error) {
                  logout(context);
                },
                test: (error) => error is TokenNotValidException,
              ).catchError(
                (error) {
                  showExceptionDialog(context, content: error.message);
                },
                test: (error) => error is HttpException,
              );

    }else{
        service.edit(journal.id, journal, token).then((value){
        Navigator.pop(context, value);
     
    }).catchError(
                (error) {
                  logout(context);
                },
                test: (error) => error is TokenNotValidException,
              ).catchError(
                (error) {
                  showExceptionDialog(context, content: error.message);
                },
                test: (error) => error is HttpException,
              );
    }
        
      }
    });
  
  }
}
  
 
  


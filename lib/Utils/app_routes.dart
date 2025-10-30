import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRoutes{

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static void popWithData(BuildContext context, data) {
    Navigator.pop(context, data);
  }

  static void dismissAlert(context) {
    Navigator.pop(context);
  }

  void nextScreen (context, page){
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void nextScreenCloseOthers (context, page){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
  }

  void nextScreenReplaceNamed (context, page){

    Navigator.pushReplacementNamed(context, page);
  }

  void nextScreenReplace (context, page){

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  void nextAndRemoveUntil (context, page){

    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => page), (route) => false);
  }

  void nextScreenCallback (context, page, Function(String result) handler) async {

    final result =  await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute( builder: (context) => page,));
    handler(result);
  }
}
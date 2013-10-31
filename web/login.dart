library training.web.login;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('login-control')
class LoginControl extends PolymerElement 
{
  @observable String username;
  @observable String password;
  
  @observable String error;
  
  AppModel app;
  
  bool get applyAuthorStyles => true;
  
  LoginControl.created() : super.created() 
  {
    app = appModel;
  }
  
  void login(Event e, var target, var node)
  {
    var users = app.users.where((u) => u.username == username && u.password == password);

    if (users.length == 0)
    {
      error = "invalid username or password";
    }
    else
    {
      appModel.currentUser = users.first;
    }
  }
}
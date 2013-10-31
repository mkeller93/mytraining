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
    bool logged_in = app.login(username, password);

    if (logged_in == false)
    {
      error = "invalid username or password";
    }
  }
}
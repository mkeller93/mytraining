library training.web.login;

import 'dart:html';
import "dart:async";
import 'package:polymer/polymer.dart';
import '../model.dart';

@CustomTag('login-control')
class LoginControl extends PolymerElement
{
  @observable String username = "";
  @observable String password = "";

  @observable String error;

  AppModel app;

  bool get applyAuthorStyles => true;

  static const EventStreamProvider<CustomEvent> _FINISH_EVENT = const EventStreamProvider("finish");
  Stream<CustomEvent> get onFinish => _FINISH_EVENT.forTarget(this);

  static void _dispatchFinishEvent(Element element, bool canceled)
  {
    element.dispatchEvent(new CustomEvent("finish", detail: canceled));
  }

  LoginControl.created() : super.created()
  {
    app = appModel;
  }

  void keyPressed(Event e, var target, var node)
  {
    if (e.keyCode == KeyCode.ENTER)
    {
      login(null, null, null);
    }
  }

  void login(Event e, var target, var node)
  {
    if (username == "" || password == "")
    {
      error = "Please enter username and password!";
      return;
    }

    bool logged_in = app.login(username, password);

    if (logged_in == false)
    {
      error = "Invalid username or password";
    }
    else
    {
      _dispatchFinishEvent(this, false);
    }
  }
}

library training.web.add_user;

import 'dart:html';
import "dart:async";
import 'package:polymer/polymer.dart';
import 'model.dart';
import 'objects.dart';

@CustomTag('add-user-control')
class AddUserControl extends PolymerElement
{
  @observable AppModel app;

  @observable ObservableList<String> errors;
  @observable String success;

  @published User user;
  User originalUser;

  static const EventStreamProvider<CustomEvent> _FINISH_EVENT = const EventStreamProvider("finish");
  Stream<CustomEvent> get onFinish => _FINISH_EVENT.forTarget(this);

  static void _dispatchFinishEvent(Element element, bool canceled)
  {
    element.dispatchEvent(new CustomEvent("finish", detail: canceled));
  }

  bool get applyAuthorStyles => true;

  AddUserControl.created() : super.created()
  {
    app = appModel;
    errors = new ObservableList<String>();
    success = "";

    originalUser = user;
  }

  void cancel(Event e)
  {
    e.preventDefault();

    if(user != null && originalUser != null)
    {
      user.username = originalUser.username;
      user.password = originalUser.password;
      user.role = originalUser.role;
    }

    _dispatchFinishEvent(this, true);
  }

  void save(Event e)
  {
    e.preventDefault();

    if (validateValues() == true)
    {
      _dispatchFinishEvent(this, false);
    }
  }

  bool validateValues()
  {
    errors.clear();
    if (user.username == "" || user.username == null)
    {
      errors.add("username");
    }
    if (user.password == "" || user.password == null)
    {
      errors.add("password");
    }
    if (user.role== "" || user.role == null)
    {
      errors.add("role");
    }
    return (errors.length == 0);
  }
}

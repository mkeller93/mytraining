library training.web.add_user;

import 'dart:html';
import "dart:async";
import 'package:polymer/polymer.dart';
import 'model.dart';
import 'objects.dart';

@CustomTag('change-password-control')
class ChangePasswordControl extends PolymerElement
{
  @observable AppModel app;

  @observable ObservableList<String> errors;

  @observable String password;
  @observable String passwordCurrent;
  @observable String passwordRepeated;

  bool get applyAuthorStyles => true;

  static const EventStreamProvider<CustomEvent> _FINISH_EVENT = const EventStreamProvider("finish");
  Stream<CustomEvent> get onFinish => _FINISH_EVENT.forTarget(this);

  static void _dispatchFinishEvent(Element element, bool canceled)
  {
    element.dispatchEvent(new CustomEvent("finish", detail: canceled));
  }

  ChangePasswordControl.created() : super.created()
  {
    app = appModel;
    errors = new ObservableList<String>();
  }

  void cancel(Event e)
  {
    e.preventDefault();

    _dispatchFinishEvent(this, true);
  }

  void save(Event e)
  {
    e.preventDefault();

    if (validateValues() == true)
    {
      app.data.user.password = password;
      _dispatchFinishEvent(this, false);
    }
  }

  bool validateValues()
  {
    errors.clear();
    if (passwordCurrent != app.data.user.password)
    {
      errors.add("valid current password");
    }
    if (password == "")
    {
      errors.add("password");
    }
    else if (password != passwordRepeated)
    {
      errors.add("same password twice");
    }

    return (errors.length == 0);
  }
}

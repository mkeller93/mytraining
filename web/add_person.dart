library training.web.add_person;

import 'dart:html';
import "dart:async";
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('add-person-control')
class AddPersonControl extends PolymerElement
{
  @observable AppModel app;

  @observable ObservableList<String> errors;
  @observable String success;

  @published Person person;
  Person originalPerson;

  static const EventStreamProvider<CustomEvent> _FINISH_EVENT = const EventStreamProvider("finish");
  Stream<CustomEvent> get onFinish => _FINISH_EVENT.forTarget(this);

  static void _dispatchFinishEvent(Element element, bool canceled)
  {
    element.dispatchEvent(new CustomEvent("finish", detail: canceled));
  }

  bool get applyAuthorStyles => true;

  AddPersonControl.created() : super.created()
  {
    app = appModel;
    errors = new ObservableList<String>();
    success = "";

    originalPerson = person;
  }

  void cancel(Event e)
  {
    e.preventDefault();

    if(person != null && originalPerson != null)
    {
      person.firstname = originalPerson.firstname;
      person.name = originalPerson.name;
      person.birthday = originalPerson.birthday;
      person.phoneNumber = originalPerson.phoneNumber;
      person.email = originalPerson.email;
      person.isTrainer = originalPerson.isTrainer;
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
    if (person.firstname == "" || person.firstname == null)
    {
      errors.add("firstname");
    }
    if (person.name == "" || person.name == null)
    {
      errors.add("name");
    }
    if (person.birthday == "" || person.birthday == null)
    {
      errors.add("birthday");
    }
    if (person.phoneNumber == "" || person.phoneNumber == null)
    {
      errors.add("Phone Number");
    }
    if (person.email == "" || person.email == null)
    {
      errors.add("email");
    }

    return (errors.length == 0);
  }
}

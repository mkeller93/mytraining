library training.web.add_person;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('add-person-control')
class AddPersonControl extends PolymerElement 
{
  @observable AppModel app;
  
  @observable String firstname;
  @observable String name;
  @observable String birthday;
  @observable String phoneNumber;
  @observable String email;
  @observable bool isTrainer;
  
  @observable ObservableList<String> errors;
  @observable String success;
  
  AddPersonControl.created() : super.created() 
  {
    app = appModel;
    errors = new ObservableList<String>();
    success = "";
  }
  
  void submit(Event e)
  {
    e.preventDefault();
    
    if (validateValues() == true)
    {
      var p = new Person();
      p.firstname = firstname;
      p.name = name;
      p.birthday = birthday;
      p.phoneNumber = phoneNumber;
      p.email = email;
      p.isTrainer = isTrainer;
      
      app.persons.add(p);
      
      clearValues();
      success = "Successfully added the Person";
    }
  }
  
  bool validateValues()
  {
    errors.clear();
    if (firstname == "" || firstname == null)
    {
      errors.add("firstname");
    }
    if (name == "" || name == null)
    {
      errors.add("name");
    }
    if (birthday == "" || birthday == null)
    {
      errors.add("birthday");
    }
    if (phoneNumber == "" || phoneNumber == null)
    {
      errors.add("Phone Number");
    }
    if (email == "" || email == null)
    {
      errors.add("email");
    }    
    
    return (errors.length == 0);
  }
  
  void clearValues()
  {
    firstname = "";
    name = "";
    birthday = "";
    phoneNumber = "";
    email = "";
    isTrainer = false;
  }
}

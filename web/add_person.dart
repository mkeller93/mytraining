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
  @observable bool trainer = false;
  
  @observable ObservableList<String> errors;
  @observable String success;
  
  @published Person person;
  
  bool get applyAuthorStyles => true;
  
  AddPersonControl.created() : super.created() 
  {
    app = appModel;
    errors = new ObservableList<String>();
    success = "";
  }
  
  void cancel(Event e)
  {
    e.preventDefault();
  }
  
  void save(Event e)
  {
    e.preventDefault();
    
    if (validateValues() == true)
    {
      if (person == null)
      {
        app.addPerson(name, firstname, birthday, phoneNumber, email, trainer);
      
        success = "Successfully added " + firstname + " " + name;
      }
      else
      {
        person.name = name;
        person.firstname = firstname;
        person.birthday = birthday;
        person.phoneNumber = phoneNumber;
        person.email = email;
        person.isTrainer = trainer;
        
        success = "Successfully edited " + firstname + " " + name;
      }
      
      clearValues();      
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
    trainer = false;
  }
}

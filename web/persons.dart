library training.web.persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('person-view')
class PersonView extends PolymerElement 
{
  @observable AppModel app;
  
  @observable String firstname;
  @observable String name;
  @observable String date;
  @observable String mobileNumber;
  @observable bool isTrainer;
  
  @observable ObservableList<String> errors;
  
  PersonView.created() : super.created() 
  {
    app = appModel;
    errors = new ObservableList<String>();
  }
  
  void newPersonSubmit(Event e)
  {
    e.preventDefault();
    
    if (validateValues() == true)
    {
      var p = new Person();
      p.firstname = firstname;
      p.name = name;
      p.date = date;
      p.mobileNumber = mobileNumber;
      p.isTrainer = isTrainer;
      
      app.persons.add(p);
      
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
    
    return (errors.length == 0);
  }
  
  void clearValues()
  {
    firstname = "";
  }
}

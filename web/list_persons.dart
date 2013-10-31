library training.web.list_persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('list-persons-control')
class ListPersonsControl extends PolymerElement 
{
  @observable AppModel app;
  @observable Person deletedPerson;
  
  @published ObservableList<Person> persons;
  
  bool get applyAuthorStyles => true;
  
  ListPersonsControl.created() : super.created() 
  {
    app = appModel;
  }
  
  void deletePerson(Event event, var detail, var target)
  {
    var id = int.parse(target.attributes["person-id"]);
    //var person = app.persons.where((p) => p.id == id).first;
    var person = persons.where((p) => p.id == id).first;
    
    //app.persons.remove(person);
    persons.remove(person);
    
    deletedPerson = person;
  }
  
  void undoDelete(Event event, var detail, var target)
  {
    persons.add(deletedPerson);
    deletedPerson = null;
  }
}

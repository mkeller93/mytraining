library training.web.list_persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('list-persons-control')
class ListPersonsControl extends PolymerElement 
{
  @observable AppModel app;
  @observable Person deletedPerson;
  
  
  ListPersonsControl.created() : super.created() 
  {
    app = appModel;
  }
  
  void deletePerson(Event event, var detail, var target)
  {
    var id = int.parse(target.attributes["person-id"]);
    var person = app.persons.where((p) => p.id == id).first;
    app.persons.remove(person);
    deletedPerson = person;
  }
  
  void undoDelete(Event event, var detail, var target)
  {
    app.persons.add(deletedPerson);
    deletedPerson = null;
  }
}

library training.web.list_persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('list-persons-control')
class ListPersonsControl extends PolymerElement 
{
  @observable AppModel app;
  @observable Person personToDelete;
  @observable String action = "list";
  
  @published ObservableList<Person> persons;
  @published bool edit = false;
  @published bool delete = false;
  
  bool get applyAuthorStyles => true;
  
  ListPersonsControl.created() : super.created() 
  {
    app = appModel;
  }
  
  void showDeletePerson(Event event, var detail, var target)
  {
    var id = int.parse(target.attributes["person-id"]);
    //var person = app.persons.where((p) => p.id == id).first;
    var person = persons.where((p) => p.id == id).first;
    
    personToDelete = person; 
  }
  
  void deletePerson(Event e)
  {
    persons.remove(personToDelete);
    action = "list";
  }
  
  void cancelDelete(Event e)
  {
    action = "list";
  }
}

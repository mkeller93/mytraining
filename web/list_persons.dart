library training.web.list_persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('list-persons-control')
class ListPersonsControl extends PolymerElement 
{
  @observable AppModel app;
  @observable Person selectedPerson;
  @observable String action = "list";
  
  @published ObservableList<Person> persons;
  @published bool edit = false;
  @published bool delete = false;
  
  bool get applyAuthorStyles => true;
  
  ListPersonsControl.created() : super.created() 
  {
    app = appModel;
  }
  
  void editPerson(Event event, var detail, var target)
  {
    var id = int.parse(target.attributes["person-id"]);
    selectPerson(id);
    action = "edit";
  }
  
  void showDeletePerson(Event event, var detail, var target)
  {
    print("id " + target.attributes["person-id"]);
    var id = int.parse(target.attributes["person-id"]);
    selectPerson(id);
    action = "delete";
  }
  
  void selectPerson(int id)
  {
    var person = persons.where((p) => p.id == id).first;
    
    selectedPerson = person;
  }
  
  void deletePerson(Event e)
  {
    persons.remove(selectedPerson);
    action = "list";
  }
  
  void cancelDelete(Event e)
  {
    action = "list";
  }
}

library training.web.list_persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../model.dart';
import '../objects.dart';

@CustomTag('list-persons-control')
class ListPersonsControl extends PolymerElement
{
  @observable AppModel app;
  @observable Person selectedPerson;
  @observable String action = "list";

  @observable String error = "";
  @observable String success = "";

  @published ObservableList<Person> persons;
  @published bool editable = false;

  bool get applyAuthorStyles => true;

  bool wasTrainer;

  ListPersonsControl.created() : super.created()
  {
    app = appModel;
  }

  void editPerson(Event event, var detail, var target)
  {
    var id = target.attributes["person-id"];
    selectPerson(id);
    action = "edit";
  }

  void showDeletePerson(Event event, var detail, var target)
  {
    var id = target.attributes["person-id"];
    selectPerson(id);
    action = "delete";
  }

  void selectPerson(String id)
  {
    var person = persons.where((p) => p.id == id).first;
    selectedPerson = person;
    wasTrainer = selectedPerson.isTrainer;
  }

  void deletePerson(Event e)
  {
    if (app.data.deletePerson(selectedPerson))
    {
      error = "";
      success = "Successfully deleted person!";
    }
    else
    {
      success = "";
      error = "Failed to delete person!";
    }

    action = "list";
  }

  void cancelDelete(Event e)
  {
    action = "list";
  }

  void editFinished(CustomEvent event, bool canceled)
  {
    if (canceled == false)
    {
      if (app.data.updatePerson(selectedPerson) == true)
      {
        error = "";
        success = "Successfully updated person!";
      }
      else
      {
        success = "";
        error = "Failed to update person!";
      }
    }

    action = "list";
  }
}


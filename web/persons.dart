library training.web.persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';
import 'data_context.dart';

@CustomTag('persons-view')
class PersonsView extends PolymerElement
{
  @observable AppModel app;
  @observable String action;
  @observable Person newPerson;

  @observable String success;
  @observable String error;

  bool get applyAuthorStyles => true;

  @observable ObservableList<NavigationItem> menuItems;

  PersonsView.created() : super.created()
  {
    app = appModel;
    action = "list";
    menuItems = new ObservableList<NavigationItem>();
    menuItems = app.getNavigation("persons");
  }

  void updateView(Event event, var detail, var target)
  {
    action = target.attributes["view"];

    if (action == "add")
    {
      newPerson = new Person();
    }
  }

  void addFinish(CustomEvent event, bool canceled)
  {
    if(canceled == false)
    {
      
      if (app.data.addPerson(newPerson) == true)
      {
        success = "Successfully added $newPerson";  
      }
      else
      {
        error = "Failed to add person!";
      }            
    }

    action = "list";
    newPerson = null;
  }
}

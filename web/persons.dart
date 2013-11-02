library training.web.persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('persons-view')
class PersonsView extends PolymerElement 
{
  @observable AppModel app;  
  @observable String action;
  
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
  }
}

library training.web.persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('person-view')
class PersonView extends PolymerElement 
{
  @observable AppModel app;  
  @observable String action;
  
  PersonView.created() : super.created() 
  {
    app = appModel;
    action = "list";
  }
  
  void updateView(Event event, var detail, var target)
  {
    action = target.attributes["view"]; 
  }
}

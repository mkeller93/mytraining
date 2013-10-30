library training.web.persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('person-view')
class PersonView extends PolymerElement 
{
  @observable AppModel app;
  
  PersonView.created() : super.created() 
  {
    app = appModel;
  }
}

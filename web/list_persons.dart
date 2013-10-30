library training.web.list_persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('list-persons-control')
class ListPersonsControl extends PolymerElement 
{
  @observable AppModel app;
  
  ListPersonsControl.created() : super.created() 
  {
    app = appModel;
  }
}

library training.web.main;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('main-view')
class MainView extends PolymerElement 
{
  @observable AppModel app;

  bool get applyAuthorStyles => true;
  
  MainView.created() : super.created() 
  {
    app = appModel;
  }
}

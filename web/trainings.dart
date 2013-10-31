library training.web.main;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('trainings-view')
class TrainingsView extends PolymerElement 
{
  @observable AppModel app;

  bool get applyAuthorStyles => true;
  
  TrainingsView.created() : super.created() 
  {
    app = appModel;
  }
}

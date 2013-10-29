library training.web.app;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('training-app')
class TrainingApp extends PolymerElement 
{
  @observable AppModel app;
  
  DivElement mainView;

  TrainingApp.created() : super.created() 
  {
    app = appModel;
    windowLocation.changes.listen(_location_changed);
    mainView = querySelector("main-content");
  }
  
  _location_changed(_)
  {
    String hash = window.location.hash;
    if (hash.startsWith("#") == true)
    {
      app.content = hash.substring(1, hash.length);
    }
  }
}
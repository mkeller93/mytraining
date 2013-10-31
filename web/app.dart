library training.web.app;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('training-app')
class TrainingApp extends PolymerElement 
{
  @observable AppModel app;
  
  bool get applyAuthorStyles => true;
  
  TrainingApp.created() : super.created() 
  {
    app = appModel;
    windowLocation.changes.listen(_location_changed);
  }
  
  void logout(Event e, var detail, var target)
  {
    app.logout();
  }
  
  _location_changed(_)
  {
    if (window.location.hash != "")
    {
      String hash = window.location.hash;
      if (hash.startsWith("#") == true)
      {
        app.content = hash.substring(1, hash.length);
      }
    }
  }
}
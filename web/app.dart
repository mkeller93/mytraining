library training.web.app;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('training-app')
class TrainingApp extends PolymerElement
{
  @observable AppModel app;

  bool get applyAuthorStyles => true;

  bool overNavigation = false;
  
  TrainingApp.created() : super.created()
  {
    app = appModel;
    windowLocation.changes.listen(_location_changed);
    _location_changed(null);
  }

  void logout(Event e, var detail, var target)
  {
    window.location.hash = "";
    app.logout();
  }

  void loggedIn(CustomEvent event, bool canceled)
  {
    window.location.hash = "";
  }
  
  void showItem(Event e, var detail, var target)
  {
    overNavigation = true;
    String item = target.attributes['target-name'];
    window.location.hash = item;
  }

  void changeLanguage(Event e, var detail, var target)
  {
    String language = target.attributes['language'];
  }

  _location_changed(_)
  {
    if (window.location.hash != "" && overNavigation == true)
    {
      overNavigation = false;
      String hash = window.location.hash;
      if (hash.startsWith("#") == true)
      {
        app.content = hash.substring(1, hash.length);
      }
    }
    else
    {
      app.content = "home";
    }
  }
}
library training.web.users;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('settings-view')
class SettingsView extends PolymerElement
{
  @observable AppModel app;
  @observable String action;

  @observable String success;
  @observable String error;

  bool get applyAuthorStyles => true;

  @observable ObservableList<NavigationItem> menuItems;

  SettingsView.created() : super.created()
  {
    app = appModel;
    action = "home";
    menuItems = new ObservableList<NavigationItem>();
    menuItems = app.getNavigation("settings");
  }

  void updateView(Event event, var detail, var target)
  {
    action = target.attributes["view"];
  }

  void changeFinish(CustomEvent event, bool canceled)
  {
    if (canceled == false)
    {
      if (app.data.updateUser(app.data.user))
      {
        error = "";
        success = "Successfully changed password!";
      }
      else
      {
        success = "";
        error = "Changing password failed!";
      }
    }

    action = "home";
  }
}

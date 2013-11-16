library training.web.users;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';
import 'objects.dart';

@CustomTag('users-view')
class UsersView extends PolymerElement
{
  @observable AppModel app;
  @observable String action;
  @observable User newUser;

  @observable String success;
  @observable String error;

  bool get applyAuthorStyles => true;

  @observable ObservableList<NavigationItem> menuItems;

  UsersView.created() : super.created()
  {
    app = appModel;
    action = "list";
    menuItems = new ObservableList<NavigationItem>();
    menuItems = app.getNavigation("users");
  }

  void updateView(Event event, var detail, var target)
  {
    action = target.attributes["view"];

    if (action == "add")
    {
      newUser = new User();
    }
  }

  void addFinish(CustomEvent event, bool canceled)
  {
    if(canceled == false)
    {

      if (app.data.addUser(newUser) == true)
      {
        success = "Successfully added $newUser";
      }
      else
      {
        error = "Failed to add user!";
      }
    }

    action = "list";
    newUser = null;
  }
}

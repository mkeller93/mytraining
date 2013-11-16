library training.web.list_users;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';
import "data_context.dart";
import 'objects.dart';

@CustomTag('list-users-control')
class ListUsersControl extends PolymerElement
{
  @observable AppModel app;
  @observable User selectedUser;
  @observable String action = "list";

  @observable String error = "";
  @observable String success = "";

  @published bool editable = false;

  bool get applyAuthorStyles => true;

  ListUsersControl.created() : super.created()
  {
    app = appModel;
  }

  void editUser(Event event, var detail, var target)
  {
    var id = target.attributes["user-id"];
    selectUser(id);
    action = "edit";
  }

  void showDeleteUser(Event event, var detail, var target)
  {
    var id = target.attributes["user-id"];
    selectUser(id);
    action = "delete";
  }

  void selectUser(String id)
  {
    var user = app.data.users.where((u) => u.id == id).first;
    selectedUser = user;
  }

  void deleteUser(Event e)
  {
    if (app.data.deleteUser(selectedUser))
    {
      error = "";
      success = "Successfully deleted user!";
    }
    else
    {
      success = "";
      error = "Failed to delete use!";
    }

    action = "list";
  }

  void cancelDelete(Event e)
  {
    action = "list";
  }

  void editFinished(CustomEvent event, bool canceled)
  {
    if (canceled == false)
    {
      if (app.data.updateUser(selectedUser) == true)
      {
        error = "";
        success = "Successfully updated user!";
      }
      else
      {
        success = "";
        error = "Failed to update user!";
      }
    }

    action = "list";
  }
}


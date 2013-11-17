library training.web.trainings;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../model.dart';
import '../objects.dart';

@CustomTag('trainings-view')
class TrainingsView extends PolymerElement
{
  @observable AppModel app;
  @observable String action;

  @observable String success;
  @observable String error;

  @observable Training newTraining;

  bool get applyAuthorStyles => true;

  @observable ObservableList<NavigationItem> menuItems;

  TrainingsView.created() : super.created()
  {
    app = appModel;
    action = "list";
    menuItems = new ObservableList<NavigationItem>();
    menuItems = app.getNavigation("trainings");
  }

  void updateView(Event event, var detail, var target)
  {
    action = target.attributes["view"];

    if (action == "add")
    {
      newTraining = new Training();
    }
  }

  void addFinish(CustomEvent event, bool canceled)
  {
    if(canceled == false)
    {
      if (app.data.addTraining(newTraining) == true)
      {
        success = "Successfully added $newTraining";
      }
      else
      {
        error = "Failed to add training!";
      }
    }

    action = "list";
    newTraining = null;
  }
}

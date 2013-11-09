library training.web.list_persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';
import "data_context.dart";
import 'objects.dart';

@CustomTag('list-trainings-control')
class ListTrainingsControl extends PolymerElement
{
  @observable AppModel app;
  @observable Training selectedTraining;
  @observable String action = "list";

  @observable String error = "";
  @observable String success = "";

  @published ObservableList<Training> trainings;
  @published bool editable = false;

  bool get applyAuthorStyles => true;

  ListTrainingsControl.created() : super.created()
  {
    app = appModel;
  }

  void editTraining(Event event, var detail, var target)
  {
    String id = target.attributes["training-id"];
    selectTraining(id);
    action = "edit";
  }

  void showDeleteTraining(Event event, var detail, var target)
  {
    String id = target.attributes["training-id"];
    selectTraining(id);
    action = "delete";
  }

  void selectTraining(String id)
  {
    var training = trainings.where((t) => t.id == id).first;
    selectedTraining = training;
  }

  void deleteTraining(Event e)
  {
    if (app.data.deleteTraining(selectedTraining))
    {
      success = "Successfully deleted training from " + selectedTraining.date.toString();
    }
    else
    {
      error = "Failed to delete training from " + selectedTraining.date.toString();
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
      if (app.data.updateTraining(selectedTraining) == true)
      {
        success = "Successfully updated training!";
      }
      else
      {
        error = "Failed to update training!";
      }
    }

    action = "list";
  }
}


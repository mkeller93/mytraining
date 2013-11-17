library training.web.list_persons;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../model.dart';
import '../objects.dart';

@CustomTag('list-trainings-control')
class ListTrainingsControl extends PolymerElement
{
  @observable AppModel app;
  @observable Training selectedTraining;
  @observable String action = "list";

  @observable String minDate = "";
  @observable String maxDate = "";

  @observable String error = "";
  @observable String success = "";

  @observable ObservableList<Training> trainings;

  @published bool editable = false;

  bool get applyAuthorStyles => true;

  @observable Map totalTrainings = new Map();

  ListTrainingsControl.created() : super.created()
  {
    app = appModel;
    trainings = app.data.trainings;
    updateTotalTrainings();
  }

  void updateTotalTrainings()
  {
    if (app.data.trainings != null)
    {
      totalTrainings = new Map();
      for (Person p in app.data.trainers)
      {
        int cnt = 0;
        for (Training training in trainings)
        {
          if (training.trainers.contains(p) == true)
          {
            cnt++;
          }
        }

        totalTrainings[p.id] = cnt.toString();
      }
    }
  }

  void reset(Event event, var detail, var target)
  {
    minDate = "";
    maxDate = "";

    error = "";
    success = "";

    trainings = app.data.trainings;
    updateTotalTrainings();
  }

  void search(Event event, var detail, var target)
  {
    try
    {
      DateTime min = DateConverter.getIsoDate(minDate);

      // we allow only to add one date
      if (maxDate == "")
      {
        trainings = toObservable(app.data.trainings.where((t) => t.realDate.isAtSameMomentAs(min)));
        updateTotalTrainings();
        return;
      }

      min = min.add(new Duration(days: -1));
      DateTime max = DateConverter.getIsoDate(maxDate).add(new Duration(days: 1));

      if (min.isAfter(max) == true)
      {
        success = "";
        error = "Min cannot be a date after max!";
        return;
      }

      trainings = toObservable(app.data.trainings.where((t) => t.realDate.isAfter(min) && t.realDate.isBefore(max)));
      updateTotalTrainings();

      error = "";
      success = "";
    }
    on ArgumentError
    {
      success = "";
      error = "Please provide dates in format dd.mm.yyyy";
    }
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
      error = "";
      success = "Successfully deleted training from " + selectedTraining.date.toString();
    }
    else
    {
      success = "";
      error = "Failed to delete training from " + selectedTraining.date;
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
        error = "";
        success = "Successfully updated training!";
      }
      else
      {
        success = "";
        error = "Failed to update training!";
      }
    }

    action = "list";
  }
}


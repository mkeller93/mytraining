library training.web.add_training;

import 'dart:html';
import "dart:async";
import 'package:polymer/polymer.dart';
import '../model.dart';
import '../objects.dart';

@CustomTag('add-training-control')
class AddTrainingControl extends PolymerElement
{
  @observable AppModel app;

  @observable ObservableList<String> errors;
  @observable String success;

  @published Training training;
  Training originalTraining;

  static const EventStreamProvider<CustomEvent> _FINISH_EVENT = const EventStreamProvider("finish");
  Stream<CustomEvent> get onFinish => _FINISH_EVENT.forTarget(this);

  static void _dispatchFinishEvent(Element element, bool canceled)
  {
    element.dispatchEvent(new CustomEvent("finish", detail: canceled));
  }

  bool get applyAuthorStyles => true;

  AddTrainingControl.created() : super.created()
  {
    app = appModel;
    errors = new ObservableList<String>();
    success = "";

    originalTraining = training;
  }

  bool isTrainerSelected(Person p)
  {
    if (app.data.trainers == null)
    {
      return false;
    }

    if (training != null && training.trainers.contains(p) == true)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

  bool isChildSelected(Person p)
  {
    if (app.data.children == null)
    {
      return false;
    }

    if (training != null && training.children.contains(p) == true)
    {
      return true;
    }
    else
    {
     return false;
    }
  }

  void childSelected(Event event, var detail, var target)
  {
    CheckboxInputElement chb = target;
    String id = chb.attributes['child-id'];

    Person c = app.data.children.where((p) => p.id == id).first;

    if (chb.checked == true)
    {
      if (training.children.contains(c) == false)
      {
        training.children.add(c);
      }
    }
    else
    {
      if (training.children.contains(c) == true)
      {
        training.children.remove(c);
      }
    }
  }

  void trainerSelected(Event event, var detail, var target)
  {
    CheckboxInputElement chb = target;
    String id = chb.attributes['trainer-id'];

    Person t = app.data.trainers.where((p) => p.id == id).first;

    if (chb.checked == true)
    {
      if (training.trainers.contains(t) == false)
      {
        training.trainers.add(t);
      }
    }
    else
    {
      if (training.trainers.contains(t) == true)
      {
        training.trainers.remove(t);
      }
    }
  }

  void cancel(Event e)
  {
    e.preventDefault();

    if(training != null && originalTraining != null)
    {
      training.date = originalTraining.date;
      training.notes = originalTraining.notes;
      training.children = originalTraining.children;
      training.trainers = originalTraining.trainers;
    }

    _dispatchFinishEvent(this, true);
  }

  void save(Event e)
  {
    e.preventDefault();

    if (validateValues() == true)
    {
      training.realDate = DateConverter.getIsoDate(training.date);
      _dispatchFinishEvent(this, false);
    }
  }

  bool validateValues()
  {
    errors.clear();

    if (training.date == "" || training.date == null)
    {
      errors.add("date");
    }
    else
    {
      try
      {
        DateConverter.getIsoDate(training.date);
      }
      on ArgumentError
      {
        errors.add("date with format dd.mm.yyyy");
      }
    }

    if (training.trainers.length == 0)
    {
      errors.add("at least one trainer");
    }
    if (training.children.length == 0)
    {
      errors.add("at least one child");
    }

    if (training.notes == null || training.notes == "")
    {
      errors.add("notes");
    }

    return (errors.length == 0);
  }
}
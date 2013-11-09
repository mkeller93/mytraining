library training.web.trainings;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

@CustomTag('trainings-view')
class TrainingsView extends PolymerElement
{
  @observable AppModel app;
  @observable String action;

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
  }
}

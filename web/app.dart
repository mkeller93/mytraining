import 'dart:html';
import 'package:polymer/polymer.dart';
import 'model.dart';

// page 0 = main
// page 1 = persons
// page 2 = add training

@CustomTag('training-app')
class TrainingApp extends PolymerElement 
{
  @observable AppModel app;
  @observable int showPage;  

  factory TrainingApp() => new Element.tag('training-app');

  TrainingApp.created() : super.created() 
  {
    app = appModel;
    windowLocation.changes.listen(_showView);
  }

  _showView(records)
  {
    var hash = window.location.hash;
    if (hash == "")
    {
      showPage = 0;
    }    
    else if (hash == "#/persons")
    {
      showPage = 1;
    }
  }
  
}

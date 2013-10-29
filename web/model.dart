import 'package:polymer/polymer.dart';

final appModel = new AppModel._();

@reflectable
class AppModel extends Observable 
{
  @observable List<Person> persons;

  AppModel._() 
  {
  }
}

class Person extends Observable 
{
  @observable String Name;
  @observable String Firstname;
  @observable String Date;
  @observable String MobileNumber;
  @observable bool isTrainer;

  Person(this.Name, this.Firstname, this.Date, this.MobileNumber);

  String toString() => "$Firstname $Name ${isTrainer ? ' (trainer)' : ''}";
}
library training.web.objects;

import 'package:polymer/polymer.dart';

class Role
{
  static const String adminString = "admin";
  static const String userString = "user";
  static const String viewerString = "viewer";

  static const Role ADMIN = const Role._(adminString);
  static const Role USER = const Role._(userString);
  static const Role VIEWER = const Role._(viewerString);

  @observable final String name;

  static List<Role> values = new List<Role>()..add(ADMIN)..add(USER)..add(VIEWER);

  const Role._(this.name);
}

class User extends Observable
{
  @observable String id = "";
  @observable String username = "";
  @observable String role = "";

  User(this.id, this.username, this.role);
}

class Person extends Observable
{
  @observable String id = "";
  @observable String name = "";
  @observable String firstname = "";
  @observable String birthday = "";
  @observable String phoneNumber = "";
  @observable String email = "";
  @observable bool isTrainer = false;

  Person()
  {;
  }

  String toString() => "$firstname $name";

  String toJson()
  {
    String trainer = isTrainer ? "true" : "false";

    String data = '{"name":"$name", "firstname":"$firstname", "email":"$email", "birthday":"$birthday", "phone":"$phoneNumber", "istrainer":$trainer}';
    return data;
  }
}

class DateConverter
{
  static DateTime getIsoDate(String date)
  {
    String year = date.substring(6, 10);
    String month = date.substring(3, 5);
    String day = date.substring(0, 2);

    return DateTime.parse("$year-$month-$day");
  }
}

class Training extends Observable
{
  @observable String date = "";
  @observable DateTime realDate;
  @observable String notes = "";
  @observable String id = "";

  @observable ObservableList<Person> trainers;
  @observable ObservableList<Person> children;

  Training()
  {
    trainers = new ObservableList<Person>();
    children = new ObservableList<Person>();
  }

  void setDate(DateTime date)
  {
    realDate = date;

    if (realDate != null)
    {
      String y = realDate.year.toString();
      String m = realDate.month.toString();
      String d = realDate.day.toString();

      if(realDate.month < 10)
        m = "0" + m;

      if(realDate.day < 10)
        d = "0" + d;

      this.date = "$d.$m.$y";
      return;
    }

    this.date = "";
  }

  String toJson()
  {
    // fix date
    String d = DateConverter.getIsoDate(date).toString();
    d = d.replaceAll(" ", "T");
    d += "Z";

    // fix notes
    String notesUpload = notes.replaceAll("\n", "\\n");

    String data = '{"notes":"$notesUpload", "date":{"__type":"Date", "iso":"$d"}}';

    return data;
  }

  String toString() => "Training from $date";
}



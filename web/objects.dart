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
  @observable String username;
  @observable String role;

  User(this.username, this.role);
}

class Person extends Observable
{
  @observable String id;
  @observable String name;
  @observable String firstname;
  @observable String birthday;
  @observable String phoneNumber;
  @observable String email;
  @observable bool isTrainer;

  Person()
  {
    isTrainer = false;
  }

  String toString() => "$firstname $name";

  String toJson()
  {
    String trainer = isTrainer ? "true" : "false";

    String data = '{"name":"$name", "firstname":"$name", "email":"$email", "birthday":"$birthday", "phone":"$phoneNumber", "istrainer":$trainer}';
    return data;
  }
}

class Training extends Observable
{
  @observable DateTime date;
  @observable String notes;
  @observable String id;

  @observable ObservableList<Person> trainers;
  @observable ObservableList<Person> children;

  Training()
  {
    trainers = new ObservableList<Person>();
    children = new ObservableList<Person>();
  }

  String getDate()
  {
    if (date != null)
    {
      String y = date.year.toString();
      String m = date.month.toString();
      String d = date.day.toString();

      return "$d.$m.$y";
    }

    return "NA";
  }

  String toJson()
  {
    String data = '{"notes":"$notes", "date":"$date"}';
    return data;
  }
}



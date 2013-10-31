// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library training.web.model;

import 'package:polymer/polymer.dart';

final appModel = new AppModel._();

@reflectable
class AppModel extends Observable 
{
  @observable String content = "";
    
  List<User> users = new List<User>();
  @observable User currentUser = null;
  @observable bool isAdmin = false;
  
  @observable ObservableList<Person> trainers = new ObservableList<Person>();
  @observable ObservableList<Person> children = new ObservableList<Person>();
  
  AppModel._() 
  {
    addPerson("Keller", "Marcel", "29.12.1993", "078 854 48 40", "marcel.keller1993@gmail.com", true);
    
    User admin = new User("admin", "admin", Role.ADMIN);
    User user = new User("user", "user", Role.USER);
    
    users.add(admin);
    users.add(user);
    
    login("admin", "admin");
  }
  
  bool login(String username, String password)
  {
    var all_users = users.where((u) => u.username == username && u.password == password);

    if (users.length == 0)
    {
      return false;
    }

    currentUser = all_users.first;
    isAdmin = (currentUser.role == Role.ADMIN);
  }
  
  void logout()
  {
    currentUser = null;
    isAdmin = false;
  }
  
  void addPerson(String name, String firstname, String birthday, String phoneNumber, String email, bool trainer)
  {
    var p = new Person();
    p.name = name;
    p.firstname = firstname;
    p.birthday = birthday;
    p.phoneNumber = phoneNumber;
    p.email = email;
    p.isTrainer = trainer;

    if (p.isTrainer)
    {
      trainers.add(p);
    }
    else
    {
      children.add(p);
    }
  }
}

class Role
{
  static const String adminString = "admin";
  static const String userString = "user";
  
  static const Role ADMIN = const Role._(adminString);
  static const Role USER = const Role._(userString);
  
  @observable final String name;
  
  const Role._(this.name);
}

class User extends Observable
{
  @observable String username;
  @observable String password;
  @observable Role role;
  
  User(this.username, this.password, this.role);
}

class Person extends Observable
{
  static int all_id = 0;
  
  @observable int id;
  @observable String name;
  @observable String firstname;
  @observable String birthday;
  @observable String phoneNumber;
  @observable String email;
  @observable bool isTrainer;
    
  Person()
  {
    id = Person.all_id++;
  }
  
  String toString() => "$firstname $name";
}
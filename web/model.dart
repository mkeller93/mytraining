// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library training.web.model;

import 'package:polymer/polymer.dart';

final appModel = new AppModel._();

@reflectable
class AppModel extends Observable 
{
  @observable ObservableList<Person> persons;
  @observable String content;
    
  AppModel._() 
  {
    persons = new ObservableList<Person>();
    addPerson("Keller", "Marcel", "29.12.1993", "078 854 48 40", "marcel.keller1993@gmail.com", true);
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

    persons.add(p);
  }
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
  
  String toString() => "$firstname $name ${isTrainer ? ' (trainer)' : ''}";
}
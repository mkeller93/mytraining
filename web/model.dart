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
    addPerson("Keller", "Marcel", "29.12.1993", "078 854 48 40", true);
  }
  
  void addPerson(String name, String firstname, String date, String number, bool trainer)
  {
    var p = new Person();
    p.name = name;
    p.firstname = firstname;
    p.date = date;
    p.mobileNumber = number;
    p.isTrainer = trainer;
        
    persons.add(p);
  }
}

class Person extends Observable
{
  @observable String name;
  @observable String firstname;
  @observable String date;
  @observable String mobileNumber;
  @observable bool isTrainer;
    
  Person();
  
  String toString() => "$firstname $name ${isTrainer ? ' (trainer)' : ''}";
}
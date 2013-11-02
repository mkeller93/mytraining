// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library training.web.model;

import 'package:polymer/polymer.dart';
import "training_config.dart";
import "ini_parser.dart";

final appModel = new AppModel._();

@reflectable
class AppModel extends Observable 
{  
  @observable String content = "";
    
  List<User> users = new List<User>();
  @observable User currentUser = null;
  
  @observable ObservableList<Person> trainers = new ObservableList<Person>();
  @observable ObservableList<Person> children = new ObservableList<Person>();
  
  ObservableList<Navigation> navigations = new ObservableList<Navigation>();
  @observable ObservableList<NavigationItem> navigation = new ObservableList<NavigationItem>();
  
  AppModel._() 
  {
    parseNavigation();
    
    addPerson("Keller", "Marcel", "29.12.1993", "078 854 48 40", "marcel.keller1993@gmail.com", true);
        
    User admin = new User("admin", "admin", Role.ADMIN);
    User user = new User("user", "user", Role.USER);
    User viewer = new User("viewer", "viewer", Role.VIEWER);
    
    users.add(admin);
    users.add(user);
    users.add(viewer);
    
    login("admin", "admin");
  }
  
  bool login(String username, String password)
  {
    var all_users = users.where((u) => u.username == username && u.password == password);
      
    if (all_users.length == 0)
    {
      print("login failed");
      return false;
    }

    currentUser = all_users.first;
    setNavigation();
    return true;
  }
  
  void logout()
  {
    currentUser = null;
    setNavigation();
  }
  
  void parseNavigation()
  {    
    IniParser config = new IniParser();
    config.parseString(TrainingConfig.config);
    
    navigations.clear();
    
    for (Section section in config.sections)
    {        
      for(Option option in section.options)
      {
        //print("--------");
        //print("Section " + section.name);
        Navigation n = new Navigation(section.name);

        String name = option.key;
        Role role = Role.values.where((r) => r.name == name).first;
        n.role = role;
        
        for (String item in option.value.split(";"))
        {
          if (item != "")
          {
            String item_name = item.split(":").first;
            String item_target = item.split(":").last;         
            
            NavigationItem ni = new NavigationItem(item_name, item_target);
            n.items.add(ni);
          }
          
          //print("item " + n.role.name + " " + n.name + " " + item_name + " " + item_target);
          
        }
        
        //print("Navigation: " + n.name + n.role.name);
        navigations.add(n);
        //print("--------");
      }
    }
  }
  
  ObservableList<NavigationItem> getNavigation(String name)
  {
    print("get navigtion");
    if(navigations != null && currentUser != null)
    { 
      var all = navigations.where((n) => n.role.name == currentUser.role.name && n.name == name);
      if (all.length > 0)
      {
        return all.first.items;
      }
      
      print("return empty");
      return new ObservableList<NavigationItem>();
    }
    
    print("return empty");
    return new ObservableList<NavigationItem>();
  }
  
  void setNavigation()
  {
    navigation = getNavigation("main");
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

class Navigation 
{
  String name;
  Role role;
  ObservableList<NavigationItem> items;
  
  Navigation(String name)
  {
    this.name = name;
    items = new ObservableList<NavigationItem>();
  }
}

class NavigationItem extends Observable
{
  @observable String name;
  @observable String target;
  
  NavigationItem(this.name, this.target);
}

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
    print("new person id: " + id.toString());
  }
  
  String toString() => "$firstname $name";
}
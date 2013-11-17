// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library training.web.model;

import 'package:polymer/polymer.dart';
import "config/training_config.dart";
import "data/ini_parser.dart";
import "data/data_context.dart";
import 'objects.dart';

final appModel = new AppModel._();

@reflectable
class AppModel extends Observable
{
  @observable String content = "";

  @observable User currentUser = null;

  ObservableList<Navigation> navigations = new ObservableList<Navigation>();
  @observable ObservableList<NavigationItem> navigation = new ObservableList<NavigationItem>();

  @observable DataContext data;

  AppModel._()
  {
    parseNavigation();

    data = new DataContext();

    //login("admin", "admin");
  }

  bool login(String username, String password)
  {
    var logged_in = data.login(username, password);

    if (logged_in == false)
    {
      return false;
    }

    data.loadPersons();
    data.loadTrainings();

    currentUser = data.user;
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

        }
        navigations.add(n);
      }
    }
  }

  ObservableList<NavigationItem> getNavigation(String name)
  {
    if(navigations != null && currentUser != null)
    {
      var all = navigations.where((n) => n.role.name == currentUser.role && n.name == name);
      if (all.length > 0)
      {
        return all.first.items;
      }

      return new ObservableList<NavigationItem>();
    }

    return new ObservableList<NavigationItem>();
  }

  void setNavigation()
  {
    navigation = getNavigation("main");
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
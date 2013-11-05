library training.web.role;

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
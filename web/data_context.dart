library training.web.db_context;

import 'package:polymer/polymer.dart';
import 'package:json/json.dart' as JSON;
import 'dart:html';

class User extends Observable
{
  @observable String username;
  @observable String password;
  @observable String role;
  
  User(this.username, this.password, this.role);
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
  }
  
  String toString() => "$firstname $name";
}

class DataContext
{
  String restKey ="EVOn0GZd0UnIiwFyMHbQP0rSQrNMpiR1zdllQLCx";
  String appId = "NqmWCM234shGugM6k3DL8AVUDRQLD1VP3xKXvlzt";
  
  static const String baseUri = "https://api.parse.com/1/classes/";
  
  String personUri = DataContext.baseUri + "persons";
  String usersUri = DataContext.baseUri + "users";
  
  @observable ObservableList<Person> trainers;
  @observable ObservableList<Person> children;
  
  DataContext()
  {
  }
  
  void setRequestHeader(HttpRequest request)
  {
    request.setRequestHeader("X-Parse-Application-Id", appId);
    request.setRequestHeader("X-Parse-REST-API-Key", restKey);
  }
  
  void loadPersons()
  {
    HttpRequest.request(personUri, 
        method: "GET",
        requestHeaders: {"X-Parse-Application-Id": appId, "X-Parse-REST-API-Key": restKey})
        .then(onGetPersons);    
  }
    
  void onGetPersons(HttpRequest request)
  {
    trainers = new ObservableList<Person>();
    children = new ObservableList<Person>();
    
    Map data = JSON.parse(request.responseText);
    
    for (Map item in data['results'])
    {
      Person p = new Person();
      p.id = item['objectId'];
      p.name = item['name'];
      p.firstname = item['firstname'];
      p.birthday = item['birthday'];
      p.email = item['email'];
      p.phoneNumber = item['phone'];
      p.isTrainer = item['istrainer'];
      
      if (p.isTrainer == true)
      {
        trainers.add(p);
      }
      else
      {
        children.add(p);
      }
    }
  }
  
}

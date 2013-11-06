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
    isTrainer = false;
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
  
  String personToJson(Person p)
  {
    String name = p.name;
    String fname = p.firstname;
    String email = p.email;
    String phone = p.phoneNumber;
    String birthday = p.birthday;    
    String trainer = p.isTrainer ? "true" : "false";
    
    String data = '{"name":"$name", "firstname":"$fname", "email":"$email", "birthday":"$birthday", "phone":"$phone", "istrainer":$trainer}';
    return data;
  }
  
  bool addPerson(Person p)
  {
    HttpRequest req = new HttpRequest();
    
    req.open("POST", personUri, async: false);
    setRequestHeader(req);
    req.setRequestHeader("Content-Type", "application/json");
    req.send(personToJson(p));
    
    print("STATUS: " + req.status.toString());
    
    if (req.status == 201)
    {
      if (p.isTrainer == true)
      {
        trainers.add(p);
      }
      else
      {
        children.add(p);
      }
      
      return true;
    }
    
    return false;
  }
  
  bool updatePerson(Person p)
  {
    HttpRequest req = new HttpRequest();
    
    String uri = personUri + "/" + p.id;

    req.open("PUT", uri, async: false);
    setRequestHeader(req);
    req.setRequestHeader("Content-Type", "application/json");
    req.send(personToJson(p));
    
    print("STATUS: " + req.status.toString());
    
    if (req.status == 200)
    {
      if (p.isTrainer == true && trainers.contains(p) == false)
      {
        trainers.add(p);
        children.remove(p);
      }
      else if(p.isTrainer == false && children.contains(p) == false)
      {
        children.add(p);
        trainers.remove(p);
      }
      
      return true;
    }
    
    return false;
  }
  
  bool deletePerson(Person p)
  {
    HttpRequest req = new HttpRequest();
    
    String uri = personUri + "/" + p.id;
    
    req.open("DELETE", uri, async: false);
    setRequestHeader(req);
    req.send();
    
    if (req.status == 200)
    {
      if (p.isTrainer == true)
      {
        trainers.remove(p);
      }
      else 
      {
        children.remove(p);
      }
      
      return true;
    }
    
    return false;
  }
  
  void loadPersonsAsync()
  {
    HttpRequest.request(personUri, 
        method: "GET", 
        requestHeaders: {"X-Parse-Application-Id": appId, "X-Parse-REST-API-Key": restKey})
        .then(onGetPersons);    
  }
  
  void loadPersons()
  {
    HttpRequest req = new HttpRequest();
    req.open("GET", personUri, async: false);
    setRequestHeader(req);
    req.send();
    
    onGetPersons(req);
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

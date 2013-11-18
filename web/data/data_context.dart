library training.web.db_context;

import 'package:polymer/polymer.dart';
import 'package:json/json.dart' as JSON;
import 'dart:html';
import '../objects.dart';

class PersonInTraining
{
  String id = "";
  String personId = "";
  String trainingId = "";

  PersonInTraining(this.id, this.personId, this.trainingId);
}

class DataContext
{
  String restKey ="EVOn0GZd0UnIiwFyMHbQP0rSQrNMpiR1zdllQLCx";
  String appId = "NqmWCM234shGugM6k3DL8AVUDRQLD1VP3xKXvlzt";

  static const String baseUri = "https://api.parse.com/1/classes/";

  String personUri = DataContext.baseUri + "persons";
  String userUri = DataContext.baseUri + "users";
  String trainingUri = DataContext.baseUri + "trainings";
  String personInTraingUri = DataContext.baseUri + "person_in_training";

  @observable ObservableList<Person> trainers;
  @observable ObservableList<Person> children;

  @observable ObservableList<Training> trainings;

  @observable ObservableList<User> users;
  @observable User user;

  List<PersonInTraining> personInTrainingList = new List<PersonInTraining>();

  DataContext()
  {
  }

  // ---------------------------------------------------------------------------------
  // helper methods

  void setRequestHeader(HttpRequest request)
  {
    request.setRequestHeader("X-Parse-Application-Id", appId);
    request.setRequestHeader("X-Parse-REST-API-Key", restKey);
  }

  // ---------------------------------------------------------------------------------
  // training CRUD

  bool addPersonInTraining(Person p, Training t)
  {
    HttpRequest req = new HttpRequest();

    req.open("POST", personInTraingUri, async: false);
    setRequestHeader(req);
    req.setRequestHeader("Content-Type", "application/json");

    String p_id = p.id;
    String t_id = t.id;
    String data = '{"person_id":"$p_id", "training_id":"$t_id"}';

    req.send(data);

    if (req.status == 201)
    {
      Map response = JSON.parse(req.responseText);
      String id = response['objectId'];

      personInTrainingList.add(new PersonInTraining(id, p_id, t_id));
    }
  }

  bool hasPersonInTraining(Person p, Training t)
  {
    var list = personInTrainingList.where((pit) => pit.personId == p.id && pit.trainingId == t.id);
    return (list.length > 0);
  }
  
  bool deletePersonInTrainings(Person p)
  {
    for (Training t in trainings)
    {
      if (deletePersonInTraining(p, t) == false)
      {
        return false;
      }
    }
    
    return true;
  }

  bool deletePersonInTraining(Person p, Training t)
  {
    if (hasPersonInTraining(p, t) == true)
    {
      PersonInTraining pit = personInTrainingList.where((o) => o.personId == p.id && o.trainingId == t.id).first;

      HttpRequest req = new HttpRequest();

      String uri = personInTraingUri + "/" + pit.id;

      req.open("DELETE", uri, async: false);
      setRequestHeader(req);
      req.send();

      if (req.status == 200)
      {
        personInTrainingList.remove(pit);
        
        if (p.isTrainer == true)
        {
          t.trainers.remove(p);
        }
        else
        {
          t.children.remove(p);
        }
        
        return true;
      }

      return false;

    }

    return true;
  }

  bool addTraining(Training t)
  {
    HttpRequest req = new HttpRequest();

    req.open("POST", trainingUri, async: false);
    setRequestHeader(req);
    req.setRequestHeader("Content-Type", "application/json");
    req.send(t.toJson());

    if (req.status == 201)
    {
      Map data = JSON.parse(req.responseText);
      t.id = data['objectId'];

      for(Person p in t.trainers)
      {
        if (addPersonInTraining(p, t) == false)
        {
          return false;
        }
      }

      for(Person p in t.children)
      {
        if (addPersonInTraining(p, t) == false)
        {
          return false;
        }
      }

      trainings.add(t);

      return true;
    }

    return false;
  }

  void loadTrainings()
  {
    trainings = new ObservableList<Training>();

    HttpRequest req = new HttpRequest();
    req.open("GET", trainingUri, async: false);
    setRequestHeader(req);
    req.send();

    Map data = JSON.parse(req.responseText);
    for (Map item in data['results'])
    {
      String id = item['objectId'];

      Training t = new Training();
      t.id = id;
      String notes = item['notes'];
      t.notes = notes.replaceAll("\\n", "\n");

      String date = item['date'].toString();

      if (date != null)
      {
        // get date from ISO string
        date = date.substring(20, 30);
        t.setDate(DateTime.parse(date));
      }

      personInTrainingList.clear();

      HttpRequest r = new HttpRequest();
      String uri = personInTraingUri + '?where={"training_id":"$id"}';
      r.open("GET", uri, async: false);
      setRequestHeader(r);
      r.send();

      Map entries = JSON.parse(r.responseText);
      for (Map entry in entries['results'])
      {
        String personId = entry['person_id'];
        String trainingId = entry['training_id'];
        String id = entry['objectId'];

        personInTrainingList.add(new PersonInTraining(id, personId, trainingId));

        var count = trainers.where((t) => t.id == personId).length;
        if (count > 0)
        {
          t.trainers.add(trainers.where((t) => t.id == personId).first);
        }
        else
        {
          count = children.where((t) => t.id == personId).length;
          if (count > 0)
          {
            t.children.add(children.where((t) => t.id == personId).first);
          }
        }
      }

      trainings.add(t);
    }
  }

  bool updateTraining(Training t)
  {
    HttpRequest req = new HttpRequest();

    String uri = trainingUri + "/" + t.id;

    req.open("PUT", uri, async: false);
    setRequestHeader(req);
    req.setRequestHeader("Content-Type", "application/json");
    req.send(t.toJson());

    if (req.status == 200)
    {
      for (Person p in trainers)
      {
        if (t.trainers.contains(p) == false)
        {
          deletePersonInTraining(p, t);
        }
      }
      for (Person p in children)
      {
        if (t.children.contains(p) == false)
        {
          deletePersonInTraining(p, t);
        }
      }
      return true;
    }

    return false;
  }

  bool deleteTraining(Training t)
  {
    HttpRequest req = new HttpRequest();

    String uri = trainingUri + "/" + t.id;

    req.open("DELETE", uri, async: false);
    setRequestHeader(req);
    req.send();

    if (req.status == 200)
    {
      for (Person p in trainers)
      {
        if (t.trainers.contains(p) == true)
        {
          if (deletePersonInTraining(p, t) == false)
          {
            return false;
          }
        }
      }
      for (Person p in children)
      {
        if (t.children.contains(p) == true)
        {
          if (deletePersonInTraining(p, t) == false)
          {
            return false;
          }
        }
      }

      trainings.remove(t);
      return true;
    }

    return false;
  }

  // ---------------------------------------------------------------------------------
  // persons CRUD

  bool addPerson(Person p)
  {
    HttpRequest req = new HttpRequest();

    req.open("POST", personUri, async: false);
    setRequestHeader(req);
    req.setRequestHeader("Content-Type", "application/json");
    req.send(p.toJson());

    if (req.status == 201)
    {
      Map data = JSON.parse(req.responseText);
      p.id = data['objectId'];

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
    req.send(p.toJson());

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
      
      if (deletePersonInTrainings(p) == false)
      {
        return false;
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
        .then(parsePersonResponse);
  }

  void loadPersons()
  {
    HttpRequest req = new HttpRequest();
    req.open("GET", personUri, async: false);
    setRequestHeader(req);
    req.send();

    parsePersonResponse(req);
  }

  void parsePersonResponse(HttpRequest request)
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

  // ---------------------------------------------------------------------------------
  // Users CRUD

  bool addUser(User u)
  {
    HttpRequest req = new HttpRequest();

    req.open("POST", userUri, async: false);
    setRequestHeader(req);
    req.setRequestHeader("Content-Type", "application/json");
    req.send(u.toJson());

    if (req.status == 201)
    {
      Map data = JSON.parse(req.responseText);
      u.id = data['objectId'];

      users.add(u);

      return true;
    }

    return false;
  }

  bool updateUser(User u)
  {
    HttpRequest req = new HttpRequest();

    String uri = userUri + "/" + u.id;

    req.open("PUT", uri, async: false);
    setRequestHeader(req);
    req.setRequestHeader("Content-Type", "application/json");
    req.send(u.toJson());

    if (req.status == 200)
    {
      return true;
    }

    return false;
  }

  bool deleteUser(User u)
  {
    if (u.id == user.id)
    {
      // cannot delete current user
      return false;
    }

    HttpRequest req = new HttpRequest();

    String uri = userUri + "/" + u.id;

    req.open("DELETE", uri, async: false);
    setRequestHeader(req);
    req.send();

    if (req.status == 200)
    {
      users.remove(u);

      return true;
    }

    return false;
  }

  // ---------------------------------------------------------------------------------
  // login

  bool login(String username, String password)
  {
    HttpRequest req = new HttpRequest();

    var uri = userUri;

    req.open("GET", uri, async: false);
    setRequestHeader(req);

    req.send();

    Map data = JSON.parse(req.responseText);
    if (data['results'].length == 0)
    {
      return false;
    }

    users = new ObservableList<User>();

    for (Map item in data['results'])
    {
      String un = item['username'];
      String role = item['role'];
      String pw = item['password'];
      String id = item['objectId'];

      User u = new User();
      u.id = id;
      u.username = un;
      u.password = pw;
      u.role = role;

      users.add(u);
    }

    var check_users = users.where((u) => u.username == username && u.password == password);

    if (check_users.length > 0)
    {
      user = check_users.first;
      return true;
    }

    return false;
  }
}
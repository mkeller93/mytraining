library training.web.training_config;

class TrainingConfig
{
  static final String config =
      "[main]/" +
      "admin=Persons:#persons;Trainings:#trainings;Users:#users/" +
      "user=Persons:#persons;Trainings:#trainings/" +
      "viewer=Persons:#persons;Trainings:#trainings/" +
      "[persons]/" +
      "admin=List:list;Add person:add;Edit person:edit;/" +
      "user=List:list;/" +
      "viewer=List:list/" +
      "[trainings]/" +
      "admin=List:list;Add training:add;Edit Training:edit;/" +
      "user=List:list;Add training:add/" +
      "viewer=List:list/" +
      "[users]/" +
      "admin=List:list;Add User:add;Edit User:edit;/" +
      "user=/" +
      "viewer=/";
}
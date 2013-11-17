library training.web.training_config;

class TrainingConfig
{
  static final String config =
      "[main]/" +
      "admin=Home:#home;Persons:#persons;Trainings:#trainings;Users:#users;Settings:#settings/" +
      "user=Home:#home;Persons:#persons;Trainings:#trainings;Settings:#settings/" +
      "viewer=Home:#home;Persons:#persons;Trainings:#trainings;Settings:#settings/" +
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
      "viewer=/" +
      "[settings]/" +
      "admin=Home:home;Change Password:changepw;/" +
      "user=Home:home;Change Password:changepw;/" +
      "viewer=Home:home;Change Password:changepw;/";
}
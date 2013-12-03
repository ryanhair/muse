part of car_lot.model;

@Model
class Person {
  @Id
  String id;
  
  @Required
  String firstName;
  
  @Required
  String lastName;
  
  @Required
  @Matches(r'^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$')
  String email;
  
  String phone;
  
  @DefaultValue('male')
  @Choices(const ['male', 'female'])
  String gender;
}
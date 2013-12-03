part of car_lot.model;

@Model
class Tire {
  @Id
  String id;
  
  @Required
  double treadState; //Between 0 and 1
  
  @Required
  double size;
}
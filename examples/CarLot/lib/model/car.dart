part of car_lot.model;

@Model
class Car {
  @Id
  String id;
  
  @Required
  @Matches(r"\w{17}")
  String vin;
  
  @Required
  String make;
  
  @Required
  String model;
  
  @Min(1800.0)
  int year;
  
  @Min(0.0)
  int miles;
  
  List<Tire> tires;
  
  List<int> tags;
  
  Car() {
    tires = new List<Tire>();
    tags = new List<int>();
  }
}
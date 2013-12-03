library car_lot.model;

import 'package:muse_core/muse.dart';

part 'car.dart';
part 'person.dart';
part 'tire.dart';

@Model
class CarLot {
  @Id
  String id;
  
  DateTime established;
  
  List<Car> cars;
  
  Person owner;
  
  String web;
  
  String phone;
  
  List<Person> employees;
  
  List<int> tags;
  
  CarLot() {
    cars = new List<Car>();
    employees = new List<Person>();
    tags = new List<int>();
  }
}
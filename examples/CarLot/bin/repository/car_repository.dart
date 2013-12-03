part of car_lot;

@Repository()
class CarRepo extends MongoRepository<Car> {
  CarRepo() : super('Car') {}
}
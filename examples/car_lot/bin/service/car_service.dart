part of car_lot;

@Service()
class CarService {
  @Inject()
  CarRepo carRepo;
  
  Stream<Car> getAll() {
    return carRepo.query({});
  }
  
  Future<Car> get(String id) {
    return carRepo.get(id);
  }
  
  Future<Car> save(Car car) {
    return carRepo.save(car);
  }
  
  void delete(String id) {
    return carRepo.delete(id);
  }
}
part of car_lot;

@Controller()
@RequestMapping('/cars')
class CarController {
  @Inject
  CarService carService;
  
//  @Consumes(const ['application/json', 'text/xml'])
//  @Produces(const ['application/json', 'text/xml'])
  @Get()
  Stream<Car> getAllCars([@Param('skip') int skip = 0, @Param('take') int take = 1000]) {
    return carService.getAll().skip(skip).take(take);
  }
  
//  @Consumes(const ['application/json', 'text/xml'])
//  @Get('/new')
//  getNewCars() {
//    
//  }
  
//  @Consumes(const ['application/json', 'text/xml'])
  @Get('/:id')
  Future<Car> getCar(@UrlParam('id') String id) {
    return carService.get(id);
  }
  
//  @Consumes(const ['application/json', 'text/xml'])
  @Post('/')
  saveCar(@ContentBody() Car car) {
    return carService.save(car);
  }
  
  @Put('/:id')
  updateCar(@UrlParam('id') String id, @ContentBody() Car car) {
    if(id != car.id) throw new HttpResponseException('id from uri must match id from car in post body', 400);
    return carService.save(car);
  }
  
  @Delete('/:id')
  deleteCar(@UrlParam('id') String id) {
    carService.delete(id);
  }
  
  @Post('/image')
  saveCarImage(@RawStream() Stream<List<int>> stream) {
    var f = new File('testimg.png');
    var writer = f.openWrite(mode: FileMode.WRITE);
    stream.listen((List<int> data) {
      data.forEach((int byte) => writer.write(byte));
    });
  }
}
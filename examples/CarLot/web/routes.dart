import 'package:angular/angular.dart';

class CarLotRouter implements RouteInitializer {
  void init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
        name: 'cars',
        path: '/cars',
        enter: view('cars.html')
      )
      ..addRoute(
        name: 'carDetails',
        path: '/cars/:carId/details',
        enter: view('carDetails.html')
      );
  }
}
import 'package:angular/angular.dart';
import 'package:logging/logging.dart';

class CarLotApp extends Module {
  CarLotApp() {
    //Register types here with type()
  }
}

main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) => print(r.message));
  ngBootstrap(module: new CarLotApp());
}
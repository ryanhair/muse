library car_lot;

import 'dart:io';
import 'dart:async';
import 'package:muse_core/muse.dart';
import 'package:muse_http_controller/http_controller.dart';
import 'package:muse_mongo_repo/mongo_repo.dart';
import 'package:car_lot/model/car_lot.dart';

part 'controller/car_controller.dart';
part 'service/car_service.dart';
part 'repository/car_repository.dart';

void main() {
  MongoRepositoryBase.setDb('mongodb://ryandhair@gmail.com:password@ds049538.mongolab.com:49538/car_lot');
  Muse.init();
  HttpController.init('localhost', 8005);
}
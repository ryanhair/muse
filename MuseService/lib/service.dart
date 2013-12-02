library muse.service;

import 'dart:mirrors';
import 'package:muse/muse.dart';

class Service extends Component {
  const Service();
  
  static Map<Type, dynamic> services = new Map<Type, dynamic>();
  static void init() {
    Muse.components.forEach((Type k, v) {
      if(reflectClass(k).metadata.any((m) => m.reflectee is Service)) {
        services[k] = v;
      }
    });
  }
}
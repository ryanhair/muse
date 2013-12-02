library muse.controller;

import 'dart:mirrors';
import 'package:muse/muse.dart';

class Controller extends Component {
  const Controller();
  
  static Map<Type, dynamic> controllers = new Map<Type, dynamic>();
  static void init() {
    Muse.components.forEach((Type k, v) {
      if(reflectClass(k).metadata.any((m) => m.reflectee is Controller)) {
        controllers[k] = v;
      }
    });
  }
}
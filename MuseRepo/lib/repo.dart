library muse.repo;

import 'dart:mirrors';
import 'package:muse/muse.dart';

class Repository extends Component {
  const Repository();
  
  static Map<Type, dynamic> repositories = new Map<Type, dynamic>();
  static void init() {
    Muse.components.forEach((Type k, v) {
      if(reflectClass(k).metadata.any((m) => m.reflectee is Repository)) {
        repositories[k] = v;
      }
    });
  }
}
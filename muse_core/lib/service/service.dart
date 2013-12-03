part of muse.core;

class Service extends Component {
  const Service();
  
  static void init() {
    Injector.getNamespace().forEach((Type k, v) {
      if(reflectClass(k).metadata.any((m) => m.reflectee is Service)) {
        Injector.register(v, 'services');
      }
    });
  }
}
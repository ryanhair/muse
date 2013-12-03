part of muse.core;

class Controller extends Component {
  const Controller();
  
  static void init() {
    Injector.getNamespace().forEach((Type k, v) {
      if(reflectClass(k).metadata.any((m) => m.reflectee is Controller)) {
        Injector.register(v, 'controllers');
      }
    });
  }
}
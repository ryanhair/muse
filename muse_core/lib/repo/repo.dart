part of muse.core;

class Repository extends Component {
  const Repository();
  
  static void init() {
    Injector.getNamespace().forEach((Type k, v) {
      if(reflectClass(k).metadata.any((m) => m.reflectee is Repository)) {
        Injector.register(v, 'repositories');
      }
    });
  }
}
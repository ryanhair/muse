  part of muse.core;

class SingletonAlreadyRegisteredException implements Exception {}
class SingletonNotFoundException implements Exception {}
class NamespaceNotFoundException implements Exception {}

class Injector {
  static Map<String, Map<Type, dynamic>> _singletons = new Map<String, Map<Type, dynamic>>();
  static void register(dynamic val, [String namespace = '']) {
    Type type = reflect(val).type.reflectedType;
    
    if(!_singletons.containsKey(namespace)) {
      _singletons[namespace] = new Map<Type, dynamic>();
    }
    if(_singletons[namespace].containsKey(type)) {
      throw new SingletonAlreadyRegisteredException();
    }
    
    _singletons[namespace][type] = val;
  }
  
  static dynamic getValue(Type type, [String namespace = '']) {
    var ns = getNamespace(namespace);
    if(!ns.containsKey(type)) {
      throw new SingletonNotFoundException();
    }
    
    return _singletons[namespace][type];
  }
  
  static Map<Type, dynamic> getNamespace([String namespace = '']) {
    if(!_singletons.containsKey(namespace)) {
      throw new NamespaceNotFoundException();
    }
    return _singletons[namespace];
  }
}

class _Inject {
  const _Inject();
  
  call(String namespace) {
    
  }
}
const Inject = const _Inject();

class Test {
  @Inject
  String val;
  
  @Inject('n1')
  String val2;
}
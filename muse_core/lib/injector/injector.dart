  part of muse.core;

class SingletonAlreadyRegisteredException implements Exception {}
class SingletonNotFoundException implements Exception {}
class NamespaceNotFoundException implements Exception {}

/**
 * Dependency injection for the Muse framework.
 */
class Injector {
  static Map<String, Map<Type, dynamic>> _singletons = new Map<String, Map<Type, dynamic>>();
  
  /**
   * register singletons to be used
   * application wide, or hide the singletons
   * in a namespace.  For example:
   * 
   *     register(new CarService(), 'services');
   * 
   * these can then later be retrieved with [getValue]
   */
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
  
  /**
   * Get a previously registered singleton.
   * For example:
   * 
   *     getValue(CarService, 'services');
   */
  static dynamic getValue(Type type, [String namespace = '']) {
    var ns = getNamespace(namespace);
    if(!ns.containsKey(type)) {
      throw new SingletonNotFoundException();
    }
    
    return _singletons[namespace][type];
  }
  
  /**
   * Get all registered singletons in a namespace.
   * For example:
   * 
   *     getNamespace('services');
   */
  static Map<Type, dynamic> getNamespace([String namespace = '']) {
    if(!_singletons.containsKey(namespace)) {
      throw new NamespaceNotFoundException();
    }
    return _singletons[namespace];
  }
}

class Inject {
  final namespace;
  const Inject([this.namespace='']);
}
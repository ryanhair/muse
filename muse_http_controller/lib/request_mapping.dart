part of muse.controller.http;

class RequestMapping {
  final String url;
  const RequestMapping(this.url);
  
  static Map types = {
    'GET': Get,
    'POST': Post,
    'PUT': Put,
    'DELETE': Delete
  };
  
  static String _trimSlashes(str) {
    while(str.startsWith('/'))
      str = str.substring(1);
    while(str.endsWith('/'))
      str = str.substring(0, str.length - 1);
    
    return str;
  }
  
  /**
   * Return whether or not this controller
   * matches the supplied request
   */
  bool matches(HttpRequest request) {
    return _trimSlashes(request.uri.path).startsWith(_trimSlashes(url));
  }
  
  /**
   * Return handler that matches this request, if any,
   * otherwise return null.
   * 
   * A request matches if all of the RequestMapper metadata
   * on the method and in the params return true for
   * matchesRequest, and if all non-marked parameters
   * can be found in either the url params, request params,
   * headers, or body.
   */
  Future<HandlerDescriptor> findHandler(dynamic controller, HttpRequest request) {
    if(!matches(request)) return null;
    var completer = new Completer();
    var hasDescriptor = false;
    
    var t = types[request.method];
    var reflection = reflect(controller);
    var futures = [];
    
    reflection.type.declarations.forEach((Symbol name, DeclarationMirror dm) {
      if(dm is! MethodMirror) return;
      MethodMirror method = dm as MethodMirror;
      
      if(method.isConstructor)
        return;
      
      InstanceMirror metaMirror = method.metadata.firstWhere((md) {
        return md.type.reflectedType == t;
      }, orElse: () => null);
      if(metaMirror == null) return;
      
      HttpMethod meta = metaMirror.reflectee;
      if(meta == null) return;
      
//    Check for valid url (same semantic length)
      if(request.uri.pathSegments.length != _trimSlashes((_trimSlashes(url) + '/' + _trimSlashes(meta.path))).split('/').length)
        return;
      
      hasDescriptor = true;
      
      var urlData = meta.parseUrl(url, request.uri);
      var named = {};
      var positional = [];
      
      Future.wait(method.parameters.map((ParameterMirror pm) {
        if(pm.isNamed) {
          return getValueForParameter(pm, request, urlData).then((val) {
            named[MirrorSystem.getName(pm.simpleName)] = val;
          });
        }
        else {
          return getValueForParameter(pm, request, urlData).then((val) {
            positional.add(val);
          });
        }
      })).then((_) {
        if(!completer.isCompleted) {
          completer.complete(
            new HandlerDescriptor()
              ..methodName = name
              ..named = named
              ..positional = positional
          );
        }
      });
    });
    
    if(!hasDescriptor) {
      completer.complete(null);
    }
    
    return completer.future;
  }
  
  Future<dynamic> getValueForParameter(ParameterMirror pm, HttpRequest request, Map urlData) {
    var reflectedMapper = pm.metadata.firstWhere((m) {
      return m.reflectee is RequestMapper;
    }, orElse: () => null);
    if(reflectedMapper != null) {
      RequestMapper mapper = reflectedMapper.reflectee;
      return mapper.requestToData(pm, request, urlData).then((val) {
        if(val == null && pm.defaultValue != null) val = pm.defaultValue.reflectee;
        return val;
      });
    }
  }
}

class HandlerDescriptor {
  Symbol methodName;
  List positional;
  Map named;
  
  toString() {
    return methodName.toString() + '\n' + positional.toString() + '\n' + named.toString();
  }
}
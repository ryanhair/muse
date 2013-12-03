import 'dart:html';
import 'dart:mirrors';
import 'dart:async';
import 'dart:convert';

@proxy
class RpcProxy {
  Type type;
  ClassMirror classMirror;
  RpcProxy.generate(this.type) {
    classMirror = reflectClass(type);
    
//    if(!classMirror.metadata.any((m) => m == Remote)) {
//      throw new Exception('Supplied type must be marked with `Remote` metadata');
//    }
  }
  
  noSuchMethod(Invocation invocation) {
    var methodMirror = classMirror.declarations[invocation.memberName] as MethodMirror;
    if(MirrorSystem.getName(methodMirror.returnType.simpleName) != 'Future' && methodMirror.returnType.simpleName != const Symbol('void')) {
      throw new Exception('All methods on a `Remote` class must return type `Future` or void');
    }
    
    var req = new HttpRequest(),
        completer = new Completer();
    req.onReadyStateChange.listen((_) {
      if(req.readyState == HttpRequest.DONE && (req.status == 200 || req.status == 0)) {
        var data = JSON.decode(req.responseText);
        //convert data back into actual objects to return
        completer.complete(convertPrimitiveToClass(data));
      }
    });
    
    req.open("POST", 'http://localhost:8002/r_connect/' + MirrorSystem.getName(classMirror.simpleName) + '/' + MirrorSystem.getName(invocation.memberName));
    //Serialize named parameters and positional parameters into json (meta format, with name and data keys)
    req.send(JSON.encode({
      'class': MirrorSystem.getName(classMirror.qualifiedName),
      'method': MirrorSystem.getName(methodMirror.simpleName),
      'positional': convertClassToPrimitive(invocation.positionalArguments),
      'named': convertClassToPrimitive(invocation.namedArguments)
    }));
    
    return completer.future;
  }
}
import 'dart:mirrors';

class Convert {
  /**
   * Will convert a model to it's primitive representation
   */
  static dynamic toPrimitive(model) {
    dynamic data = null;
    String type = null;
    if(model is List) {
      type = 'List';
      data = model.map(toPrimitive).toList();
    }
    else if(model is Map) {
      var n = new Map();
      model.forEach((k, v) {
        if(k is! String) {
          throw new Exception('Map keys must be of type of String to be converted to basic object');
        }
        n[k] = toPrimitive(v);
      });
      
      type = 'Map';
      data = n;
    }
    else if(model is num || model is String || model is bool || model == null) {
      if(type == null) {
        if(model is num) {
          type = 'num';
        }
        else if(model is String) {
          type = 'String';
        }
        else if(model is bool) {
          type = 'bool';
        }
        else if(model == null) {
          type = 'null';
        }
      }
      data = model;
    }
    else {
      var reflection = reflect(model);
      data = {};
      reflection.type.declarations
        .keys
          .where((Symbol name) {
            return reflection.type.declarations[name] is VariableMirror && !reflection.type.declarations[name].isPrivate;
          })
            .forEach((Symbol name) {
              var field = reflection.getField(name);
              var val = field.reflectee;
              data[MirrorSystem.getName(name)] = toPrimitive(val);
            });
      
      reflection.type.declarations
        .keys
          .where((Symbol name) {
            var t = reflection.type.declarations[name];
            return t is MethodMirror && t.isGetter && !t.isPrivate;
          })
            .forEach((Symbol name) {
              var val = reflection.getField(name).reflectee;
              data[MirrorSystem.getName(name)] = toPrimitive(val);
            });
      
      type = MirrorSystem.getName(reflection.type.qualifiedName);
    }
    return {
      'type': type,
      'data': data
    };
  }
  
  static dynamic toClass(info) {
    var type = info['type'];
    var data = info['data'];
    
    if(type == 'num' || type == 'String' || type == 'bool' || type == 'null') {
      return data;
    }
    
    if(type == 'List') return (data as List).map(toClass).toList();
    else if(type == 'Map') {
      var newData = {};
      (data as Map).forEach((k, v) => newData[k] = toClass(v));
      return newData;
    }
    else {
      ClassMirror classMirror = classFromPath(type);
      var inst = classMirror.newInstance(const Symbol(''), []);
      
      (data as Map).forEach((k, v) {
        inst.setField(MirrorSystem.getSymbol(k, libraryFromPath(type)), toClass(v));
      });
      
      return inst.reflectee;
    }
  }
  
  static LibraryMirror libraryFromPath(path) {
    var pieces = path.split('.');
    return currentMirrorSystem().findLibrary(new Symbol(pieces[0]));
  }
  
  static ClassMirror classFromPath(path) {
    var pieces = path.split('.');
    var lib = currentMirrorSystem().findLibrary(new Symbol(pieces[0]));
    return lib.declarations[new Symbol(pieces[1])];
  }
}
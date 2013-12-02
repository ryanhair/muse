library muse.model;

import 'dart:mirrors';
import 'validators/validator.dart';

export 'validators/validator.dart';

part 'id.dart';
part 'default_value.dart';

class _Model {
  const _Model();
  void validate(obj) {
    var reflection = reflect(obj);
    reflection.type.declarations.keys
      .where((k) => reflection.type.declarations[k] is VariableMirror)
      .forEach((Symbol name) {
        VariableMirror variable = reflection.type.declarations[name];
        var stringName = MirrorSystem.getName(name);
        print(stringName);
        var propData = reflection.getField(name).reflectee;
        var metadata = variable.metadata;
        var validators = metadata.where((m) => m.hasReflectee && m.reflectee is Validator);
        validators.forEach((InstanceMirror validatorMirror) {
          validatorMirror.reflectee.eval(stringName, propData);
        });
      });
  }
  
  /**
   * Will convert a model to it's primitive representation
   */
  dynamic toPrimitive(model) {
    if(model is List) {
      return model.map(toPrimitive).toList();
    }
    else if(model is Map) {
      var n = new Map();
      model.forEach((k, v) {
        if(k is! String) {
          throw new Exception('Map keys must be of type of String to be converted to basic object');
        }
        n[k] = toPrimitive(v);
      });
      return n;
    }
    else if(model is num || model is String || model is bool || model == null) {
      return model;
    }
    
    var reflection = reflect(model);
    var data = {};
    reflection.type.declarations
      .keys
      .where((Symbol name) {
        return reflection.type.declarations[name] is VariableMirror && !reflection.type.declarations[name].isPrivate;
      })
      .forEach((Symbol name) {
        var val = reflection.getField(name).reflectee;
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
    
    return data;
  }
}

const Model = const _Model();
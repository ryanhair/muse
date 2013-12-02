library muse;

import 'dart:mirrors';

part 'component.dart';
part 'injector.dart';

class Muse {
  static Map<Type, dynamic> components = new Map<Type, dynamic>();
  
  static void init() {
    MirrorSystem mirror = currentMirrorSystem();
    for(LibraryMirror lib in mirror.libraries.values) {
      for(ClassMirror cls in lib.declarations.values.where((i) => i is ClassMirror)) {
        for (InstanceMirror mirror in cls.metadata) {
          if(mirror.reflectee is Component) {
            var instMirror = cls.newInstance(const Symbol(''), []);
            components[cls.reflectedType] = instMirror.reflectee;
          }
        }
      }
    }
    
    for(var value in components.values) {
      InstanceMirror mirror = reflect(value);
      mirror.type.declarations.keys.where((Symbol s) => mirror.type.declarations[s] is VariableMirror)
        .forEach((Symbol s) {
          var vm = mirror.type.declarations[s];
          if(vm.metadata.any((m) => m.reflectee == Inject)) {
            ClassMirror type = vm.type;
            mirror.setField(s, components[type.reflectedType]);
          }
        });
    }    
  }
  
//  static void Register(componentType) {
//    
//  }
}
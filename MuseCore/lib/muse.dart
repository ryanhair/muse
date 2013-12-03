library muse.core;

import 'dart:mirrors';

part 'injector/injector.dart';

part 'component/component.dart';

part 'controller/controller.dart';

part 'service/service.dart';

part 'repo/repo.dart';

part 'model/model.dart';
part 'model/id.dart';
part 'model/default_value.dart';
part 'model/validators/validator.dart';
part 'model/validators/choices.dart';
part 'model/validators/matches.dart';
part 'model/validators/max.dart';
part 'model/validators/min.dart';

class Muse {
  static void init() {
    MirrorSystem mirror = currentMirrorSystem();
    for(LibraryMirror lib in mirror.libraries.values) {
      for(ClassMirror cls in lib.declarations.values.where((i) => i is ClassMirror)) {
        for (InstanceMirror mirror in cls.metadata) {
          if(mirror.reflectee is Component) {
            var instMirror = cls.newInstance(const Symbol(''), []);
            Injector.register(instMirror.reflectee);
          }
        }
      }
    }
    
    for(var value in Injector.getNamespace().values) {
      InstanceMirror mirror = reflect(value);
      mirror.type.declarations.keys.where((Symbol s) => mirror.type.declarations[s] is VariableMirror)
        .forEach((Symbol s) {
          var vm = mirror.type.declarations[s];
          if(vm.metadata.any((m) => m.reflectee == Inject)) {
            ClassMirror type = vm.type;
            mirror.setField(s, Injector.getValue(type.reflectedType));
          }
        });
    }    
  }
}
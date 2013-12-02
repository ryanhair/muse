library muse.model.validator;

part 'choices.dart';
part 'matches.dart';
part 'min.dart';
part 'max.dart';

abstract class Validator {
  eval(String propName, dynamic val);  
  const Validator();
}

class _Required extends Validator {
  const _Required();
  
  @override
  eval(String propName, dynamic val) {
    if(val == null) {
      throw new Exception('Value required for $propName');
    }
  }
}

const Required = const _Required();
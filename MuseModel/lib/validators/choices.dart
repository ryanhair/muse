part of muse.model.validator;

class Choices extends Validator {
  final List<dynamic> choices;
  const Choices(List<dynamic> this.choices);
  
  @override
  eval(propName, val) {
    if(!choices.contains(val)) {
      throw new Exception('$propName must be one of $choices');
    }
  }
}
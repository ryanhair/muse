part of muse.model.validator;

class Min extends Validator {
  final double min;
  const Min(this.min);
  
  @override
  eval(String propName, double val) {
    if(val < min) {
      throw new Exception('$propName must be greater than or equal to $min');
    }
  }
}
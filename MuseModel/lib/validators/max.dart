part of muse.model.validator;

class Max extends Validator {
  final double max;
  const Max(this.max);
  
  @override
  eval(String propName, double val) {
    if(val < max) {
      throw new Exception('$propName must be less than or equal to $max');
    }
  }
}
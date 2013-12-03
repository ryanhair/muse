part of muse.core;

class Matches extends Validator {
  final String _rgx;
  const Matches(this._rgx);
  
  @override
  eval(String propName, String val) {
    var rgx = new RegExp(_rgx);
    
    if(!rgx.hasMatch(val)) {
      throw new Exception('$propName does not match $rgx');
    }
  }
}
library test;

import 'package:muse_rpc/convert.dart';


class TestClass {
  String item1;
  int item2 = 100;
  bool item3 = true;
  
  Map more = {
    'test': 'stuff',
    'right': 'here',
    'cool': 30
  };
  
  List stuff = [1, 2, 3];
}

class TestClass2 {
  TestClass tc;
  Map yep = {
    'item1': 3,
    'item2': new TestClass()
  };
}

main() {
  var a = new TestClass2();
  TestClass2 t = Convert.toClass(Convert.toPrimitive(a));
  print(t.tc);
  print(t.yep['item2'].item2);
}
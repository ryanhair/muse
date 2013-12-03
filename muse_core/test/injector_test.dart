import 'package:unittest/unittest.dart';
import 'package:muse_core/muse.dart';
import 'package:unittest/vm_config.dart';

class TestData {}
class TestData2 {}

main() {
  useVMConfiguration();
  group('Injector', () {
    var td = new TestData();
    var td2 = new TestData();
    
    test('GetFromNonExistentNamespace', () {
      expect(() => Injector.getValue(TestData), throwsA(new isInstanceOf<NamespaceNotFoundException>()));
    });
    
    test('InjectorRegisterInNewNamespace', () {
      Injector.register(td, 'test');
      expect(Injector.getValue(TestData, 'test'), equals(td));
    });
    
    test('RegisterSameTypeInSameNamespace', () {
      expect(() => Injector.register(new TestData(), 'test'), throwsA(new isInstanceOf<SingletonAlreadyRegisteredException>()));
    });
    
    test('RegisterSameTypeInDifferentNamespace', () {
      Injector.register(td2, 'n2');
      expect(Injector.getValue(TestData, 'n2'), equals(td2));
    });
    
    test('GetNonexistentItemFromNamespace', () {
      expect(() => Injector.getValue(TestData2, 'test'), throwsA(new isInstanceOf<SingletonNotFoundException>()));
    });
  });
}
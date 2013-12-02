import 'dart:io';
import 'dart:convert';
import 'package:mustache/mustache.dart' as mustache;

main() {
  var f = new File('../lib/templates/class_template.dart_tmpl');
  var reader = f.openRead();
  f.readAsString(encoding: UTF8).then((str) {
    var output = mustache.parse(str, lenient: true).renderString({
      'imports': [
        'dart:async',
        'dart:html',
        'package:'
      ],
      'className': 'CarController',
      'methods': [
        {
          'method': 'GET',
          'name': 'getCar',
          'returnType': 'Future<Car>',
          'parameters': [
            {
              'type': 'String',
              'name': 'id',
              'last': true
            }
          ],
          'data': 'null'
        }
      ]
    });
    new File('_test.dart').writeAsString(output, flush: true);
    print(output);
  });
}
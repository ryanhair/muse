library r_connect;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'convert.dart';

setup() {
  HttpServer.bind('localhost', 8002).then((HttpServer server) {
    server.listen((HttpRequest request) {
      print(request.uri.path);
      if(request.uri.path.startsWith('/r_connect')) {
        request.transform(UTF8.decoder).toList().then((lines) {
          var data = JSON.decode(lines.join(''));
          //Deserialize data into actual Dart classes
          var positional = Convert.toClass(data['positional']);
          var named = Convert.toClass(data['named']);
          var cls = Convert.classFromPath(data['class']);
          try {
            var inst = cls.newInstance(const Symbol(''), []);
            (inst.invoke(new Symbol(data['method']), positional, named).reflectee as Future).then((data) {
              request.response.headers.add("Access-Control-Allow-Origin", "*");
              request.response.headers.add("Access-Control-Allow-Methods", "POST,GET,DELETE,PUT,OPTIONS");
              request.response.write(JSON.encode(Convert.toPrimitive(data)));
              request.response.close();
            });
          }
          catch (e) {
            print(e);
          }
        });
      }
    });
  });
}
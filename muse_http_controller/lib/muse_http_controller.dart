library muse.controller.http;

import 'package:muse_core/muse.dart';
import 'request_mappers/request_mapper.dart';
import 'response_mappers/response_mapper.dart';
import 'response_exceptions/response_exception.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:mirrors';

export 'request_mappers/request_mapper.dart';
export 'response_exceptions/response_exception.dart';
export 'response_mappers/response_mapper.dart';

part 'http_methods.dart';
part 'http_dispatcher.dart';
part 'request_mapping.dart';
part 'consumes.dart';
part 'produces.dart';

class HttpController extends Controller {
  const HttpController();
  
  static void init([String host = 'localhost', int port = 8000]) {
    Controller.init();
    
    var controllers = Injector.getNamespace('controllers');
    var httpControllers = {};
    controllers.forEach((Type t, dynamic controller) {
      if(reflectClass(t).metadata.any((m) => m.reflectee is HttpController)) {
        httpControllers[t] = controller;
      }
    });
    HttpRequestDispatcher.init(httpControllers);
    HttpServer.bind(host, port).then((HttpServer server) {
      /*
       * Whenever we get a request in, we try to find a controller with a request mapping that matches
       * the request, then we search for a specific handler on that controller that can handle
       * the request.  If we find one, we then setup all the data that handler needs (based on
       * metadata), and invoke that handler with necessary data.
       */
      server.listen((HttpRequest request)  {
        new HttpRequestDispatcher(request);
      });
      print('listening @ $host:$port');
    });
  }
  
  File generateConsumer(controller) {
    
  }
}
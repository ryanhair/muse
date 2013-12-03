library muse.controller.http.request_mapper;

import 'dart:async';
import 'dart:mirrors';
import 'dart:io';
import 'dart:convert';

part 'param.dart';
part 'url_param.dart';
part 'content_body.dart';
part 'raw_stream.dart';

abstract class RequestMapper {
  Future<dynamic> requestToData(ParameterMirror mirror, HttpRequest request, Map urlData);
  Future<bool> matchesRequest(ParameterMirror mirror, HttpRequest request, Map urlData);
}
library muse.controller.http.response_mapper;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:muse_core/muse.dart';

part 'json_mapper.dart';

abstract class ResponseMapper {
  static JsonEncoder jsonEncoder = new JsonEncoder();
  void handleResponse(dynamic data, HttpResponse response);
}
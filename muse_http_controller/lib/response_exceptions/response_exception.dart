library muse.controller.http.response_exceptions;

part 'not_found_exception.dart';

class HttpResponseException implements Exception {
  String message;
  int errorCode;
  
  HttpResponseException(this.message, this.errorCode);
}
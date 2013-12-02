part of muse.controller.http.response_exceptions;

class HttpResponseNotFoundException extends HttpResponseException {
  HttpResponseNotFoundException() : super('Not Found', 404) {}
}
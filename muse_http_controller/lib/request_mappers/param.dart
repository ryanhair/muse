part of muse.controller.http.request_mapper;

/**
 * Marks a method parameter as one to be populated
 * by a request param
 */
class Param implements RequestMapper {
  final String name;
  const Param(this.name);
  
  Future<bool> matchesRequest(ParameterMirror mirror, HttpRequest request, Map urlData) {
    return new Future.sync(() => request.uri.queryParameters.containsKey(name));
  }
  
  Future<dynamic> requestToData(ParameterMirror mirror, HttpRequest request, Map urlData) {
    dynamic val = request.uri.queryParameters[name];
    if(mirror.type is ClassMirror && mirror.type.simpleName == const Symbol('int') && val != null) {
      val = int.parse(val, radix: 10);
    }
    return new Future.sync(() => val);
  }
}
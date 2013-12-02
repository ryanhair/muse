part of muse.controller.http.request_mapper;

/**
 * Marks a method parameter as one to be populated
 * by a url parameter
 */
class UrlParam implements RequestMapper {
  final String name;
  const UrlParam(this.name);
  
  Future<bool> matchesRequest(ParameterMirror mirror, HttpRequest request, Map urlData) {
    return new Future.sync(() => urlData.containsKey(name));
  }
  
  Future<dynamic> requestToData(ParameterMirror mirror, HttpRequest request, Map urlData) {
    return new Future.sync(() => urlData[name]);
  }
}
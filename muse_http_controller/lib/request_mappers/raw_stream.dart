part of muse.controller.http.request_mapper;

class RawStream implements RequestMapper {
  const RawStream();
  Future<bool> matchesRequest(ParameterMirror mirror, HttpRequest request, Map urlData) {
    return new Future.sync(() => true);
  }
  
  Future<dynamic> requestToData(ParameterMirror mirror, HttpRequest request, Map urlData) {
    return new Future.sync(() => request.asBroadcastStream());
  }
}
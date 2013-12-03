part of muse.controller.http.request_mapper;

class ContentBody implements RequestMapper {
  const ContentBody();
  
  Future<bool> matchesRequest(ParameterMirror mirror, HttpRequest request, Map urlData) {
    return new Future.sync(() => true);
  }
  
  Future<dynamic> requestToData(ParameterMirror mirror, HttpRequest request, Map urlData) {
    if(mirror.type is ClassMirror) {
      var clsMirror = mirror.type as ClassMirror;
      var inst = clsMirror.newInstance(const Symbol(''), []);
      return request.asBroadcastStream().transform(UTF8.decoder).toList().then((lines) {
        var body = lines.join('');
        Map data = JSON.decode(body);
        clsMirror.declarations.forEach((Symbol k, v) {
          var propName = MirrorSystem.getName(k);
          if(data.containsKey(propName)) {
            inst.setField(k, data[propName]);
          }
        });
        
        return inst.reflectee;
      });
    }
  }
}
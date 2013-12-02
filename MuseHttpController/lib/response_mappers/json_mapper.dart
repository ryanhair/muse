part of muse.controller.http.response_mapper;

class JsonResponseMapper extends ResponseMapper {
  static JsonEncoder jsonEncoder = new JsonEncoder();
  
  void handleResponse(dynamic data, HttpResponse response) {
    if(data is Future) {
      data.then((d) {
        response.write(jsonEncoder.convert(Model.toPrimitive(d)));
        response.close();
      });
    }
    else if(data is Stream) {
      response.write('[');
      var isFirst = true;
      data.listen((dynamic item) {
        if(!isFirst) {
          response.write(',');
        }
        isFirst = false;
        _writeEntity(item, response);
      }).onDone(() {
        response.write(']');
        response.close();
      });
    }
    else {
      _writeEntity(data, response);
      response.close();
    }
  }
  
  void _writeEntity(dynamic entity, HttpResponse response) {
    response.write(jsonEncoder.convert(Model.toPrimitive(entity)));
  }
}
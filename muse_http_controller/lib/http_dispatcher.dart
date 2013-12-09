part of muse.controller.http;

/**
 * Dispatcher is responsible for mapping a request
 * to an appropriate handler (method)
 */
class HttpRequestDispatcher {
  static JsonEncoder jsonEncoder = new JsonEncoder();
  static Map<Type, dynamic> _controllers = {};
  
  static init(controllers) {
    _controllers = controllers;
  }
  
  HttpRequest request;
  
  /**
   * 1. Find appropriate handler
   * 2. Execute handler, passing request
   * 3. Take return value from handler,
   *    and send back as result of request.
   */
  
  HttpRequestDispatcher(HttpRequest this.request) {
    
    var controller = findController();
    if(controller == null) {
      handleException(new HttpResponseNotFoundException());
    }
    else {
      runController(controller).then((result) {
        new JsonResponseMapper().handleResponse(result, this.request.response);
      }).catchError((HttpResponseException err) {
        // An exception occurred, report to the user
        handleException(err);
      }, test: (e) => e is HttpResponseException);
    }
  }
  
  void handleException(HttpResponseException err) {
    request.response.statusCode = err.errorCode;
    request.response.reasonPhrase = err.message;
    request.response.close();
  }
  
  /**
   * Goes through each controller and looks for one that can handle the
   * request.
   */
  dynamic findController() {
    return _controllers.values.firstWhere((controller) {
      var cls = reflect(controller).type;
      InstanceMirror im = cls.metadata.firstWhere(
          (m) => m.reflectee is RequestMapping && m.reflectee.matches(request),
        orElse: () => null);
      return im != null;
    }, orElse: () => null);
  }
  
  Future<dynamic> runController(dynamic controller) {
    var inst = reflect(controller),
        cls = inst.type;
    
    InstanceMirror im = cls.metadata.firstWhere((m) {
      return m.reflectee is RequestMapping;
    });
    
    return im.reflectee.findHandler(controller, request).then((HandlerDescriptor descriptor) {
      if(descriptor == null) {
        throw new HttpResponseNotFoundException();
      }
      return inst.invoke(descriptor.methodName, descriptor.positional, descriptor.named).reflectee;
    });
  }
}
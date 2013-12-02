part of muse.controller.http;

class HttpMethod {
  final String type;
  final String path;
  const HttpMethod(this.type, [this.path='/']);
  
  /**
   * Given the base url (declared on the controller class using @RequestMapping),
   * and the uri (the HttpRequest uri)
   * Return a map of the data from the path (uri template)
   * For example, if "baseUrl" was "/api", path was "/cars/:car/tires", and
   * the uri was "https://www.testsite.com/api/cars/3/tires", parseUrl
   * would produce { "car": "3" }
   */
  parseUrl(String baseUrl, Uri uri) {
    List<String> templatePieces = (RequestMapping._trimSlashes(baseUrl) + '/' + RequestMapping._trimSlashes(path)).split('/');
    List<String> urlPieces = uri.pathSegments;
    Map data = new Map();
    templatePieces
      .where((String piece) => piece.startsWith(':'))
      .forEach((String piece) {
        int idx = templatePieces.indexOf(piece);
        String name = piece.substring(1);
        String value = '';
        if(urlPieces.length > idx) {
          value = urlPieces[idx];
        }
        
        data[name] = value;
      }
    );
    return data;
  }
}

class Get extends HttpMethod {
  final String path;
  const Get([this.path='/']) : super('GET');
}

class Post extends HttpMethod {
  final String path;
  const Post([this.path='/']) : super('POST');
}

class Put extends HttpMethod {
  final String path;
  const Put([this.path='/']) : super('PUT');
}

class Delete extends HttpMethod {
  final String path;
  const Delete([this.path='/']) : super('DELETE');
}
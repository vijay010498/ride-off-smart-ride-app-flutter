enum HttpMethod { GET, POST, PUT, PATCH, DELETE }

class HttpMethodUtils {
  static String enumToString(HttpMethod method) {
    switch (method) {
      case HttpMethod.GET:
        return 'GET';
      case HttpMethod.POST:
        return 'POST';
      case HttpMethod.PUT:
        return 'PUT';
      case HttpMethod.PATCH:
        return 'PATCH';
      case HttpMethod.DELETE:
        return 'DELETE';
      default:
        throw Exception('Invalid HttpMethod');
    }
  }
}
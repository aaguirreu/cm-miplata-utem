import '../models/jwt_vo.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Este es un cliente ReST que permite interactuar con el [Api del curso](https://api.sebastian.cl/Auth/swagger-ui/index.html)
class RestService {
  /// El [tipo Media](https://en.wikipedia.org/wiki/Media_type) utilizado para interactuar con el API.
  static const String _mime = 'application/json';

  /// URL BASE para conectarse al servicio REST.
  static const String _baseUrl = 'https://api.sebastian.cl/Auth';

  /// Este es el mapa con las cabeceras comunes y usadas transversalmente por el cliente ReST.
  static const Map<String, String> _headers = {
    'accept': _mime,
    'X-API-TOKEN': 'sebastian.cl',
    'X-API-KEY': 'aaa-bbb-ccc-ddd'
  };

  /// El mecanismo que se encarga de loguear en la aplicación.
  static final Logger _logger = Logger();

  /// El cliente http Dio que nos permite interactuar con el servicio ReST.
  static final Dio _client = Dio();

  /// Marca el acceso utilizando un token de identificación.
  ///
  /// Envía una solicitud POST a la url de acceso con el token de identificación.
  /// Si la respuesta es exitosa (es un código 2xx), quiere decir que el acceso se registró correctamente.
  /// Si la respuesta es incorrecta (cualquier cosa que no sea un 2xx), se marca como error.
  /// En caso de cualquier error, el evento es capturado, de tal forma de loguear el error y continuar con la aplicación.
  ///
  /// El parámetro [idToken] representa el token de identificación con el que se autenticó el usuario contra Firebase.
  static Future<void> access(String idToken) async {
    try {
      _logger.d('Marcando acceso de: $idToken');
      JwtVo vo = JwtVo();
      vo.jwt = idToken;
      const String url = '$_baseUrl/v1/access/login';
      _client.interceptors.add(LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true));
      Response<String> response = await _client.post(url,
          data: vo.toJson(), options: Options(headers: _headers));
      final int status = response.statusCode ?? 400;
      final String jsonResponse = response.data ?? '';
      if (status >= 200 && status < 300) {
        _logger.i('Respuesta correcta con código $status');
      } else {
        _logger.e('Respuesta incorrecta con código $status');
        _logger.e(jsonResponse);
      }
    } catch (error, stackTrace) {
      _logger.e(error.toString());
      _logger.d(stackTrace.toString());
    }
  }
}

/// Clase que representa un Json Web Token encapsulado en un objeto de valor (Value Object - VO)
class JwtVo {
  /// Representa el [Json Web Token](https://jwt.io/introduction)
  String jwt = "";

  /// Convierte un instancia de [JwtVo] a un [Map] Json
  ///
  /// Retorna un [Map] con el JWT en formato JSON
  Map<String, dynamic> toJson() => {"jwt": jwt};
}

class Usuario {
  final String documento;
  final String primerNombre;
  final String primerApellido;
  final String correo;
  final int idRol;

  Usuario({
    required this.documento,
    required this.primerNombre,
    required this.primerApellido,
    required this.correo,
    required this.idRol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      documento: json['documento'].toString(),
      primerNombre: json['primer_nombre'] as String? ?? '',
      primerApellido: json['primer_apellido'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      idRol: int.tryParse(json['id_rol'].toString()) ?? 0,
    );
  }

  bool get esBodeguero => idRol == 2;
  bool get esAdministrador => idRol == 1;
}
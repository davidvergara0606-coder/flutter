class Producto {
  final int idProducto;
  final String nombre;
  final String? codigo;
  final int stockActual;
  final int stockMinimo;
  final int idCategoria;
  final String? categoria;

  Producto({
    required this.idProducto,
    required this.nombre,
    this.codigo,
    required this.stockActual,
    required this.stockMinimo,
    required this.idCategoria,
    this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'] as int,
      nombre: json['nombre'] as String? ?? '',
      codigo: json['codigo'] as String?,
      stockActual: json['stock_actual'] as int? ?? 0,
      stockMinimo: json['stock_minimo'] as int? ?? 0,
      idCategoria: json['id_categoria'] as int? ?? 0,
      categoria: json['categoria'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'stock_actual': stockActual,
      'stock_minimo': stockMinimo,
      'id_categoria': idCategoria,
    };
  }

  /// true si el stock actual ya llegó al mínimo o está por debajo.
  bool get enAlerta => stockActual <= stockMinimo;
}
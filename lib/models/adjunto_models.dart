class Adjunto {
  Adjunto({
    this.ajdId,
    this.adjIdEmpresa,
    this.adjIdUsuario,
    this.adjIdRuta,
    this.adjNombre,
    this.ajdExtension,
  });

  final int? ajdId;
  final int? adjIdEmpresa;
  final int? adjIdUsuario;
  final String? adjIdRuta;
  final String? adjNombre;
  final String? ajdExtension;
  bool downloaded = false;

  factory Adjunto.fromMap(Map<String, dynamic> json) => Adjunto(
        ajdId: json["AjdId"] == null ? null : json["AjdId"],
        adjIdEmpresa:
            json["AdjIdEmpresa"] == null ? null : json["AdjIdEmpresa"],
        adjIdUsuario:
            json["AdjIdUsuario"] == null ? null : json["AdjIdUsuario"],
        adjIdRuta: json["AdjIdRuta"] == null ? null : json["AdjIdRuta"],
        adjNombre: json["AdjNombre"] == null ? null : json["AdjNombre"],
        ajdExtension:
            json["AjdExtension"] == null ? null : json["AjdExtension"],
      );

  Map<String, dynamic> toMap() => {
        "AjdId": ajdId == null ? null : ajdId,
        "AdjIdEmpresa": adjIdEmpresa == null ? null : adjIdEmpresa,
        "AdjIdUsuario": adjIdUsuario == null ? null : adjIdUsuario,
        "AdjIdRuta": adjIdRuta == null ? null : adjIdRuta,
        "AdjNombre": adjNombre == null ? null : adjNombre,
        "AjdExtension": ajdExtension == null ? null : ajdExtension,
      };
}

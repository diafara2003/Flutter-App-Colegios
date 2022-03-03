import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/providers/Models/destinatarios_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RenderGruposPages extends StatefulWidget {
  DestinatarioModel acudiente = DestinatarioModel.empty();
  bool allChecked = false;
  Function(bool ischecked) updateChecked;
  int idGrupo = 0;

  RenderGruposPages(
      {Key? key,
      required this.acudiente,
      required this.allChecked,
      required this.idGrupo,
      required this.updateChecked})
      : super(key: key);

  @override
  _RenderGruposPagesState createState() => _RenderGruposPagesState();
}

class _RenderGruposPagesState extends State<RenderGruposPages> {
  bool _checked = false;
  String nombre = "";
  String apellido = "";

  @override
  void initState() {
    super.initState();
    nombre = this.widget.acudiente.perNombres;
    apellido = this.widget.acudiente.perApellidos;

    _checked = this.widget.allChecked;
  }

  bool validarChecked() {
    bool _result = false;

    DestinatariosProvider obj =
        Provider.of<DestinatariosProvider>(context, listen: false);

    if (obj.sentTo.length > 0) {
      if (obj.sentTo
              .where((element) =>
                  element.idGrupo == this.widget.acudiente.idGrupo &&
                  element.perId == this.widget.acudiente.perId)
              .length >
          0) _result = true;
    }

    if (this.widget.allChecked && !_result) _result = true;

    return _result;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        contentPadding: EdgeInsets.all(0.0),
        value: validarChecked(),
        activeColor: Utilities.hexToColor(this.widget.acudiente.grEnColorRgb),
        onChanged: (bool? value) {
          if (this.widget.allChecked) return;

          _checked = value!;

          DestinatariosProvider obj =
              Provider.of<DestinatariosProvider>(context, listen: false);

          if (value)
            obj.sentTo.add(this.widget.acudiente);
          else
            obj.sentTo.removeWhere((element) =>
                element.perId == this.widget.acudiente.perId &&
                element.idGrupo == this.widget.acudiente.idGrupo);

          this.widget.updateChecked(_checked);
          setState(() {});
        },
        controlAffinity: ListTileControlAffinity.leading,
        title: textoBurbuja());
  }

  Row textoBurbuja() {
    return Row(children: [
      Container(
        alignment: Alignment.topLeft,
        child: CircleAvatar(
          backgroundColor:
              Utilities.hexToColor(this.widget.acudiente.grEnColorRgb),
          //  backgroundColor: Colors.transparent,
          radius: 20.0,
          child: Text(
            Utilities.inicialesUsuario(nombre, apellido),
            style: TextStyle(color: Colors.white70, fontSize: 18.0),
          ),
        ),
      ),
      Container(
          padding: EdgeInsets.only(left: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$nombre $apellido',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Utilities.hexToColor(
                          this.widget.acudiente.grEnColorRgb))),
              Text(
                this.widget.acudiente.tipo == -25
                    ? "${this.widget.acudiente.graDescripcion} - (${this.widget.acudiente.curDescripcion})"
                    : "(${this.widget.acudiente.curDescripcion})",
                style: TextStyle(color: Colors.black54, fontSize: 13.0),
              )
            ],
          )),
    ]);
  }
}

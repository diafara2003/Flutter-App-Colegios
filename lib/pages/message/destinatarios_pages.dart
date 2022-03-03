import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/acudientes_models.dart';
import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/providers/Models/destinatarios_provider.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';
import 'package:autraliano/services/message/messaje_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'render_grupo_pages.dart';

// ignore: must_be_immutable
class DestinatariosPages extends StatefulWidget {
  DestinatarioModel model = DestinatarioModel.empty();
  bool expanded;

  DestinatariosPages({Key? key, required this.model, required this.expanded})
      : super(key: key);

  @override
  _DestinatariosPagesState createState() => _DestinatariosPagesState();
}

class _DestinatariosPagesState extends State<DestinatariosPages> {
  String _apellido = "";
  String _nombre = "";
  bool _checked = false;
  Usuario _user = Usuario.empty();

  List<AcudientesModel> lstAcudientes = [];
  List<DestinatarioModel> api = [];

  @override
  void initState() {
    super.initState();

    PreferenciasUsuario _session = new PreferenciasUsuario();

    _user = Usuario.fromJson(_session.usuario);
    _apellido = this.widget.model.perNombres == ''
        ? ''
        : this.widget.model.perApellidos;
    _nombre = this.widget.model.perNombres == ''
        ? this.widget.model.perApellidos
        : this.widget.model.perNombres;

    DestinatariosProvider obj =
        Provider.of<DestinatariosProvider>(context, listen: false);

    if (obj.sentTo.length > 0) {
      if (obj.sentTo
              .where((element) =>
                  element.perId == this.widget.model.perId &&
                  element.curDescripcion == this.widget.model.curDescripcion &&
                  element.idGrupo == this.widget.model.idGrupo)
              .length >
          0) {
        this._checked = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.expanded) {
      return ExpansionTile(
          onExpansionChanged: (open) {
            cargarDetalleGrupos(open);
          },
          children: _renderizarGrupos(),
          title: _renderizarDetalle(
              this.widget.model.grEnColorRgb, _nombre, _apellido, _checked));
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 0, bottom: 0),
        child: _renderizarDetalle(
            this.widget.model.grEnColorRgb, _nombre, _apellido, _checked),
      );
    }
  }

  Widget _renderizarDetalle(
      String color, String nombre, String apellido, bool checked) {
    return CheckboxListTile(
        contentPadding: EdgeInsets.all(0.0),
        value: _checked,
        activeColor: Utilities.hexToColor(color),
        onChanged: (bool? value) {
          _checked = value!;
          DestinatariosProvider obj =
              Provider.of<DestinatariosProvider>(context, listen: false);
          this.widget.model.idGrupo = this.widget.model.perId;
          if (value)
            obj.sentTo.add(this.widget.model);
          else
            obj.sentTo.removeWhere((element) =>
                element.idGrupo == this.widget.model.idGrupo &&
                element.curDescripcion == this.widget.model.curDescripcion);

          obj.notifyUpdate();
          setState(() {});
        },
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: Utilities.hexToColor(color),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$nombre $apellido',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Utilities.hexToColor(color))),
                    if (_user.perTipoPerfil == 3)
                      Text('${this.widget.model.curDescripcion}',
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Utilities.hexToColor('#6c757d')))
                  ],
                )),
          ],
        ));
  }

  void fnUpdateChecked(bool ischecked, DestinatarioModel model) {
    DestinatariosProvider obj =
        Provider.of<DestinatariosProvider>(context, listen: false);
    this._checked = false;
    if (ischecked) {
      List<DestinatarioModel> _id = obj.sentTo
          .where((e) => e.idGrupo == this.widget.model.perId)
          .toList();

      if (_id.length == this.api.length) {
        obj.sentTo.removeWhere(
            (element) => element.idGrupo == this.widget.model.perId);

        obj.sentTo.add(this.widget.model);
        this._checked = true;
      }
    } else {
      obj.sentTo
          .removeWhere((element) => element.perId == this.widget.model.perId);
    }
    obj.notifyUpdate();
    setState(() {});
  }

  List<Widget> _renderizarGrupos() {
    List<Widget> _obj = [];

    if (api.length == 0)
      _obj.add(CircularProgressIndicator());
    else {
      api.forEach((element) {
        _obj.add(Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: RenderGruposPages(
            acudiente: element,
            allChecked: this._checked,
            idGrupo: this.widget.model.perId,
            updateChecked: (bool ischecked) {
              fnUpdateChecked(ischecked, element);
            },
          ),
        ));
      });
    }
    return _obj;
  }

  void cargarDetalleGrupos(bool open) {
    if (open) {
      api = [];
      if (this.widget.model.tipo == -30) {
        setState(() {
          api = Provider.of<DestinatariosProvider>(context, listen: false)
              .destinatarios
              .where((element) => element.tipo == this.widget.model.tipo)
              .toList();

          api.forEach((element) {
            element.idGrupo = this.widget.model.perId;
          });
        });
      }

      if (this.widget.model.tipo == -20) {
        new MessageServices()
            .getInfoGrupo(this.widget.model.perId)
            .then((value) => value.forEach((item) {
                  if (item.color.isEmpty) item.color = "#fffff";

                  DestinatarioModel _destinatario1 = new DestinatarioModel(
                      perId: item.perIdA1,
                      perNombres: item.perNombresA1,
                      perApellidos: item.perApellidosA1,
                      graDescripcion: "${item.estNombres} ${item.estApellidos}",
                      curDescripcion: item.tipoA1,
                      tipo: -25,
                      grEnColorRgb: item.color,
                      grEnColorObs: item.color,
                      grEnColorBurbuja: item.color,
                      idEst: item.estId);

                  _destinatario1.idGrupo = this.widget.model.perId;
                  api.add(_destinatario1);

                  if (item.perIdA2! > 0) {
                    DestinatarioModel _destinatario2 = new DestinatarioModel(
                        perId: item.perIdA2!,
                        perNombres: item.perNombresA2!,
                        perApellidos: item.perApellidosA2!,
                        graDescripcion:
                            "${item.estNombres} ${item.estApellidos}",
                        curDescripcion: item.tipoA2!,
                        tipo: -25,
                        grEnColorRgb: item.color,
                        grEnColorObs: item.color,
                        grEnColorBurbuja: item.color,
                        idEst: item.estId);

                    _destinatario2.idGrupo = this.widget.model.perId;
                    api.add(_destinatario2);
                  }

                  setState(() {});
                }));
      }
    }
  }
}

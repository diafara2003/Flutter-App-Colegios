import 'package:autraliano/models/destinatarios_model.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/pages/common/banner_color.dart';
import 'package:autraliano/providers/Models/destinatarios_provider.dart';
import 'package:autraliano/providers/Session/preferencias_provider.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'destinatarios_pages.dart';

class SentToPages extends StatefulWidget {
  SentToPages({Key? key}) : super(key: key);

  @override
  _SentToPagesState createState() => _SentToPagesState();
}

class _SentToPagesState extends State<SentToPages> {
  Usuario currentUser = new Usuario();
  PreferenciasUsuario _prefe = new PreferenciasUsuario();
  final ScrollController _scrollController = ScrollController();

  Future<void> getDestinatarios() async {
    final _prov = Provider.of<DestinatariosProvider>(context, listen: false);
    _prov.getDestinatarios(currentUser.perId!);
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> _user = _prefe.usuario;

    currentUser = Usuario.fromJson(_user);
  }

  @override
  Widget build(BuildContext context) {
    getDestinatarios();
    return Scaffold(
        appBar: NewGradientAppBar(
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Aceptar',
              ),
              style: TextButton.styleFrom(
                  primary: Colors.white, textStyle: TextStyle(fontSize: 16.0)),
            ),
          ],
          automaticallyImplyLeading: false,
          gradient: LinearGradient(colors: bannerColor()),
          title: Text(
            'Destinatarios',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        body: Consumer<DestinatariosProvider>(builder: (_, prov, __) {
          if (!prov.isCompletedfecth)
            return loading();
          else {
            List<DestinatarioModel> objLst = [];

            if (currentUser.perTipoPerfil == 0) {
              objLst.add(prov.destinatarios
                  .firstWhere((element) => element.tipo == -40));
              DestinatarioModel _destinatario = new DestinatarioModel(
                  perId: -30,
                  tipo: -30,
                  grEnColorRgb: '#43AC34',
                  grEnColorObs: 'Planta educativa',
                  perNombres: 'Planta educativa',
                  perApellidos: '',
                  curDescripcion: '',
                  grEnColorBurbuja: '',
                  graDescripcion: '',
                  idEst: 0);

              _destinatario.idGrupo = -30;
              objLst.add(_destinatario);
            }

            if (currentUser.perTipoPerfil == 3)
              objLst = prov.destinatarios;
            else
              prov.destinatarios
                  .where((element) => element.tipo == -20)
                  .forEach((element) {
                objLst.add(element);
              });

            return Container(
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return new DestinatariosPages(
                      model: objLst[index],
                      expanded:
                          objLst[index].tipo == -30 || objLst[index].tipo == -20
                              ? true
                              : false,
                    );
                  },
                  itemCount: objLst.length,
                ));
          }
        }));
  }

  Widget loading() {
    return Container(
        padding: const EdgeInsets.only(
          top: 8.0,
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          enabled: true,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (_, __) => Column(
              children: [
                ListTile(
                  minVerticalPadding: 2.0,
                  title: Container(
                    padding: EdgeInsets.only(
                      left: 0,
                    ),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 8.0,
                            color: Colors.white,
                          ),
                        ],
                      )),
                    ]),
                  ),
                  leading: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
                Divider()
              ],
            ),
            itemCount: 20,
          ),
        ));
  }
}

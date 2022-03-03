import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/search_to_models.dart';
import 'package:autraliano/services/person/person_services.dart';
import 'package:flutter/material.dart';

class ToMessagesDelegate extends SearchDelegate<DestinatariosModel?> {
  late final List<DestinatariosModel> _toRender;

  ToMessagesDelegate(List<DestinatariosModel> to) {
    this._toRender = to;
  }

  @override
  String get searchFieldLabel => "Buscar";

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              this.query = "";
            })
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        this.close(context, null);
      });

  @override
  Widget buildResults(BuildContext context) {
    return _getTo();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _getTo();
  }

  FutureBuilder<List<SearchTo>> _getTo() {
    final toServices = new PersonServices();

    return FutureBuilder(
      future: toServices.getTo(query),
      builder: (_, AsyncSnapshot<List<SearchTo>> snapshot) {
        if (snapshot.hasData) {
          List<SearchTo> _data = [];

          snapshot.data!.forEach((element) {
            if (this
                    ._toRender
                    .where((_to) => _to.perId == element.perId)
                    .length ==
                0) {
              _data.add(element);
            }
          });

          return (_data.length == 0 ? resultEmpty(_) : _showResult(_data));
        } else {
          return Center(
              child: CircularProgressIndicator(
            strokeWidth: 4,
          ));
        }
      },
    );
  }

  Widget resultEmpty(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Card(
          elevation: 3.0,
          child: Container(
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail, color: Theme.of(context).primaryColor),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'No tienes destinatarios para enviar',
                  style: TextStyle(
                      fontSize: 17.0, color: Theme.of(context).primaryColor),
                ),
              ],
            )),
            width: MediaQuery.of(context).size.width,
            height: 100,
          )),
    );
  }

  Widget _showResult(List<SearchTo> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) {
        final _result = data[i];

        _result.selected = false;

        return ListTile(
          trailing: _result.selected
              ? Icon(
                  Icons.check_circle,
                  color: Colors.blue[400],
                )
              : null,
          onTap: () {
            this.close(
                _,
                new DestinatariosModel(
                    perId: _result.perId,
                    tipo: _result.tipo,
                    apellido: _result.perApellidos,
                    nombre: _result.perNombres));
          },
          leading: CircleAvatar(
            backgroundColor: Utilities.hexToColor(_result.grEnColorBurbuja),
            radius: 25.0,
            child: Text(
              Utilities.inicialesUsuario(
                  _result.perNombres, _result.perApellidos),
              style: TextStyle(color: Colors.white),
            ),
          ),
          subtitle: Text(_result.curDescripcion),
          title: Text("${_result.perApellidos} ${_result.perNombres}"),
        );
      },
    );
  }
}

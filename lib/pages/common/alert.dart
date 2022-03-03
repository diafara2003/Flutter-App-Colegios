import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> dialogCustom(
    {required BuildContext context,
    required String header,
    required String msn,
    Function? ok}) async {
  // show the dialog

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoAlertDialog(
          title: Text(header),
          content: Container(
              padding: EdgeInsets.only(top: 15.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // CircularProgressIndicator(),
                    Container(
                        padding: EdgeInsets.only(left: 5.0), child: Text(msn)),
                  ],
                ),
              )),
          actions: ok == null
              ? []
              : [
                  new TextButton(
                      child: new Text("Aceptar"),
                      onPressed: () {
                        ok();
                      })
                ],
        ),
      );
    },
  );
}

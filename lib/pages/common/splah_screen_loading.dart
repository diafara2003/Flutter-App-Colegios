import 'package:flutter/material.dart';

Widget splashScreenLoading() {
  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Container(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'images/login.png',
                      fit: BoxFit.fill,
                      width: 360,
                    ),
                  ),
                  // Image.network(
                  //   'https://www.comunicatecolegios.com/Img/logo.png',
                  //   width: 120,
                  // )),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  // Text(
                  //   "Comunicate colegios",
                  //   style:
                  //       TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  // )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                // Text(
                //   "Cargando",
                //   softWrap: true,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 18.0,
                //   ),
                // )
              ],
            ),
          )
        ],
      )
    ],
  );
}

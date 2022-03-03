import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MessageUtilidades {
  Widget loading(BuildContext context) {
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

import 'package:flutter/material.dart';

class UpdateAppPages extends StatelessWidget {
  static final String routeName = "updateapp";
  const UpdateAppPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NewVersion nVersion = NewVersion(
    //   iOSId: 'com.app.comuninicateflutter',
    //   androidId: 'com.app.comuninicateflutter',
    // );

    // nVersion.showUpdateDialog(
    //     context: context,
    //     versionStatus:
    //         (ModalRoute.of(context)!.settings.arguments as VersionStatus),
    //     dialogTitle: 'Actualización disponible',
    //     dialogText: 'Existe una nueva versión disponible',
    //     updateButtonText: 'Actualizar',
    //     allowDismissal: false);
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(),
      ),
    );
  }
}

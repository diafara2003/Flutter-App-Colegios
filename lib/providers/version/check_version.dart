import 'package:new_version/new_version.dart';

class CheckVersionApp {
  final newVersion = NewVersion(
    iOSId: 'com.example.autraliano',
    androidId: 'com.example.autraliano',
  );
  Future<VersionStatus> statusCheck() async {
    final status = await newVersion.getVersionStatus();

    return status!;

    // newVersion.showUpdateDialog(
    //     context: _,
    //     versionStatus: status,
    //     dialogTitle: 'Actualización disponible',
    //     dialogText: 'Existe una nueva versión disponible',
    //     updateButtonText: 'Actualizar',
    //     allowDismissal: false);
  }
}

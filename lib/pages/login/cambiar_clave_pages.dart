import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/pages/common/alert.dart';
import 'package:autraliano/pages/common/banner_color.dart';
import 'package:autraliano/pages/menu/menu_pages.dart';
import 'package:autraliano/pages/message/home_message_pages.dart';
import 'package:autraliano/services/auth/login_services.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:passwordfield/passwordfield.dart';

class CambiarClavePages extends StatefulWidget {
  static final String routeName = "cambiarClave";
  CambiarClavePages({Key? key}) : super(key: key);

  @override
  State<CambiarClavePages> createState() => _CambiarClavePagesState();
}

class _CambiarClavePagesState extends State<CambiarClavePages> {
  // Initially password is obscureç
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController passwordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  void cambiarClave() async {
    if (!formkey.currentState!.validate()) return;
    if (passwordController.text.length < 6) return;

    if (passwordController.text != '' && newPasswordController.text != '') {
      if (passwordController.text == newPasswordController.text) {
        setState(() {
          isLoading = true;
        });

        await new LoginProvider().cambiarClave(newPasswordController.text);
        dialogCustom(
            context: context,
            header: "Cambio de contraseña",
            msn: "Se cambio la contraseña correctamente.",
            ok: () {
              Navigator.pushReplacementNamed(
                  context, HomeMessagesPages.routeName);
            });
        setState(() {
          isLoading = false;
        });
      } else {
        dialogCustom(
            context: context,
            header: "Cambio de contraseña",
            msn: "Las contraseñas no coinciden.",
            ok: () {
              Navigator.pop(context);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(colors: bannerColor()),
        title: Text(
          'Cambiar contraseña',
          style: TextStyle(color: Colors.black54),
        ),
      ),
      drawer: MenuPages(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text('Cambiar Contraseña',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0)),
                ),
                Divider(),
                SizedBox(
                  height: 20.0,
                ),
                textPassword("Nueva contraseña", passwordController),
                textPassword("Repetir contraseña", newPasswordController),
                _loginBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.bottomRight,
                begin: Alignment.topLeft,
                colors: [
                  Utilities.hexToColor('#6CCEF4'),
                  Utilities.hexToColor('#00AFF0')
                ]),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Color(0xff008FFF)),
        child: Container(
          // margin: EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      cambiarClave();
                    }
                  },
                  child: Text(
                    'Cambiar contraseña',
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
              SizedBox(
                width: 5,
              ),
              if (isLoading)
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue.shade100),
                    backgroundColor: Colors.blue,
                    strokeWidth: 3,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget textPassword(
      String placeholder, TextEditingController inputController) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: PasswordField(
        maxLength: 20,
        controller: inputController,
        color: Colors.blue,
        passwordConstraint: r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,}$',
        inputDecoration: PasswordDecoration(),
        hintText: placeholder,
        border: PasswordBorder(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue.shade100,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 2, color: Colors.red.shade200),
          ),
        ),
        errorMessage: 'Es requerido almenos 5 caracteres.',
      ),
    );
  }
}

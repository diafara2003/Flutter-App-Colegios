import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/pages/common/splah_screen_loading.dart';
import 'package:autraliano/pages/message/home_message_pages.dart';
import 'package:autraliano/services/auth/login_services.dart';
import 'package:autraliano/services/push/push_notificacions_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPages extends StatefulWidget {
  static final String routeName = "signIn";
  SignInPages({Key? key}) : super(key: key);

  @override
  _SignInPagesState createState() => _SignInPagesState();
}

class _SignInPagesState extends State<SignInPages> {
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool error = false;

  LoginProvider authMethod = new LoginProvider();

  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Container(
                child: splashScreenLoading(),
              )
            : SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  // decoration: BoxDecoration(
                  //     gradient: LinearGradient(colors: [
                  //   Colors.blue.shade300,
                  //   Colors.green.shade200
                  // ])),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Form(
                        key: formkey,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 50.0),
                          color: Colors.white30,
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _logo(),
                              SizedBox(
                                height: 50.0,
                              ),
                              _logoText(),
                              _inputFlied(
                                  Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    color: Color(0xffA6B0BD),
                                  ),
                                  "Usuario",
                                  false,
                                  emailcontroller),
                              _inputFlied(
                                  Icon(
                                    Icons.lock_outline,
                                    size: 30,
                                    color: Color(0xffA6B0BD),
                                  ),
                                  "Contraseña",
                                  true,
                                  passwordcontroller),
                              _loginBtn()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }

  void showAlertDialog(BuildContext context, String header, String msn) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(header), Divider()],
      )),
      content: Text(msn),
      actions: [
        TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: alert,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        );
      },
    );
  }

  sigmMe(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Usuario? _user = await authMethod.validationUser(
          emailcontroller.text, passwordcontroller.text);

      if (_user != null) {
        await new LoginProvider().registarToken(PushNotificacionService.token);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeMessagesPages()));
      } else {
        showAlertDialog(context, "Inicio de sesion", "Usuario no encontrado");
        setState(() {
          isLoading = false;
          error = true;
        });
      }
    }
  }

  Widget _logoText() {
    return Container();
  }

  Widget _logo() {
    return Container(
        margin: EdgeInsets.only(top: 50),
        child: Image.asset(
          'images/login.png',
          width: 380,
          fit: BoxFit.cover,
        ));
  }

  Widget _inputFlied(Icon iconPrefix, String hintText, bool isPassword,
      TextEditingController controller) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.95,

      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                blurRadius: 30,
                offset: Offset(0, 5),
                spreadRadius: -25)
          ]),
      margin: EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            prefixIcon: iconPrefix,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            prefixIconConstraints: BoxConstraints(minWidth: 75)),
      ),
    );
  }

  Widget _loginBtn() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.bottomRight,
              begin: Alignment.topLeft,
              colors: [
                Utilities.hexToColor('#6CCEF4'),
                Utilities.hexToColor('#00AFF0')
              ]),
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 5),
                spreadRadius: 0,
                color: Color(0x60008FFF))
          ],
          color: Color(0xff008FFF)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: TextButton(
            onPressed: () {
              sigmMe(context);
            },
            child: Text(
              'Ingresar',
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      fontSize: 18,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            )),
      ),
    );
  }
}

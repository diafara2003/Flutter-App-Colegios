import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/person.dart';
import 'package:autraliano/models/response_models.dart';
import 'package:autraliano/pages/common/splah_screen_loading.dart';
import 'package:autraliano/pages/message/home_message_pages.dart';
import 'package:autraliano/services/auth/login_services.dart';
import 'package:autraliano/services/push/push_notificacions_services.dart';
import 'package:flutter/material.dart';

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
  bool isRecordarClave = false;

  LoginProvider authMethod = new LoginProvider();

  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController forgorPassword = new TextEditingController();

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
                                isRecordarClave
                                    ? formRecoredarClave()
                                    : formIniciarSesion()
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ));
  }

  Widget formRecoredarClave() {
    return Column(
      children: [
        _inputFlied(
            Icon(
              Icons.person_outline,
              size: 30,
              color: Color(0xffA6B0BD),
            ),
            "Usuario",
            false,
            forgorPassword),
        _loginBtn("Enviar contraseña", () async {
          if (forgorPassword.text != '') {
            ResponseDto response =
                await authMethod.enviarClaveCorreo(forgorPassword.text);

            if (response.codigo > 0)
              showAlertDialog(context, "Recordar contraseña",
                  "Se envió la contraseña correctamente");
            else
              showAlertDialog(
                  context, "Recordar contraseña", "No se encontro el usuario");
          }
        }, false),
        _loginBtn("Regresar", () {
          setState(() {
            isRecordarClave = false;
          });
        }, true),
        SizedBox(
          height: 40,
        ),
        Text(
          'Se enviara la contraseña al correo registrado por el colegio.',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Utilities.hexToColor('#00AFF0')),
        ),
      ],
    );
  }

  Widget formIniciarSesion() {
    return Column(
      children: [
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
        _loginBtn("Ingresar", () {
          sigmMe(context);
        }, false),
        recordarClave()
      ],
    );
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

  Widget recordarClave() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRecordarClave = true;
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'recordar contraseña',
              style: TextStyle(color: Utilities.hexToColor('#00AFF0')),
            ),
          ],
        ),
      ),
    );
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

  Widget _loginBtn(String texto, Function ontap, bool isdefault) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.bottomRight,
              begin: Alignment.topLeft,
              colors: isdefault
                  ? [Colors.black12, Colors.black12]
                  : [
                      Utilities.hexToColor('#6CCEF4'),
                      Utilities.hexToColor('#00AFF0')
                    ]),
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: isdefault ? Colors.red : Color(0xff008FFF)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: TextButton(
            onPressed: () {
              ontap();
            },
            child: Text(
              texto,
              style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                  color: isdefault ? Colors.black : Colors.white),
            )),
      ),
    );
  }
}

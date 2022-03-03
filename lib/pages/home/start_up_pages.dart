import 'package:autraliano/pages/common/splah_screen_loading.dart';
import 'package:autraliano/pages/login/signin_pages.dart';
import 'package:autraliano/pages/message/home_message_pages.dart';
import 'package:autraliano/providers/Models/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartUpPages extends StatefulWidget {
  static final String routeName = "init";
  StartUpPages({Key? key}) : super(key: key);

  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<StartUpPages> {
  @override
  void initState() {
    super.initState();

    Provider.of<LoggedProvider>(context, listen: false)
        .validateSession()
        .then((value) => {
              if (value)
                Navigator.of(context).pushNamed(HomeMessagesPages.routeName)
              else
                Navigator.of(context).pushNamed(SignInPages.routeName)
            });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: splashScreenLoading(),
    );
  }
}

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.black,

            image: DecorationImage(
                image: NetworkImage(
                    'https://coloredbrain.com/wp-content/uploads/2016/07/login-background.jpg'),
                fit: BoxFit.cover)),
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 10,
                                style: BorderStyle.solid,
                                color: Colors.white)),
                        hintText: "Enter Email"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 10,
                              style: BorderStyle.solid,
                              color: Colors.white)),
                      hintText: "Enter Password",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,right: 50),
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.white),
                    ),
                    textColor: Colors.white,
                    child: Text("Login"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

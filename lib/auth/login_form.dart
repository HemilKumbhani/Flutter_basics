import 'package:flutter/material.dart';
import 'package:web_view_app/utils/utils.dart';

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginForm> {
//  final Function _changePage;

  BuildContext mContext;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _loginData = {'email': null, 'password': null};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//  _LoginState(this._changePage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://coloredbrain.com/wp-content/uploads/2016/07/login-background.jpg'),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.all(20),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
              children: <Widget>[_buildLoginWidget(_formKey, _scaffoldKey)],
            )))));
  }

  Form _buildLoginWidget(
      GlobalKey formkey, GlobalKey<ScaffoldState> scaffoldKey) {
    Widget _buildLoginField() {
      return TextFormField(
        validator: (String v) {
          if (v.isEmpty) return "Please enter email.";
        },
        style: TextStyle(color: Colors.white),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: textDecoration('Email Address'),
        onSaved: (String value) {
          _loginData['email'] = value;
        },
      );
    }

    Widget _buildPasswordField() {
      return TextFormField(
          initialValue: '',
          obscureText: true,
          validator: (String v) {
            if (v.isEmpty) {
              return "Please enter Password";
            }
          },
          style: TextStyle(color: Colors.white),
          textInputAction: TextInputAction.done,
          decoration: textDecoration('password'),
          onSaved: (String value) {
            _loginData['password'] = value;
          });
    }

    return Form(
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildLoginField(),
              SizedBox(
                height: 15,
              ),
              _buildPasswordField(),
              SizedBox(
                height: 15,
              ),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text("Create an account, Sign Up"),
                    textColor: Colors.white,
                    onPressed: () {
                      scaffoldKey.currentState
                          .showSnackBar(SnackBar(content: Text("da")));
                    },
                  )
                ],
              ),
              new FlatButton(
                onPressed: () {},
                child: Text("Sign Up"),
                textColor: Colors.white,
              )
            ],
          ),
        ));
  }
}

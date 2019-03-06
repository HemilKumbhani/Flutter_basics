import 'package:flutter/material.dart';
import 'package:web_view_app/auth/auth.dart';
import 'package:web_view_app/deatilPackage/deatilScreen.dart';
import 'package:web_view_app/model/NowPlayingMovie.dart';
import 'package:web_view_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  NowPlayingMovie movie;

  LoginForm(this.movie);

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginForm> {
//  final Function _changePage;

  bool _isVisible = true;
  BaseAuth auth = new Auth();
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
                      children: <Widget>[
                        _buildLoginWidget(_formKey, _scaffoldKey)],
                    )))));
  }

  Form _buildLoginWidget(GlobalKey formkey,
      GlobalKey<ScaffoldState> scaffoldKey) {
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

    Widget _buildSignUpButton() {
      return new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text("Don't have an account, Sign Up"),
            textColor: Colors.white,
            onPressed: () {},
          )
        ],
      );
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
              _buildSignUpButton(),
              Visibility(child: SigninButton(), visible: _isVisible),
              Visibility(
                child: new CircularProgressIndicator(),
                visible: !_isVisible,
              )
            ],
          ),
        ));
  }

  FlatButton SigninButton() {
    return new FlatButton(
      onPressed: () {
        _validateAndSubmit(_loginData['email'], _loginData['password']);
      },
      child: Text("Sign In"),
      textColor: Colors.white,
    );
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _validateAndSubmit(String email, String password) async {
    String userId = "";
    try {
      if (_validateAndSave()) {
        _isVisible = false;
        userId = await auth.signIn(email, password);

        Navigator.pop(
            context,
            new MaterialPageRoute(
                builder: (_) => new DetailScreen(widget.movie)));
        print('Signed up user: $userId');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

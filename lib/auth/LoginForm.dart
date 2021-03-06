import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Talkies/auth/Auth.dart';
import 'package:Talkies/database/DbProvider.dart';
import 'package:Talkies/database/User.dart';
import 'package:Talkies/deatilPackage/DetailScreen.dart';
import 'package:Talkies/model/MoviesModel.dart';
import 'package:Talkies/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  Result movie;
  int position;
  String movieTypeTitle;
  List<Result> movies;
  LoginForm(this.movie, this.position, this.movieTypeTitle, this.movies);

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginForm> {
//  final Function _changePage;

  bool _isVisible = true;
  bool _isSignIn = true;
  String _singInText = "Don't have an account ? Sign Up!";
  BaseAuth auth = new Auth();
  BuildContext mContext;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _loginData = {'email': null, 'password': null};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                        'http://13.232.138.90:8022/images/working-in-a-coffee-shop.jpg'),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.all(20),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
              children: <Widget>[
                showSignInText(),
                _buildLoginWidget(_formKey, _scaffoldKey)
              ],
            )))));
  }

  Widget showSignInText() {
    if (_isSignIn)
      return Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Text(
          "Sign In",
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
      );
    else {
      return Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
      );
    }
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

    Widget _buildSignUpButton() {
      return new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text(_singInText),
            textColor: Colors.white,
            onPressed: () {
              if (_isSignIn) {
                setState(() {
                  _isSignIn = false;
                  _singInText = "Already have an account ? Sign In!";
                });
              } else {
                setState(() {
                  _isSignIn = true;
                  _singInText = "Don't have an account ? Sign Up!";
                });
              }
            },
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
              _buildSigninButton(),
            ],
          ),
        ));
  }

  Widget _buildSigninButton() {
    if (_isVisible) {
      return new FlatButton(
        onPressed: () {
          setState(() {
            if (_isVisible) {
              _validateAndSubmit();
            }
          });
        },
        child: Text("Sign In"),
        textColor: Colors.white,
      );
    } else {
      return new CircularProgressIndicator();
    }
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

  void _validateAndSubmit() async {
    String userId = "";
    try {
      if (_validateAndSave()) {
        setState(() {
          _isVisible = false;
        });

        if (_isSignIn) {
          userId =
              await auth.signIn(_loginData['email'], _loginData['password']);
        } else {
          userId =
              await auth.signUp(_loginData['email'], _loginData['password']);
        }
        var dbHelper = DbProvider();
        var user =
            User(email: _loginData['email'], password: _loginData['password']);
        dbHelper.saveUser(user);

        Navigator.pushReplacement(context, new CupertinoPageRoute(builder: (_)=> new DetailScreen(widget.movie,widget. position, widget.movieTypeTitle,widget.movies)));

        print('Signed up user: $userId');
      }
    } catch (e) {
      setState(() {
        _isVisible = true;
      });
      Scaffold.of(_formKey.currentContext).showSnackBar(SnackBar(
        content: Text('Error: $e'),
        duration: Duration(seconds: 3),
      ));

      print('Error: $e');
    }
  }
}

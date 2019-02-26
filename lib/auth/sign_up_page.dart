import 'package:flutter/material.dart';
import 'package:web_view_app/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpPageWidget();
  }
}

class _SignUpPageWidget extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _signUpData = {
    'name': null,
    'email': null,
    'address': null,
    'password': null
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: NetworkImage(
                    'https://coloredbrain.com/wp-content/uploads/2016/07/login-background.jpg',
                    scale: 2),
                fit: BoxFit.fill)),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[_buildSignUpWidget()],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildSignUpWidget() {
    Widget _buildTextFields(String fieldName) {
      return TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: textDecoration(fieldName),
      );
    }

    Widget _buildAddressField() {
      return TextFormField(
          style: TextStyle(color: Colors.white),

          decoration: textDecoration("Address"));
    }

    return Form(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTextFields("Name"),
            SizedBox(
              height: 15,
            ),
            _buildTextFields("email"),
            SizedBox(
              height: 15,
            ),
            _buildTextFields("address"),
            SizedBox(
              height: 15,
            ),
            _buildTextFields("password"),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

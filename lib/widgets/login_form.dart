import 'package:flutter/material.dart';

import '../screens/signup_screen.dart';

import '../validators/user_validators.dart';

class LoginForm extends StatefulWidget {
  final void Function({String email, String password, BuildContext ctx})
      submitForm;

  bool isLoading;

  LoginForm(
    this.submitForm,
    this.isLoading,
  );

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _form = GlobalKey<FormState>();

  // form fields
  String _email = '';
  String _password = '';

  @override
  void dispose() {
    this._form.currentState.dispose();
    super.dispose();
  }

  void _submitLoginForm() {
    bool isValid = this._form.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    this._form.currentState.save();
    this.widget.submitForm(
          email: this._email,
          password: this._password,
          ctx: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this._form,
      child: Container(
        margin: EdgeInsets.only(top: 100, left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(bottom: 20),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      validator: (value) {
                        return emailValidator(value);
                      },
                      onSaved: (newValue) {
                        this._email = newValue;
                      },
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      validator: (value) {
                        return passwordValidator(value);
                      },
                      onSaved: (newValue) {
                        this._password = newValue;
                      },
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              elevation: 5,
              onPressed: this._submitLoginForm,
              child: this.widget.isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Log in',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Create an account?',
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    },
                    child: Text(
                      ' Sign up',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../validators/user_validators.dart';

class SignupForm extends StatefulWidget {
  final void Function({
    String email,
    String password,
    String userName,
    BuildContext ctx,
  }) submitForm;

  bool isLoading;

  SignupForm(this.submitForm, this.isLoading);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  var _form = GlobalKey<FormState>();

  // fields
  String _email = '';
  String _userName = '';
  String _password = '';

  // field controller
  var _passwordController = TextEditingController();

  @override
  void dispose() {
    this._passwordController.dispose();
    this._form.currentState.dispose();
    super.dispose();
  }

  void _submitSignUpForm() {
    bool isValid = this._form.currentState.validate();
    if (!isValid) {
      return;
    }
    this._form.currentState.save();
    this.widget.submitForm(
          email: this._email,
          password: this._password,
          userName: this._userName,
          ctx: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this._form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Sign up',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            key: ValueKey('email'),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor)),
            ),
            validator: (value) {
              return emailValidator(value);
            },
            onSaved: (newValue) {
              this._email = newValue;
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            key: ValueKey('username'),
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor)),
            ),
            validator: (value) {
              return userNameValidator(value);
            },
            onSaved: (newValue) {
              this._userName = newValue;
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            key: ValueKey('password'),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor)),
            ),
            validator: (value) {
              return passwordValidator(value);
            },
            onSaved: (newValue) {
              this._password = newValue;
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            key: ValueKey('passwordConfirm'),
            obscureText: true,
            controller: this._passwordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor)),
            ),
            validator: (value) {
              return passwordConfirmValidator(
                  value, this._passwordController.text);
            },
          ),
          SizedBox(
            height: 25,
          ),
          RaisedButton(
            onPressed: this._submitSignUpForm,
            elevation: 5,
            child: this.widget.isLoading
                ? CircularProgressIndicator()
                : Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
          ),
        ],
      ),
    );
  }
}

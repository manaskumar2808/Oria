String userNameValidator(String value) {
  if (value.trim().isEmpty) {
    return "Please provide a username";
  }
  if (value.length < 4) {
    return "Username must have 4 or more characters";
  }
  return null;
}

String emailValidator(String value) {
  if (value.trim().isEmpty) {
    return "please provide an email address!";
  }
  if (!value.contains('@')) {
    return "Enter a valid email address!";
  }
  return null;
}

String passwordValidator(String value) {
  if (value.trim().isEmpty) {
    return "Please provide a password";
  }
  if (value.trim().length < 7) {
    return "Your password is too short.";
  }
  return null;
}

String passwordConfirmValidator(String value, String compareValue) {
  if (value != compareValue) {
    return "Password doesn't match!";
  }
  return null;
}

String firstNameValidator(String value) {
  return null;
}

String lastNameValidator(String value) {
  return null;
}

String phoneNoValidator(String value) {
  if (value.trim().isNotEmpty && value.trim().length != 10) {
    return "Please provide a valid Phone Number!";
  }
  return null;
}

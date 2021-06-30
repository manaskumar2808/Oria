
String locationValidator(String value) {
  if (value.trim().isEmpty) {
    return "location is a must!";
  }
  if (value.trim().length > 100) {
    return "please provide a shorter location name";
  }
  return null;
}

String descriptionValidator(String value) {
  return null;
}
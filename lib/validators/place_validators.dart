String placeNameValidator(String value) {
  if (value.trim().isEmpty) {
    return "Please provide a Place Name!";
  } else if (value.trim().length > 120) {
    return "Please provide a shorter Place Name.";
  }
  return null;
}

String locationValidator(String value) {
  if (value.trim().isEmpty) {
    return "Please provide a Location!";
  }
  return null;
}

String descriptionValidator(String value) {
  if (value.trim().isEmpty) {
    return "Please provide Description for Destination!";
  }
  return null;
}

String costValidator(String value) {
  double newValue = double.parse(value);
  if (newValue < 0) {
    return "Please provide a valid Destination Cost!";
  }
  return null;
}

String elevationValidator(String value) {
  double newValue = double.parse(value);
  if (newValue < 0) {
    return "Please provide a valid Destination Elevation!";
  }
  return null;
}

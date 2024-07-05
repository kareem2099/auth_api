const String passwordError = "Enter a password";
const String passwordLengthError = "At least 8 characters";
const String lowercaseError = "Include a lowercase letter";
const String uppercaseError = "Include an uppercase letter";
const String digitError = "Include a digit";
const String specialCharError = "Include a special character";
const String confirmPasswordError = "Please confirm your password";
const String passwordMismatchError = "Passwords do not match";
const String nameError = "Enter a name";
const String nameLengthError = "At least 3 characters";
const String phoneError = "Enter a phone number";
const String phoneLengthError = "Phone number must be 10-11 characters";
const String emailError = "Enter an email";
const String emailInvalidError = "Enter a valid email";
const String addressError = "Please enter an address";
const String locNameError = "please enter your location name";

String? validateRegistrationPassword(String? value) {
  if (value == null || value.isEmpty) {
    return passwordError;
  } else if (value.length < 8) {
    return passwordLengthError;
  } else if (!RegExp(r'[a-z]').hasMatch(value)) {
    return lowercaseError;
  } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return uppercaseError;
  } else if (!RegExp(r'[0-9]').hasMatch(value)) {
    return digitError;
  } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
    return specialCharError;
  }
  return null;
}

String? validateConfirmPassword(String? value, String originalPassword) {
  if (value == null || value.isEmpty) {
    return confirmPasswordError;
  } else if (value != originalPassword) {
    return passwordMismatchError;
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return nameError;
  } else if (value.length < 3) {
    return nameLengthError;
  }
  return null;
}

String? validateLoginPassword(String? value) {
  if (value == null || value.isEmpty) {
    return passwordError;
  } else if (value.length < 8) {
    return passwordLengthError;
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return phoneError;
  } else if (value.length < 10 || value.length > 11) {
    return phoneLengthError;
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return emailError;
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return emailInvalidError;
  }
  return null;
}

String? validateLocName(String? value) {
  if (value == null || value.isEmpty) {
    return locNameError;
  }
  return null;
}

String? validateAddress(String? value) {
  if (value == null || value.isEmpty) {
    return addressError;
  }
  return null;
}

String? validateCoordinates(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter coordinates';
  }
  final coordinates = value.split(',');
  if (coordinates.length != 2 ||
      coordinates.any((coord) => double.tryParse(coord.trim()) == null)) {
    return 'Please enter valid coordinates (e.g., 30.0444, 31.2357)';
  }
  return null;
}

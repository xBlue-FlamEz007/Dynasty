class Validator {

  String nameValidator(value) {
    if (value.isEmpty ||
        !RegExp(r"^^[a-zA-Z]+").hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
  }

  String emailValidator(value) {
    if (value.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String passwordValidator(value) {
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String checkEmpty(value, text) {
    if (value.isEmpty) {
      return '$text cannot be empty';
    }
    return null;
  }
  String numberValidator(value) {
    if (value.isEmpty || !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value)) {
      return 'Invalid number';
    }
    return null;
  }
}
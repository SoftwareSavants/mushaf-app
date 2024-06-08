import 'package:flutter/material.dart';

class ValidatorsHelper {
  static FormFieldValidator<Object> get objectRequired =>
      (Object? obj) => obj == null ? 'هذه الخانة إلزامية' : null;
}

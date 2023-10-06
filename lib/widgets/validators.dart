import 'package:flutter/material.dart';

class Validators {
   /// [FormFieldValidator] that requires the field have a non-empty value.
  static FormFieldValidator<T> requiredWith<T>({
    String? errorText,
    required TextEditingController controller,
  }) {
    return (T? valueCandidate) {
      if (controller.text.trim().isEmpty) {
        return null;
      }
      if (valueCandidate == null ||
          (valueCandidate is String && valueCandidate.trim().isEmpty) ||
          (valueCandidate is Iterable && valueCandidate.isEmpty) ||
          (valueCandidate is Map && valueCandidate.isEmpty)) {
        return errorText ?? 'FormBuilderLocalizations.current.requiredErrorText';
      }
      return null;
    };
  }
}
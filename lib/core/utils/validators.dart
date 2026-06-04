/// Form validation utility methods.
///
/// Provides reusable validator functions for common input fields.
/// Returns `null` on valid input and an error message string on invalid input.
class Validators {
  Validators._();

  /// Validates that the [value] is not null or empty.
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates that the [value] is a properly formatted email address.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates that the [value] meets minimum password requirements.
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Validates that [value] matches the [confirmValue].
  static String? confirmPassword(String? value, String? confirmValue) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != confirmValue) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates that the [value] has at least [minLength] characters.
  static String? minLength(
    String? value, {
    required int minLength,
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validates that the [value] is a valid phone number.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final regex = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates that the [value] is a valid name (letters and spaces only).
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
}

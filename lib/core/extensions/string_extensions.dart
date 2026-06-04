/// Convenience extensions on [String] for common operations.
extension StringExtensions on String {
  /// Capitalizes the first character of the string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter of each word.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Returns `true` if the string is a valid email address.
  bool get isValidEmail {
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(this);
  }

  /// Returns `true` if the string is a valid phone number.
  bool get isValidPhone {
    final regex = RegExp(r'^\+?[\d\s-]{10,}$');
    return regex.hasMatch(this);
  }

  /// Returns `true` if the string is a valid URL.
  bool get isValidUrl {
    final regex = RegExp(
      r'^https?:\/\/[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );
    return regex.hasMatch(this);
  }

  /// Returns `true` if the string contains only digits.
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Truncates the string to [maxLength] and appends an [ellipsis].
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Removes all whitespace from the string.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Returns the string or `null` if it's empty.
  String? get orNull => isEmpty ? null : this;
}

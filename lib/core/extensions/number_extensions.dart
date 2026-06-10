import 'package:intl/intl.dart';

/// Convenience extensions on [double] for common number formatting.
extension NumberExtensions on double {
  /// Formats as a crypto price with appropriate decimal places.
  ///
  /// - ≥ 1000: `#,##0.00` (e.g., `50,123.45`)
  /// - ≥ 1: `#,##0.0000` (e.g., `1.2345`)
  /// - < 1: `#,##0.000000` (e.g., `0.000123`)
  String get cryptoPrice {
    if (this >= 1000) {
      return NumberFormat('#,##0.00').format(this);
    } else if (this >= 1) {
      return NumberFormat('#,##0.0000').format(this);
    } else {
      return NumberFormat('#,##0.000000').format(this);
    }
  }

  /// Formats as a crypto price prefixed with `$`.
  ///
  /// Example: `\$50,123.45`
  String get cryptoPriceWithSymbol => '\$$cryptoPrice';
}

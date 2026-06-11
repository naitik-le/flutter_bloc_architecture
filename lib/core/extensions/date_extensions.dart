import 'package:intl/intl.dart';

/// Convenience extensions on [DateTime] for common formatting.
extension DateExtensions on DateTime {
  /// Formats as `dd/MM/yyyy` (e.g., `25/12/2024`).
  String get ddMMyyyy => DateFormat('dd/MM/yyyy').format(this);

  /// Formats as `MMM dd, yyyy` (e.g., `Dec 25, 2024`).
  String get mmmDdYyyy => DateFormat('MMM dd, yyyy').format(this);

  /// Formats as `MMMM dd, yyyy` (e.g., `December 25, 2024`).
  String get fullDate => DateFormat('MMMM dd, yyyy').format(this);

  /// Formats as `hh:mm a` (e.g., `02:30 PM`).
  String get timeOnly => DateFormat('hh:mm a').format(this);

  /// Formats as `MMM dd, yyyy hh:mm a` (e.g., `Dec 25, 2024 02:30 PM`).
  String get dateTime => DateFormat('MMM dd, yyyy hh:mm a').format(this);

  /// Formats as `yyyy-MM-dd` (e.g., `2024-12-25`) — ISO 8601 date.
  String get isoDate => DateFormat('yyyy-MM-dd').format(this);

  /// Returns a human-readable relative time string (e.g., `2 hours ago`).
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Whether this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  // ── Time Formats (24-hour) ──

  /// Formats as `HH:mm:ss` (e.g., `14:30:05`) — 24-hour with seconds.
  String get time24WithSeconds => DateFormat('HH:mm:ss').format(this);

  /// Formats as `HH:mm` (e.g., `14:30`) — 24-hour, hour and minute only.
  String get time24HourMinute => DateFormat('HH:mm').format(this);

  /// Formats as `ss.SSS` (e.g., `05.123`) — seconds with milliseconds.
  String get timeSecondsMillis => DateFormat('ss.SSS').format(this);
}

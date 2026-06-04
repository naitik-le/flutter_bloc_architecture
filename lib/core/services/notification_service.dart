import 'package:flutter_bloc_architecture/core/utils/app_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service for handling local and push notifications.
///
/// Configures platform-specific notification channels and provides
/// methods for displaying and managing notifications.
class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications;

  /// Default notification channel ID.
  static const String _channelId = 'default_channel';

  /// Default notification channel name.
  static const String _channelName = 'Default Notifications';

  /// Creates a [NotificationService].
  NotificationService(this._localNotifications);

  /// Initializes the notification service with platform-specific settings.
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    AppLogger.info('NotificationService initialized');
  }

  /// Shows a local notification with the given [title] and [body].
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Cancels a notification with the given [id].
  Future<void> cancelNotification(int id) => _localNotifications.cancel(id);

  /// Cancels all notifications.
  Future<void> cancelAllNotifications() => _localNotifications.cancelAll();

  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.info(
      'Notification tapped: ${response.payload}',
    );
    // TODO: Handle notification tap navigation.
  }
}

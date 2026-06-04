/// Centralized asset path constants for images, icons, and animations.
///
/// Avoids hardcoded asset paths and ensures consistency.
class AssetConstants {
  AssetConstants._();

  // ── Base Paths ──

  /// Base path for image assets.
  static const String _imagesPath = 'assets/images';

  /// Base path for icon assets.
  static const String _iconsPath = 'assets/icons';

  /// Base path for Lottie animation assets.
  static const String _lottiePath = 'assets/lottie';

  // ── Images ──

  /// App logo image.
  static const String logo = '$_imagesPath/logo.png';

  /// Placeholder image for avatars.
  static const String avatarPlaceholder = '$_imagesPath/avatar_placeholder.png';

  // ── Icons ──

  /// App icon.
  static const String appIcon = '$_iconsPath/app_icon.png';

  // ── Lottie Animations ──

  /// Loading animation.
  static const String loadingAnimation = '$_lottiePath/loading.json';

  /// Error animation.
  static const String errorAnimation = '$_lottiePath/error.json';

  /// Success animation.
  static const String successAnimation = '$_lottiePath/success.json';

  /// No internet animation.
  static const String noInternetAnimation = '$_lottiePath/no_internet.json';
}

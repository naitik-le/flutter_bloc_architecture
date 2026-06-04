import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';

/// Shadow/elevation definitions for consistent depth perception.
class AppShadows {
  AppShadows._();

  /// No shadow.
  static const List<BoxShadow> none = [];

  /// Extra small shadow — subtle elevation.
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Small shadow — cards.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow — elevated cards and dialogs.
  static const List<BoxShadow> md = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  /// Large shadow — modals and overlays.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  /// Extra large shadow — floating elements.
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}

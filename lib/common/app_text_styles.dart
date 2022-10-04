import 'package:flutter/material.dart';
import 'package:note_app/common/app_colors.dart';
import 'package:note_app/common/app_const.dart';

class AppTextStyle {
  static const textDarkPrimary = TextStyle(
    color: AppColors.darkPrimary,
    fontFamily: AppConst.fontPoppins,
  );
  static const textLightPlaceholder = TextStyle(
    color: AppColors.lightPlaceholder,
    fontFamily: AppConst.fontPoppins,
  );

  static final textLightPlaceholderS12 = textLightPlaceholder.copyWith(
    fontSize: 12,
  );
  static final textLightPlaceholderS14 = textLightPlaceholder.copyWith(
    fontSize: 14,
  );
  static final textLightPlaceholderS14Bold = textLightPlaceholder.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final textLightPlaceholderS24 = textLightPlaceholder.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final textDarkPrimaryS14 = textDarkPrimary.copyWith(
    fontSize: 14,
  );

  static final textDarkPrimaryS18 = textDarkPrimary.copyWith(
    fontSize: 18,
  );

  static final textDarkPrimaryS18Medium = textDarkPrimary.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static final textDarkPrimaryS24 = textDarkPrimary.copyWith(
    fontSize: 24,
  );

  static final textDarkPrimaryS24Bold = textDarkPrimaryS24.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static final textDarkPrimaryS36 = textDarkPrimary.copyWith(
    fontSize: 36,
  );

  static final textDarkPrimaryS36Bold = textDarkPrimaryS24.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );
}

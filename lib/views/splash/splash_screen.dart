import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteflow/core/constants/app_colors.dart';
import 'package:noteflow/core/constants/app_strings.dart';
import 'package:noteflow/core/routes/routes_name.dart';
import 'package:noteflow/core/services/shared_preference/app_preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      body: Center(
        child: Text(
          AppStrings.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }

  void  checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    final isLoggedIn = await AppPreference.getLogin();
    print('isLoggedIn: $isLoggedIn');

    if (!mounted) return;

    if (isLoggedIn == true) {
      Get.offAllNamed(RoutesName.mainScreen);
    } else {
      Get.offAllNamed(RoutesName.loginScreen);
    }
  }
}

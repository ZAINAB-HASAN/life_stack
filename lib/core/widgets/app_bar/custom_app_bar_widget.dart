import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteflow/core/constants/app_colors.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String screenTitle;
  final bool isDrawerOpen;
  final VoidCallback? onMenuTap;
  final VoidCallback? onBackTap;

  const CustomAppBarWidget({
    super.key,
    required this.screenTitle,
    required this.isDrawerOpen,
    required this.onMenuTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.babyBlue,
      title: Text(
        screenTitle,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.blackColor,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: isDrawerOpen ? onBackTap : onMenuTap,
        icon: Icon(isDrawerOpen ? Icons.arrow_back_ios : Icons.menu),
        color: AppColors.blackColor,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

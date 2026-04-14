import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteflow/core/constants/app_strings.dart';
import '../../routes/routes_name.dart';
import '../../services/shared_preference/app_preference.dart';

class NavDrawerWidget extends StatelessWidget {
  final String selectedRoute;
  final Function(String) onItemTap;

  const NavDrawerWidget({
    super.key,
    required this.selectedRoute,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Material(
      //color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 40 : 28,
                horizontal: 24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff6A85B6), Color(0xffBAC8E0)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black, size: 50),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Zainab Hasan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  /*_DrawerItem(
                    title: AppStrings.chat,
                    icon: Icons.chat,
                    isSelected: selectedRoute == RoutesName.chatScreen,
                    onTap: () => onItemTap(RoutesName.chatScreen),
                  ),*/
                  _DrawerItem(
                    title: AppStrings.notes,
                    icon: Icons.note_alt_outlined,
                    isSelected: selectedRoute == RoutesName.notesScreen2,
                    onTap: () => onItemTap(RoutesName.notesScreen2),
                  ),
                  _DrawerItem(
                    title: AppStrings.bmiCalculator,
                    icon: Icons.calculate_outlined,
                    isSelected: selectedRoute == RoutesName.bmiScreen,
                    onTap: () => onItemTap(RoutesName.bmiScreen),
                  ),
                  _DrawerItem(
                    title: AppStrings.digitalSignature,
                    icon: Icons.mode_edit,
                    isSelected:
                        selectedRoute == RoutesName.digitalSignatureScreen,
                    onTap: () => onItemTap(RoutesName.digitalSignatureScreen),
                  ),
                ],
              ),
            ),

            /// Changing theme from settings
            _DrawerItem(
              title: AppStrings.settings,
              icon: Icons.settings,
              isSelected: selectedRoute == RoutesName.settingsScreen,
              onTap: () => onItemTap(RoutesName.settingsScreen),
            ),

            /// 🔻 LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: _DrawerItem(
                title: AppStrings.logout,
                icon: Icons.logout,
                isSelected: false,
                onTap: () async {
                  // 🔥 Clear login session here
                  await AppPreference.setLogin(false);
                  Get.offAllNamed(RoutesName.loginScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.blue.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.grey[700]),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

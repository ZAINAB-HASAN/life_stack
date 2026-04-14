import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:noteflow/core/routes/routes_name.dart';
import 'package:noteflow/main.dart';
import 'package:noteflow/views/bmi/bmi_screen.dart';
import 'package:noteflow/views/chat/chat_screen.dart';
import 'package:noteflow/views/login/login_screen.dart';
import 'package:noteflow/views/notes/notes_screen.dart';
import 'package:noteflow/views/notes/notes_screen2.dart';
import 'package:noteflow/views/splash/splash_screen.dart';

import '../../views/digital_signature/digital_signature_screen.dart';
import '../../views/settings/settings_screen.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [
    GetPage(name: RoutesName.splashScreen, page: () => SplashScreen()),
    GetPage(name: RoutesName.loginScreen, page: () => LoginScreen()),
    GetPage(name: RoutesName.mainScreen, page: () => MainScreen()),
    GetPage(
      name: RoutesName.chatScreen,
      page: () {
        final args = Get.arguments ?? {};
        return ChatScreen(
          receiverId: args['receiverId'] ?? '',
          receiverEmail: args['receiverEmail'] ?? '',
        );
      },
    ),
    GetPage(name: RoutesName.notesScreen, page: () => NotesScreen()),
    GetPage(name: RoutesName.bmiScreen, page: () => BmiScreen()),
    GetPage(name: RoutesName.notesScreen2, page: () => NotesScreen2()),
    GetPage(name: RoutesName.settingsScreen, page: () => SettingsScreen()),
    GetPage(name: RoutesName.digitalSignatureScreen, page: () => DigitalSignatureScreen()),
  ];
}

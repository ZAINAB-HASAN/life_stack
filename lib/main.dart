import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:noteflow/core/constants/app_strings.dart';
import 'package:noteflow/core/routes/app_routes.dart';
import 'package:noteflow/core/routes/routes_name.dart';
import 'package:noteflow/data/models/note_model.dart';
import 'package:noteflow/data/providers/theme_provider.dart';
import 'package:noteflow/views/bmi/bmi_screen.dart';
import 'package:noteflow/views/chat/chat_list_screen.dart';
import 'package:noteflow/views/notes/notes_screen2.dart';
import 'package:noteflow/views/settings/settings_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'controllers/nav_drawer_controller/nav_controller.dart';
import 'core/services/notification/notification_service.dart';
import 'core/widgets/app_bar/custom_app_bar_widget.dart';
import 'core/widgets/nav_drawer/nav_drawer_widget.dart';
import 'views/chat/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();

  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>('notes');
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode:
          context.watch<ThemeProvider>().getThemeValue()
              ? ThemeMode.dark
              : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(),
      title: AppStrings.appName,
      initialRoute: RoutesName.splashScreen,
      getPages: AppRoutes.appRoutes(),
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final NavController navController = Get.put(NavController());

  final double xOffset = 230;

  final double yOffset = 150;

  final double scaleFactor = 0.85;

  Widget getScreen(String route) {
    final args = Get.arguments ?? {};
    switch (route) {
      case RoutesName.notesScreen2:
        return const NotesScreen2();
      case RoutesName.bmiScreen:
        return const BmiScreen();
      case RoutesName.settingsScreen:
        return SettingsScreen();
      default:
        //return ChatListScreen();
        return NotesScreen2();
    }
  }

  /*void navigateTo(String _route) {
    setState(() => route = _route);
    Navigator.pop(context); // close drawer
  }*/
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isOpen = navController.isDrawerOpen.value;

      return Stack(
        children: [
          NavDrawerWidget(
            selectedRoute: navController.currentRoute.value,
            onItemTap: (route) {
              navController.navigateTo(route);
            },
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            transform: Matrix4.translationValues(
              isOpen ? xOffset : 0,
              isOpen ? yOffset : 0,
              0,
            )..multiply(
              Matrix4.diagonal3Values(
                isOpen ? 0.70 : 1.0,
                isOpen ? 0.70 : 1.0,
                1.0,
              ),
            ),
            /*decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isOpen ? 40 : 0),
            ),*/
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isOpen ? 40 : 0),
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Obx(
                    () => CustomAppBarWidget(
                      screenTitle: navController.currentTitle.value,
                      isDrawerOpen: navController.isDrawerOpen.value,
                      onMenuTap: navController.openDrawer,
                      onBackTap: navController.closeDrawer,
                    ),
                  ),
                ),
                body: getScreen(navController.currentRoute.value),
              ),
            ),
          ),
        ],
      );
    });
  }
}

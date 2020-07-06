import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayer/screens/CSelectScreen/select_screen.dart';
import 'package:musicplayer/screens/DEditScreen/edit_screen.dart';
import 'package:musicplayer/screens/test.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/ASplashScreen/splash_screen.dart';
import 'screens/BHomeScreen/home_screen.dart';
import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? false;
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      title: 'Music Player',
      home: SplashScreen(),
      initialRoute: SplashScreen.id,
      routes: {
        TestScreen.id: (context) => TestScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        SelectScreen.id: (context) => SelectScreen(),
        EditScreen.id: (context) => EditScreen(
              index: 0,
            ),
      },
    );
  }
}

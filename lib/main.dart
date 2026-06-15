import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set the app to immersive full screen and portrait orientation only
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ReflexArenaApp());
}

class ReflexArenaApp extends StatelessWidget {
  const ReflexArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reflex Arena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto', // Default fallback, thin weights work well
        useMaterial3: true,
      ),
      home: const MenuScreen(),
    );
  }
}

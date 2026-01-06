import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ln_flower/home_view.dart';
import 'package:ln_flower/data/app_hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppHive.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LN Flower POS',
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('lo', 'LA')],
      locale: const Locale('lo', 'LA'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: 'NotoSansLao',
      ),
      home: const HomeView(),
    );
  }
}

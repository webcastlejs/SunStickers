import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'states/_states.dart';
import 'ui/_ui.dart';
import 'ui_kit/_ui_kit.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StickerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Шаг 14: смена темы (Selector перестраивает только при изменении light)
    return Selector<StickerProvider, bool>(
      selector: (_, provider) => provider.state.light,
      builder: (context, light, _) => MaterialApp(
        title: 'Sunny Stickers',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: light ? ThemeMode.light : ThemeMode.dark,
        home: const HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'states/_states.dart';
import 'ui/_ui.dart';
import 'ui_kit/_ui_kit.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Шаг 14: смена темы (select - перестройка только при изменении light)
    final light = ref.watch(stickerProvider.select((s) => s.light));
    return MaterialApp(
      title: 'Sunny Stickers',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: light ? ThemeMode.light : ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}

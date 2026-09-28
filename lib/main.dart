import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'states/_states.dart';
import 'ui/_ui.dart';
import 'ui_kit/_ui_kit.dart';

final Store<StickerState> store = Store<StickerState>(
  stickerReducer,
  initialState: StickerState.initial(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<StickerState>(
      store: store,
      // Шаг 14: смена темы
      child: StoreConnector<StickerState, bool>(
        distinct: true,
        converter: (store) => store.state.light,
        builder: (context, light) => MaterialApp(
          title: 'Sunny Stickers',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: light ? ThemeMode.light : ThemeMode.dark,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

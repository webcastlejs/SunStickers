import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../states/_states.dart';
import '../../ui_kit/_ui_kit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Image.asset(AppAsset.profileImage, width: 300),
          ),
          Text(
            "Hello Sunny!",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 20),
          // Шаг 14: смена темы
          StoreConnector<StickerState, StickerState>(
            distinct: true,
            converter: (store) => store.state,
            builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dark theme", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(width: 10),
                Switch(
                  activeColor: AppColor.accent,
                  value: !state.light,
                  onChanged: (_) => StoreProvider.of<StickerState>(context).dispatch(const ThemeToggledAction()),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

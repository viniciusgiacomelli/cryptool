import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/config_provider.dart';

class DarkModeButton extends StatelessWidget {
  const DarkModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(scheme.surfaceBright),
      ),
      color: scheme.primary,
      icon: context.watch<ConfigProvider>().isDarkMode
          ? const Icon(Icons.light)
          : const Icon(Icons.light_outlined),
      onPressed: () {
        context.read<ConfigProvider>().changeTheme();
      },
    );
  }
}

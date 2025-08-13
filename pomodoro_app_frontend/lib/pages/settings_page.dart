import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/board_provider.dart';
import '../providers/history_provider.dart';
import '../providers/pomodoro_provider.dart';

/// PUBLIC_INTERFACE
/// Basic settings for the app including reset board and viewing default durations.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pomo = context.watch<PomodoroProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Durations'),
            subtitle: Text('Focus: 25m • Short Break: 5m • Long Break: 30m'),
            leading: Icon(Icons.timer),
          ),
          SwitchListTile(
            value: true,
            onChanged: null,
            title: const Text('Playful graphics'),
            subtitle: const Text('Enabled'),
            secondary: const Icon(Icons.celebration),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Reset Board to Start'),
            onTap: () {
              context.read<BoardProvider>().resetToStart();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Board reset.')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Clear History'),
            onTap: () async {
              await context.read<HistoryProvider>().clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('History cleared.')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.stop_circle_outlined),
            title: const Text('Stop Current Session'),
            subtitle: const Text('Counts as interruption (resets streak & board).'),
            onTap: () {
              pomo.stopAndReset(interrupted: true);
              context.read<BoardProvider>().resetToStart();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session stopped.')));
            },
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Version 1.0.0')),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

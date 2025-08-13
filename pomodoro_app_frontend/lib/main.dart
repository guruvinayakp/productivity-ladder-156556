import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/history_page.dart';
import 'pages/home_screen.dart';
import 'pages/settings_page.dart';
import 'providers/board_provider.dart';
import 'providers/history_provider.dart';
import 'providers/pomodoro_provider.dart';
import 'theme.dart';

void main() {
  runApp(const PomodoroApp());
}

/// PUBLIC_INTERFACE
class PomodoroApp extends StatelessWidget {
  /** Application root: sets theme, providers, and routes. */
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoardProvider()),
        ChangeNotifierProxyProvider<BoardProvider, PomodoroProvider>(
          create: (ctx) => PomodoroProvider(board: ctx.read<BoardProvider>()),
          update: (ctx, board, previous) => previous ?? PomodoroProvider(board: board),
        ),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        title: 'Pomodoro Ladder',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routes: {
          '/': (context) => const HomeScreen(),
          '/history': (context) => const HistoryPage(),
          '/settings': (context) => const SettingsPage(),
        },
      ),
    );
  }
}

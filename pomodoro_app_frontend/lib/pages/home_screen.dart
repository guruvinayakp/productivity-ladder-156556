import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/board_provider.dart';
import '../providers/pomodoro_provider.dart';
import '../theme.dart';
import '../widgets/dice_widget.dart';
import '../widgets/progress_streak_widget.dart';
import '../widgets/snakes_ladders_board.dart';
import '../widgets/timer_controls.dart';

/// PUBLIC_INTERFACE
/// Main screen that arranges the board, timer controls, and streak/progress sections.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Treat leaving the app during a running focus session as interruption.
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      context.read<PomodoroProvider>().handleAppBackgrounded();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _AppDrawer(),
      appBar: AppBar(
        title: const Text('Pomodoro Ladder'),
        actions: [
          IconButton(
            tooltip: 'Reset Board',
            onPressed: () => context.read<BoardProvider>().resetToStart(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            // Top: Board
            SnakesLaddersBoard(),
            SizedBox(height: 12),
            DiceWidget(),
            SizedBox(height: 16),
            // Middle: Timer and task controls
            TimerControls(),
            SizedBox(height: 16),
            // Bottom: Streak and progress
            ProgressStreakWidget(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Pomodoro Ladder', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Gamify your focus with snakes & ladders!', style: TextStyle(color: Colors.white)),
                ],
              ),
            ).buildColoredHeader(context),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () => Navigator.of(context).pushNamed('/history'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.of(context).pushNamed('/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Widget {
  Widget buildColoredHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: this,
    );
  }
}

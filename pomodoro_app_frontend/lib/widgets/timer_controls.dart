import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../providers/pomodoro_provider.dart';
import '../theme.dart';

/// PUBLIC_INTERFACE
/// Displays current time remaining, mode, and controls for timer and task name.
class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  String _format(Duration d) {
    final two = NumberFormat('00');
    final m = two.format(d.inMinutes.remainder(60));
    final s = two.format(d.inSeconds.remainder(60));
    final h = d.inHours > 0 ? '${two.format(d.inHours)}:' : '';
    return '$h$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PomodoroProvider>();

    final title = () {
      switch (p.type) {
        case SessionType.focus:
          return 'Focus';
        case SessionType.shortBreak:
          return 'Short Break';
        case SessionType.longBreak:
          return 'Long Break';
      }
    }();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primary)),
            const SizedBox(height: 8),
            Text(
              _format(p.remaining),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFeatures: const [],
                    letterSpacing: 1.5,
                  ),
            ),
            const SizedBox(height: 12),
            if (p.type == SessionType.focus)
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Current Task',
                  prefixIcon: Icon(Icons.task_alt),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => context.read<PomodoroProvider>().setTaskName(v),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: p.isRunning ? null : () => context.read<PomodoroProvider>().start(),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: p.isRunning ? () => context.read<PomodoroProvider>().pause() : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () => context.read<PomodoroProvider>().stopAndReset(interrupted: true),
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

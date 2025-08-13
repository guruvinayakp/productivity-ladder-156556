import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/board_provider.dart';
import '../providers/pomodoro_provider.dart';
import '../theme.dart';

/// PUBLIC_INTERFACE
/// Shows board progress and focus streaks with a motivational message.
class ProgressStreakWidget extends StatelessWidget {
  const ProgressStreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    final pomo = context.watch<PomodoroProvider>();
    final progress = board.position / 100.0;

    String motivation;
    if (pomo.consecutiveFocusCompleted == 0) {
      motivation = 'Start strong! Roll the dice after your first focus.';
    } else if (pomo.consecutiveFocusCompleted % 3 == 0) {
      motivation = 'Streak Bonus! You climbed a ladder!';
    } else {
      motivation = 'Keep it up! You\'re on fire!';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Board Progress', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 8,
              backgroundColor: AppColors.tileLight,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Position: ${board.position}/100'),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.deepOrange),
                    const SizedBox(width: 4),
                    Text('Streak: ${pomo.consecutiveFocusCompleted}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(motivation, style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}

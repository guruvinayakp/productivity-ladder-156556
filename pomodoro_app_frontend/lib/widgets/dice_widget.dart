import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/board_provider.dart';
import '../theme.dart';

/// PUBLIC_INTERFACE
/// Dice display and roll button, enabled when BoardProvider.canRollDice is true.
class DiceWidget extends StatelessWidget {
  const DiceWidget({super.key});

  IconData _diceIcon(int value) {
    switch (value) {
      case 1:
        return Icons.filter_1;
      case 2:
        return Icons.filter_2;
      case 3:
        return Icons.filter_3;
      case 4:
        return Icons.filter_4;
      case 5:
        return Icons.filter_5;
      case 6:
        return Icons.filter_6;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (board.lastDice != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(_diceIcon(board.lastDice!), color: Colors.black87),
                const SizedBox(width: 8),
                Text('Rolled ${board.lastDice}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.casino),
          style: ElevatedButton.styleFrom(
            backgroundColor: board.canRollDice ? AppColors.secondary : Colors.grey.shade300,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: board.canRollDice
              ? () {
                  final roll = context.read<BoardProvider>().rollDiceAndMove();
                  final funText = [
                    'Nice roll!',
                    'Boom!',
                    'Let’s go!',
                    'Productivity +$roll!',
                    'Climb time!',
                    'Snake dodge!',
                  ];
                  final text = funText[Random().nextInt(funText.length)];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$text You rolled $roll.')),
                  );
                }
              : null,
          label: const Text('Roll Dice'),
        ),
      ],
    );
  }
}

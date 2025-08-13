import 'package:flutter/material.dart';
import '../providers/board_provider.dart';
import '../theme.dart';
import 'package:provider/provider.dart';

/// PUBLIC_INTERFACE
/// Visual 10x10 board with ladders/snakes markers and the player's token.
class SnakesLaddersBoard extends StatelessWidget {
  const SnakesLaddersBoard({super.key});

  int _calcRow(int index) => (index / 10).floor();
  bool _isReversedRow(int row) => row % 2 == 1;

  int _displayNumberForIndex(int index) {
    final row = _calcRow(index);
    final base = (row * 10);
    final offset = index % 10;
    if (_isReversedRow(row)) {
      return 100 - base - offset;
    } else {
      return 100 - base - (9 - offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    return AspectRatio(
      aspectRatio: 1.1,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.tileLight,
              Colors.white,
              AppColors.tileDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: 100,
            itemBuilder: (context, index) {
              final number = _displayNumberForIndex(index);
              final isPlayerHere = number == board.position;
              final hasLadder = board.ladders.containsKey(number);
              final hasSnake = board.snakes.containsKey(number);

              return Container(
                decoration: BoxDecoration(
                  color: (index % 2 == 0) ? Colors.white : AppColors.tileLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black12),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Text(
                        '$number',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    if (hasLadder)
                      const Center(
                        child: Icon(Icons.stairs, color: Colors.green, size: 18),
                      ),
                    if (hasSnake)
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.downhill_skiing, color: Colors.red, size: 16),
                        ),
                      ),
                    if (isPlayerHere)
                      Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

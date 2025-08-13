import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../providers/history_provider.dart';

/// PUBLIC_INTERFACE
/// Shows the list of completed sessions (focus and breaks) with timestamps.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Load on entry
    Future.microtask(() => context.read<HistoryProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final hp = context.watch<HistoryProvider>();
    final dateFmt = DateFormat('MMM d, h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            tooltip: 'Clear History',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear History'),
                  content: const Text('This will delete all past sessions. Continue?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
                  ],
                ),
              );
              if (confirm == true) {
                await hp.clear();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('History cleared.')));
                }
              }
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: hp.sessions.isEmpty
          ? const Center(child: Text('No sessions yet. Stay focused and come back!'))
          : ListView.separated(
              itemCount: hp.sessions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final s = hp.sessions[index];
                final durationMin = (s.durationSeconds / 60).round();
                IconData icon;
                Color color;
                switch (s.type) {
                  case SessionType.focus:
                    icon = Icons.task_alt;
                    color = Colors.green;
                    break;
                  case SessionType.shortBreak:
                    icon = Icons.coffee;
                    color = Colors.orange;
                    break;
                  case SessionType.longBreak:
                    icon = Icons.spa;
                    color = Colors.teal;
                    break;
                }

                return ListTile(
                  leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
                  title: Text('${s.displayLabel()} • ${durationMin}m'),
                  subtitle: Text('${s.taskName} • ${dateFmt.format(s.timestamp)}'),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';

class ReminderItem {
  String title;
  String time;
  bool isEnabled;

  ReminderItem({
    required this.title,
    required this.time,
    this.isEnabled = true,
  });
}

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<ReminderItem> _reminders = [
    ReminderItem(title: 'Tomar medicação da manhã', time: '08:00'),
    ReminderItem(title: 'Tomar medicação da noite', time: '20:00'),
    ReminderItem(title: 'Hora de exercícios', time: '15:00'),
  ];

  void _addReminder() {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '12:00');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Lembrete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ex: Tomar medicação',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Horário',
                hintText: 'Ex: 08:00',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _reminders.add(
                    ReminderItem(
                      title: titleController.text,
                      time: timeController.text,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  void _toggleReminder(int index, bool value) {
    setState(() {
      _reminders[index].isEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () {
            // Se for aba, talvez não precise de ação, ou volta para a home
            // Mas como está na BottomBar, o comportamento padrão é não ter back button
            // Vou manter visualmente mas sem ação ou ação de ir para index 0
          },
        ),
        title: const Text(
          'Alertas e Lembretes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum lembrete cadastrado',
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _reminders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildAlertCard(
                  _reminders[index],
                  index,
                );
              },
            ),
      floatingActionButton: AuthService().canAddReminder()
          ? FloatingActionButton(
              onPressed: _addReminder,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildAlertCard(ReminderItem reminder, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications, color: AppColors.iconGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reminder.time,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: reminder.isEnabled,
            onChanged: AuthService().canToggleReminder()
                ? (val) => _toggleReminder(index, val)
                : null,
            activeColor: AppColors.primary,
          ),
          if (AuthService().canDeleteReminder())
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeReminder(index),
              tooltip: 'Remover lembrete',
            ),
        ],
      ),
    );
  }
}

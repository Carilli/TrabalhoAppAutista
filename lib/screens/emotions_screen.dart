import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class EmotionsScreen extends StatefulWidget {
  const EmotionsScreen({super.key});

  @override
  State<EmotionsScreen> createState() => _EmotionsScreenState();
}

class _EmotionsScreenState extends State<EmotionsScreen> {
  String? _selectedEmotion;
  final List<Map<String, dynamic>> _registeredEmotions = [];

  final List<Map<String, dynamic>> _emotions = [
    {'name': 'Feliz', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.amber},
    {'name': 'Triste', 'icon': Icons.sentiment_very_dissatisfied, 'color': Colors.blue},
    {'name': 'Ansioso', 'icon': Icons.bolt, 'color': Colors.red},
    {'name': 'Calmo', 'icon': Icons.favorite, 'color': Colors.green},
    {'name': 'Neutro', 'icon': Icons.sentiment_neutral, 'color': Colors.grey},
  ];

  void _registerEmotion() {
    if (_selectedEmotion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma emoção primeiro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final selectedEmotionData = _emotions.firstWhere(
      (emotion) => emotion['name'] == _selectedEmotion,
    );

    setState(() {
      _registeredEmotions.insert(0, {
        'name': _selectedEmotion,
        'icon': selectedEmotionData['icon'],
        'color': selectedEmotionData['color'],
        'timestamp': DateTime.now(),
      });
      _selectedEmotion = null; // Reset selection after registering
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emoção registrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Como você está se sentindo?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _emotions.length,
              itemBuilder: (context, index) {
                final emotion = _emotions[index];
                final isSelected = _selectedEmotion == emotion['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmotion = emotion['name'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: (emotion['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? (emotion['color'] as Color) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          emotion['icon'],
                          size: 32,
                          color: emotion['color'],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emotion['name'],
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerEmotion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Registrar Emoção'),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Histórico Recente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _registeredEmotions.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma emoção registrada ainda',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _registeredEmotions.length,
                      itemBuilder: (context, index) {
                        final emotion = _registeredEmotions[index];
                        final timestamp = emotion['timestamp'] as DateTime;
                        final now = DateTime.now();
                        final difference = now.difference(timestamp);
                        
                        String timeText;
                        if (difference.inMinutes < 1) {
                          timeText = 'Agora';
                        } else if (difference.inHours < 1) {
                          timeText = '${difference.inMinutes}m atrás';
                        } else if (difference.inDays < 1) {
                          timeText = '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
                        } else if (difference.inDays == 1) {
                          timeText = 'Ontem';
                        } else {
                          timeText = '${difference.inDays}d atrás';
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
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
                                  color: (emotion['color'] as Color).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  emotion['icon'],
                                  color: emotion['color'],
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      emotion['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      timeText,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

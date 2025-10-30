import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Achievement {
  final String title;
  final String description;
  final String imageUrl;
  final bool isUnlocked;

  const Achievement({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isUnlocked = false,
  });
}

class AchievementService {
  List<Achievement> getAchievements() => const [
    Achievement(
      title: 'Первый шаг',
      description: 'Создана первая цель',
      imageUrl: 'https://picsum.photos/id/237/600/400',
      isUnlocked: true,
    ),
    Achievement(
      title: 'Настойчивость',
      description: 'Выполнено 5 целей подряд',
      imageUrl: 'https://picsum.photos/id/1025/600/400',
      isUnlocked: true,
    ),
    Achievement(
      title: 'Мастер планирования',
      description: 'Добавлено 10 подцелей',
      imageUrl: 'https://picsum.photos/id/1011/600/400',
      isUnlocked: false,
    ),
    Achievement(
      title: 'Ежедневная серия',
      description: 'Серия из 7 дней',
      imageUrl: 'https://picsum.photos/id/1003/600/400',
      isUnlocked: false,
    ),
    Achievement(
      title: 'Целеустремлённый',
      description: 'Цель с подцелями',
      imageUrl: 'https://picsum.photos/id/1035/600/400',
      isUnlocked: true,
    ),
    Achievement(
      title: 'Легенда целей',
      description: 'Все цели закрыты',
      imageUrl: 'https://picsum.photos/id/1043/600/400',
      isUnlocked: false,
    ),
  ];
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = AchievementService().getAchievements();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Профиль'),
          leading: BackButton(onPressed: () => context.pop()),
      ),
      body: achievements.isEmpty
          ? const _EmptyState()
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: achievements.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final a = achievements[i];
          return ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            leading: _Thumb(url: a.imageUrl),
            title: Text(
              a.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              a.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              a.isUnlocked ? Icons.verified : Icons.lock_outline,
              color: a.isUnlocked ? Colors.green : null,
            ),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  const _Thumb({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        placeholder: (c, _) => const SizedBox(
          width: 72,
          height: 72,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (c, _, __) => const SizedBox(
          width: 72,
          height: 72,
          child: Icon(Icons.broken_image),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text('Ачивок пока нет'),
      ),
    );
  }
}

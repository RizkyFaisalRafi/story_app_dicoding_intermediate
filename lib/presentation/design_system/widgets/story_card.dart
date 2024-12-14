import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/list_story.dart';
import '../../router/app_router.dart';

class StoryCard extends StatelessWidget {
  final ListStory story;

  const StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              fit: BoxFit.cover,
              story.photoUrl,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image_rounded);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
        title: Text(story.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${story.description}',
              maxLines: 2,
            ),
            Text('Id: ${story.id}', maxLines: 1),
            Text('Created at: ${story.createdAt}', maxLines: 1),
            Text('Latitude: ${story.lat}', maxLines: 1),
            Text('Longitude: ${story.lon}', maxLines: 1),
          ],
        ),
        onTap: () async {
          // Menangani interaksi dengan cerita, bisa ditambahkan navigasi ke detail cerita by id
          context.goNamed(
            RouteConstants.detailStory,
            extra: story,
          );
        },
      ),
    );
  }
}

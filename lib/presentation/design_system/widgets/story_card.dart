import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/constants/datetime_formatting.dart';
import '../../../domain/entities/list_story.dart';
import '../../router/app_router.dart';
import '../common/common.dart';

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
            // *Description
            Text(
              // 'Description: ${story.description}',
              // '${AppLocalizations.of(context)!.titleDescription}: ${story.description}',
              AppLocalizations.of(context)!.titleDescription(story.description),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // *Id Story
            Row(
              children: [
                const Icon(Icons.code_rounded, color: Colors.blue, size: 20),
                const SpaceWidth(8),
                Expanded(
                  child: Text(
                    'Id: ${story.id}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // *Created at
            Row(
              children: [
                const Icon(Icons.create, color: Colors.blue, size: 20),
                const SpaceWidth(8),
                Expanded(
                  child: Text(
                    // story.createdAt!.toDate,
                    story.createdAt!.toLocalizedDate(
                        Localizations.localeOf(context).languageCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // *Latitude
            Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.blue, size: 20),
                const SpaceWidth(8),
                Text(
                  // 'Latitude: ${story.lat}',
                  AppLocalizations.of(context)!.tittleLatitude(story.lat ?? 0),
                  maxLines: 1,
                ),
              ],
            ),

            // *Longitude
            Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.blue, size: 20),
                const SpaceWidth(8),
                Text(
                  // 'Longitude: ${story.lon}',
                  AppLocalizations.of(context)!.tittleLongitude(story.lon ?? 0),
                  maxLines: 1,
                ),
              ],
            ),
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

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/common/state_enum.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/list_story.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/constants/datetime_formatting.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/detail_provider.dart';
import '../../design_system/constants/theme.dart';
import '../../design_system/widgets/error_state_widget.dart';

class DetailStoryPage extends StatelessWidget {
  final ListStory listStory;

  const DetailStoryPage({
    super.key,
    required this.listStory,
  });

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<DetailProvider>(context, listen: false);
    // Memuat data cerita berdasarkan ID jika belum ada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (detailProvider.listStory == null ||
          detailProvider.listStory!.id != listStory.id) {
        log("Benar: ${listStory.id}");
        detailProvider.fetchDetail(
            context, listStory.id); // Fungsi untuk memuat detail berdasarkan ID
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          // Latar Belakang Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              color: Colors.grey.withOpacity(0.1), // Lapisan semi-transparan
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xffFC6A67),
                centerTitle: true,
                title: Text(
                  'Detail Story',
                  style: fontPoppins.copyWith(
                    fontSize: 24,
                    fontWeight: weightSemiBold,
                    color: Colors.white,
                  ),
                ),
              ),
              Consumer<DetailProvider>(
                builder: (context, provider, _) {
                  final stories = provider.listStory;
                  final stateData = provider.state;

                  // Menangani berbagai kondisi (error, loading, empty, loaded)
                  if (stateData == RequestState.error) {
                    log(provider.errorMessage ?? 'Error terjadi');
                    return SliverToBoxAdapter(
                      child: ErrorStateWidget(
                        message: provider.errorMessage ?? 'Null',
                      ),
                    );
                  } else if (stateData == RequestState.loading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (stories == null || stories.id.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text('No stories available'),
                      ),
                    );
                  } else {
                    // Jika cerita sudah berhasil dimuat, tampilkan cerita
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SafeArea(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultMargin,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Photo Section
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        stories.photoUrl,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child; // Gambar sudah dimuat
                                          }
                                          return const Center(
                                            heightFactor: 4,
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // Menampilkan gambar default atau widget lain jika gagal load gambar
                                          return const Icon(
                                            size: 200,
                                            Icons.broken_image_rounded,
                                            color: Colors.red,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SpaceHeight(16),

                                  // Name Section
                                  Text(
                                    // stories.name,
                                    stories.name.isNotEmpty
                                        ? stories.name
                                        : 'Nama tidak tersedia',
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),

                                  // Description Section
                                  Text(
                                    stories.description,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[800],
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(height: 16.0),

                                  // Created At Section
                                  Card(
                                    elevation: 3,
                                    child: ListTile(
                                      leading: const Icon(Icons.calendar_today,
                                          color: Colors.teal),
                                      title: const Text('Created At'),
                                      subtitle:
                                          Text(stories.createdAt?.toDate ?? ''),
                                    ),
                                  ),

                                  const SizedBox(height: 16.0),

                                  Card(
                                    elevation: 3,
                                    child: ListTile(
                                      leading: const Icon(Icons.location_on,
                                          color: Colors.teal),
                                      title: const Text('Location'),
                                      subtitle: Text(
                                          'Lat: ${stories.lat}, Long: ${stories.lon}'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

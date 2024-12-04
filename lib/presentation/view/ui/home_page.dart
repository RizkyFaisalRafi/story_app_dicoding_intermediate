import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/common/state_enum.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/constants/theme.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/home_provider.dart';
import '../../design_system/widgets/error_state_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    // Panggil loadStories saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        homeProvider.loadStories(context);
      },
    );

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
                  'Home Page',
                  style: fontPoppins.copyWith(
                    fontSize: 24,
                    fontWeight: weightSemiBold,
                    color: Colors.white,
                  ),
                ),
              ),
              Consumer<HomeProvider>(
                builder: (context, provider, _) {
                  final stories = provider.listStory;
                  final stateData = provider.state;
                  if (stateData == RequestState.error) {
                    log(provider.errorMessage ?? 'Null Bray');
                    return ErrorStateWidget(
                      message: provider.errorMessage ?? 'Null',
                    );
                  } else if (stateData == RequestState.loading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (stories.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text('No stories available'),
                      ),
                    );
                  } else if (stateData == RequestState.loaded) {
                    return SliverList.builder(
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        final story = stories[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: ListTile(
                            leading: SizedBox(
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  fit: BoxFit.cover,
                                  story.photoUrl,
                                ),
                              ),
                            ),
                            title: Text(story.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ${story.description}',
                                  maxLines: 1,
                                ),
                                Text(
                                  'Id: ${story.id}',
                                  maxLines: 1,
                                ),
                                Text(
                                  'Created at: ${story.createdAt}',
                                  maxLines: 1,
                                ),
                                Text(
                                  'Latitude: ${story.lat}',
                                  maxLines: 1,
                                ),
                                Text(
                                  'Longitude: ${story.lon}',
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            onTap: () async {
                              // Menghapus data otentikasi dari penyimpanan lokal
                              await homeProvider.deleteTokenUseCase.execute();
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: Text('Undefined State'),
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

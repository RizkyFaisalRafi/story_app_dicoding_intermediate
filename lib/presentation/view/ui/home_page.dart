import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/common/state_enum.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/constants/theme.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/widgets/card_skelton.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/home_provider.dart';
import '../../design_system/widgets/error_state_widget.dart';
import '../../design_system/widgets/story_card.dart';
import '../../router/app_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// *Halaman utama aplikasi yang menampilkan daftar cerita
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil HomeProvider untuk mengelola status cerita
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Latar belakang dengan efek blur.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              color: Colors.grey.withOpacity(0.1), // Lapisan semi-transparan
            ),
          ),

          // Konten utama menggunakan CustomScrollView untuk efek sliver
          SmartRefresher(
            controller: provider.refreshC,
            onRefresh: provider.onRefresh,
            header: const WaterDropHeader(
              complete: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded),
                  Text('Refresh Complete'),
                ],
              ),
              failed: Text('Refresh Failed'),
              refresh: CircularProgressIndicator(),
              waterDropColor: Colors.blue,
              idleIcon: Icon(
                Icons.local_dining_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            child: CustomScrollView(
              slivers: [
                // AppBar dengan tombol logout
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
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add_box_rounded),
                      onPressed: () {
                        // Add Story User Account Function
                        context.goNamed(
                          RouteConstants.addStoryUser,
                        );
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        // Delete Local Data TOKEN, NAME, EMAIL.
                        await homeProvider.deleteTokenUseCase.execute();
                        await homeProvider.deleteNameLocalUsecase.execute();
                        await homeProvider.deleteEmailLocalUsecase.execute();

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Berhasil Keluar Akun'),
                              backgroundColor: Colors.red,
                            ),
                          );

                          // Navigate Login
                          context.goNamed(
                            RouteConstants.login,
                          );
                        }
                      },
                    ),

                    const SpaceWidth(defaultMargin), // Ruang kosong antar ikon
                  ],
                ),

                // Menggunakan Consumer untuk menangani perubahan status
                Consumer<HomeProvider>(
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
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const CardList(),
                        ),
                      );
                    } else if (stories.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text('No stories available'),
                        ),
                      );
                    } else {
                      // Jika cerita sudah berhasil dimuat, tampilkan daftar cerita
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final story = stories[index];
                            return StoryCard(story: story);
                          },
                          childCount: stories.length,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/constants/theme.dart';
import 'package:story_app_dicoding_intermediate/presentation/router/app_router.dart';
import '../../design_system/common/common.dart';
import '../../design_system/widgets/list_profile.dart';
import '../provider/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.tittleProfile,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultMargin),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String?>(
                        future: profileProvider.getNameLocalUsecase.execute(),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? 'Null Name',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.blue),
                        const SizedBox(width: 8),
                        FutureBuilder<String?>(
                          future:
                              profileProvider.getEmailLocalUsecase.execute(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? 'Null Email',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SpaceHeight(28),
            ListProfile(
              onTap: () {
                context.goNamed(RouteConstants.settings);
              },
              imagePath: 'assets/icons/settings_profil.svg',
              title: AppLocalizations.of(context)!.titleSetting,
              subTitle: AppLocalizations.of(context)!.subTittleSetting,
            ),
            const SpaceHeight(8),
            ListProfile(
              onTap: () {
                context.goNamed(RouteConstants.contactUs);
              },
              imagePath: 'assets/icons/contact_us_profil.svg',
              title: AppLocalizations.of(context)!.titleContactUs,
              subTitle: AppLocalizations.of(context)!.subTittleContactUs,
            ),
            const SpaceHeight(8),
            ListProfile(
              onTap: () {
                context.goNamed(RouteConstants.aboutApp);
              },
              imagePath: 'assets/icons/about_app_profil.svg',
              title: AppLocalizations.of(context)!.titleAboutApp,
              subTitle: AppLocalizations.of(context)!.subTitleAboutApp,
            ),
          ],
        ),
      ),
    );
  }
}

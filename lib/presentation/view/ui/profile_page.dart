import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
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
        title: const Text('Profile'),
      ),
      body: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
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
                      future: profileProvider.getEmailLocalUsecase.execute(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? 'Null Email',
                        );
                      }),
                ],
              ),
              const SpaceHeight(28),
              ListProfile(
                onTap: () {
                  // Navigator.pushNamed(context, SettingsPage.routeName);
                },
                imagePath: 'assets/icons/settings_profil.svg',
                title: 'Pengaturan',
                subTitle: 'Pengaturan tentang aplikasi.',
              ),
              const SpaceHeight(8),
              ListProfile(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return const ContactUsScreen();
                  //     },
                  //   ),
                  // );
                },
                imagePath: 'assets/icons/contact_us_profil.svg',
                title: 'Hubungi Kami',
                subTitle: 'Sampaikan kendala, kritik, dan saran Anda.',
              ),
              const SpaceHeight(8),
              ListProfile(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return const AboutAppPage();
                  //     },
                  //   ),
                  // );
                },
                imagePath: 'assets/icons/about_app_profil.svg',
                title: 'Tentang Aplikasi',
                subTitle: 'Lihat informasi lengkap tentang aplikasi.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

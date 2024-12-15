import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/add_story_user_provider.dart';
import '../../design_system/components/button.dart';
import '../../design_system/components/custom_text_field.dart';
import '../../design_system/constants/theme.dart';

class AddStoryUserPage extends StatelessWidget {
  const AddStoryUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddStoryUserProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xffFC6A67), // Warna merah.
                centerTitle: true,
                title: Text(
                  'Add Story User',
                  style: fontPoppins.copyWith(
                    fontSize: 24,
                    fontWeight: weightSemiBold,
                    color: Colors.white,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(defaultMargin),
                      child: Column(
                        children: [
                          Image.asset('assets/images/logo_splash.png'),
                          const SpaceHeight(24),
                          Form(
                            key: provider.formKey,
                            child: Column(
                              children: [
                                _buildImagePreview(context),
                                const SpaceHeight(24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Button.filled(
                                        onPressed: () {
                                          return provider
                                              .onCustomCameraView(context);
                                        },
                                        label: 'Custom Camera',
                                      ),
                                    ),
                                    const SpaceWidth(24),
                                    Expanded(
                                      child: Button.filled(
                                        onPressed: () {
                                          return provider.onGalleryView();
                                        },
                                        label: 'Gallery',
                                      ),
                                    ),
                                  ],
                                ),
                                const SpaceHeight(24),
                                Consumer<AddStoryUserProvider>(
                                    builder: (context, provider, _) {
                                  return CustomTextField(
                                    controller: provider.descController,
                                    label: 'Deskripsi',
                                    filledForm: true,
                                    validate: provider.validateDesc,
                                  );
                                }),
                                const SpaceHeight(24),
                                Button.filled(
                                  onPressed: () async {
                                    if (provider.formKey.currentState!
                                        .validate()) {
                                      try {
                                        await provider.submitStoryUser(context);
                                      } catch (e) {
                                        log('catch AddStoryUserPage: $e');
                                      }
                                    }
                                  },
                                  label: 'Kirim',
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget _buildImagePreview(BuildContext context) {
  final imagePath = context.watch<AddStoryUserProvider>().imagePath;
  return imagePath == null
      ? const Align(
          alignment: Alignment.center,
          child: Icon(Icons.image, size: 220),
        )
      : _showImage(context, imagePath);
}

Widget _showImage(BuildContext context, String imagePath) {
  return kIsWeb
      ? Image.network(imagePath, fit: BoxFit.contain)
      : GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Image.file(
                  height: 500,
                  File(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              height: 200,
              File(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        );
}

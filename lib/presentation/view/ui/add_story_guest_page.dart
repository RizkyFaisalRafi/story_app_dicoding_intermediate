import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/custom_text_field.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/add_story_guest_provider.dart';
import '../../design_system/components/button.dart';
import '../../design_system/constants/theme.dart';
import '../../router/app_router.dart';

// *Halaman untuk menambahkan cerita oleh pengguna guest.
class AddStoryGuestPage extends StatelessWidget {
  const AddStoryGuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddStoryGuestProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Latar belakang dengan efek blur.
          _buildBlurBackground(),

          // Konten utama halaman.
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              _buildPageContent(context, provider),
            ],
          ),
        ],
      ),

      // Footer aplikasi.
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Powered by Rizky Faisal Rafi Go To Expert',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBlurBackground() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
      child: Container(
        color: Colors.grey.withOpacity(0.1), // Lapisan semi-transparan.
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xffFC6A67), // Warna merah.
      centerTitle: true,
      title: Text(
        'Add Story Guest',
        style: fontPoppins.copyWith(
          fontSize: 24,
          fontWeight: weightSemiBold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPageContent(
      BuildContext context, AddStoryGuestProvider provider) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(defaultMargin),
            child: Column(
              children: [
                Image.asset('assets/images/logo_splash.png'),
                const SpaceHeight(24),
                const Text('Kamu masuk ke mode Guest / Belum Login.'),
                const SpaceHeight(24),
                _buildAddStoryButton(context, provider),
                const SpaceHeight(24),
                _buildLoginButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddStoryButton(
      BuildContext context, AddStoryGuestProvider provider) {
    return Button.filled(
      onPressed: () => _showAddStoryModal(context, provider),
      label: 'Add Story Guest Account',
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Button.outlined(
      onPressed: () => context.goNamed(RouteConstants.login),
      label: 'Log In',
    );
  }

  void _showAddStoryModal(
      BuildContext context, AddStoryGuestProvider provider) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: defaultMargin,
            right: defaultMargin,
          ),
          child: Wrap(
            children: [
              Form(
                key: provider.formKey,
                child: Column(
                  children: [
                    const SpaceHeight(24),
                    _buildImagePreview(context),
                    const SpaceHeight(24),
                    _buildImageActionButtons(context, provider),
                    const SpaceHeight(24),
                    CustomTextField(
                      controller: provider.descController,
                      label: 'Deskripsi',
                      filledForm: true,
                      validate: provider.validateDesc,
                    ),
                    const SpaceHeight(24),
                    _buildSubmitButton(context, provider),
                    const SpaceHeight(24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    final imagePath = context.watch<AddStoryGuestProvider>().imagePath;
    return imagePath == null
        ? const Align(
            alignment: Alignment.center,
            child: Icon(Icons.image, size: 220),
          )
        : _showImage(context, imagePath);
  }

  Widget _buildImageActionButtons(
      BuildContext context, AddStoryGuestProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Button.filled(
            onPressed: () => provider.onCustomCameraView(context),
            label: 'Custom Camera',
          ),
        ),
        const SpaceWidth(24),
        Expanded(
          child: Button.filled(
            onPressed: provider.onGalleryView,
            label: 'Gallery',
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, AddStoryGuestProvider provider) {
    return Button.filled(
      onPressed: () async {
        if (provider.formKey.currentState!.validate()) {
          try {
            await provider.submitStoryGuest(context);
            if (context.mounted) context.pop(context);
          } catch (e) {
            log('catch AddStoryGuestPage: $e');
          }
        }
      },
      label: 'Kirim',
    );
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
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/button.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/components/spaces.dart';
import 'package:story_app_dicoding_intermediate/presentation/design_system/constants/theme.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/register_provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/router/route_constants.dart';

import '../../design_system/components/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          // Latar Belakang Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              color: Colors.grey.withOpacity(0.1),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SafeArea(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultMargin,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hello Reviewer Dicoding!',
                              style: fontPoppins.copyWith(
                                fontSize: sizeExtraLarge,
                                fontWeight: weightSemiBold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SpaceHeight(12),
                            Text(
                              'Please register yourself to be a part of us!',
                              style: fontPoppins.copyWith(
                                fontSize: sizeExtraLarge,
                                fontWeight: weightSemiBold,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SpaceHeight(32),
                            Form(
                              key: provider.globalKey,
                              child: Column(
                                children: [
                                  // Form Email
                                  CustomTextField(
                                    validate: provider.validateEmail,
                                    fillColor: Colors.white,
                                    filledForm: true,
                                    controller: provider.emailController,
                                    label: 'Email',
                                  ),
                                  const SpaceHeight(24),

                                  // Form Password
                                  Consumer<RegisterProvider>(
                                    builder: (context, prov, _) {
                                      return CustomTextField(
                                        validate: prov.validatePass,
                                        maxLine: 1,
                                        obscureText: prov.obscureText,
                                        controller: prov.passwordController,
                                        suffixIcon: IconButton(
                                          icon: Iconify(
                                            prov.obscureText
                                                ? Eva.eye_off_outline
                                                : Eva.eye_outline,
                                            color: prov.obscureText
                                                ? Colors.grey
                                                : const Color(0xffFC6A67),
                                          ),
                                          onPressed: () {
                                            prov.toggleObscureText();
                                          },
                                        ),
                                        fillColor: Colors.white,
                                        filledForm: true,
                                        label: 'Password',
                                      );
                                    },
                                  ),
                                  const SpaceHeight(24),

                                  // Form Name
                                  CustomTextField(
                                    validate: provider.validateName,
                                    fillColor: Colors.white,
                                    filledForm: true,
                                    controller: provider.nameController,
                                    label: 'Name',
                                  ),

                                  const SpaceHeight(40),

                                  // Button Register
                                  Button.filled(
                                    onPressed: () {
                                      if (provider.globalKey.currentState!
                                          .validate()) {
                                        try {
                                          // Register
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Mohon isi semua form'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    label: 'Sign Up',
                                    borderRadius: 12.0,
                                    height: 55,
                                    color: const Color(0xffFC6A67),
                                  ),

                                  const SpaceHeight(48),

                                  // Log In
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account?',
                                        style: fontPoppins.copyWith(
                                          fontSize: sizeSmall,
                                          fontWeight: weightMedium,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Go to Login Page
                                          context.goNamed(
                                            RouteConstants.login,
                                          );
                                        },
                                        child: Text(
                                          'Log In now!',
                                          style: fontPoppins.copyWith(
                                            color: Colors.blue,
                                            fontSize: sizeSmall,
                                            fontWeight: weightBold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

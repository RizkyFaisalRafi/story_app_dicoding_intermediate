import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:provider/provider.dart';
import '../../design_system/components/button.dart';
import '../../design_system/components/custom_text_field.dart';
import '../../design_system/components/spaces.dart';
import '../../design_system/constants/theme.dart';
import '../../design_system/widgets/dialog_animate.dart';
import '../../design_system/widgets/logo_button.dart';
import '../../router/app_router.dart';
import '../provider/login_provider.dart';
import 'package:wx_divider/wx_divider.dart';
import '../../../common/state_enum.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    final providerTrue = Provider.of<LoginProvider>(context, listen: true);

    final width = MediaQuery.of(context).size.width;
    final isDone = provider.state == RequestState.loaded;
    final isError = provider.state == RequestState.error;
    final isStretched =
        provider.isAnimating || provider.state == RequestState.init;

    return Scaffold(
      body: Stack(
        children: [
          // Latar Belakang Blur dengan Animasi
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            color: providerTrue.state == RequestState.loading
                ? Colors.grey.withOpacity(0.4)
                : Colors.grey.withOpacity(0.1),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: providerTrue.state == RequestState.loading ? 5 : 0,
                sigmaY: providerTrue.state == RequestState.loading ? 5 : 0,
              ),
              child: Container(),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xffFC6A67),
                centerTitle: true,
                title: Text(
                  'Sign In',
                  style: fontPoppins.copyWith(
                    fontSize: 24,
                    fontWeight: weightSemiBold,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: 'Add Story Guest',
                    icon: const Icon(Icons.person_4_rounded),
                    onPressed: () {
                      context.goNamed(RouteConstants.addStoryGuest);
                    },
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
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
                            'Welcome back you\'ve\nbeen missed!',
                            style: fontPoppins.copyWith(
                              fontSize: sizeExtraLarge,
                              fontWeight: weightSemiBold,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SpaceHeight(32),
                          Form(
                            key: provider.formKey,
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
                                Consumer<LoginProvider>(
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

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Recovery Password?',
                                        style: fontPoppins.copyWith(
                                          fontSize: sizeSmall,
                                          fontWeight: weightReguler,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SpaceHeight(28),

                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 1000),
                                  child:
                                      providerTrue.state == RequestState.loading
                                          ? const CircularProgressIndicator()
                                          : buttonLogIn(providerTrue, context),
                                ),

                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(32),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeIn,
                                    width: provider.state == RequestState.init
                                        ? width
                                        : 70,
                                    onEnd: () {
                                      // providerTrue.animat();
                                      providerTrue.setAnimating(false);
                                    },
                                    height: 70,
                                    child: isStretched
                                        ? buildButton(context, providerTrue)
                                        : buildSmallButton(isDone, isError),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SpaceHeight(48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: WxDivider(
                                  color: Colors.black,
                                  pattern: WxDivider.solid,
                                  gradient: LinearGradient(colors: [
                                    Colors.grey.shade200,
                                    Colors.grey.shade300,
                                    Colors.grey.shade400,
                                    Colors.grey,
                                  ]),
                                  thickness: 2.0,
                                  lines: 1,
                                  direction: Axis.horizontal,
                                ),
                              ),
                              const SpaceWidth(20),
                              const Text('Or continue with'),
                              const SpaceWidth(20),
                              Expanded(
                                child: WxDivider(
                                  color: Colors.black,
                                  pattern: WxDivider.solid,
                                  gradient: LinearGradient(colors: [
                                    Colors.grey,
                                    Colors.grey.shade400,
                                    Colors.grey.shade300,
                                    Colors.grey.shade200,
                                  ]),
                                  thickness: 2.0,
                                  lines: 1,
                                  direction: Axis.horizontal,
                                ),
                              ),
                            ],
                          ),
                          const SpaceHeight(48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Google
                              LogoButton(
                                onPressed: () {
                                  DialogAnimate.show(
                                    context,
                                    title: 'Coming Soon',
                                    content:
                                        'Fitur Login Google Belum Tersedia',
                                  );
                                },
                                logoIcon: Logos.google_icon,
                              ),

                              LogoButton(
                                onPressed: () {
                                  DialogAnimate.show(
                                    context,
                                    title: 'Coming Soon',
                                    content: 'Fitur Login Apple Belum Tersedia',
                                  );
                                },
                                logoIcon: Logos.apple,
                              ),

                              LogoButton(
                                onPressed: () {
                                  DialogAnimate.show(
                                    context,
                                    title: 'Coming Soon',
                                    content:
                                        'Fitur Login Facebook Belum Tersedia',
                                  );
                                },
                                logoIcon: Logos.facebook,
                              ),
                            ],
                          ),
                          const SpaceHeight(48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Not a member?',
                                style: fontPoppins.copyWith(
                                  fontSize: sizeSmall,
                                  fontWeight: weightMedium,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Go to Register Page
                                  context.goNamed(
                                    RouteConstants.register,
                                  );
                                },
                                child: Text(
                                  'Register now!',
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
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Button buttonLogIn(LoginProvider provider, BuildContext context) {
    return Button.filled(
      onPressed: () {
        if (provider.formKey.currentState!.validate()) {
          try {
            // Login
            provider.login(
              context,
            );
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mohon isi semua form'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      label: 'Sign In',
      borderRadius: 12.0,
      height: 55,
      color: const Color(0xffFC6A67),
    );
  }

  Widget buildButton(BuildContext context, LoginProvider provider) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        side: const BorderSide(width: 2, color: Colors.indigo),
      ),
      onPressed: provider.isAnimating
          ? () {
              log('Test 1');
              if (provider.formKey.currentState!.validate()) {
                try {
                  provider.setAnimating(true); // Set animasi mulai
                  provider.login(
                    context,
                  );
                  // provider.setAnimating(false); // Set animasi selesai
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              } else {
                provider.setAnimating(false); // Pastikan di-reset
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mohon isi semua form'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          : () async {
              // await provider.addas();
              log('Test 2');
              if (provider.formKey.currentState!.validate()) {
                try {
                  provider.setAnimating(true); // Set animasi mulai
                  provider.login(
                    context,
                  );
                  provider.setAnimating(true); // Set animasi selesai
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              } else {
                provider.setAnimating(false); // Pastikan di-reset
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mohon isi semua form'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
      child: const FittedBox(
        child: Text(
          'SUBMIT',
          style: TextStyle(
            fontSize: 24,
            color: Colors.indigo,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildSmallButton(bool isDone, bool isError) {
    final color = isDone
        ? Colors.green
        : isError
            ? Colors.red
            : Colors.indigo;

    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(
        child: isDone
            ? const Icon(
                Icons.done,
                size: 52,
                color: Colors.white,
              )
            : isError
                ? const Icon(
                    Icons.error_outline_rounded,
                    size: 52,
                    color: Colors.white,
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
      ),
    );
  }
}

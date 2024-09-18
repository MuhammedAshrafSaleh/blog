import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/common/widgets/snakebar.dart';
import 'package:blog_app/core/constants/app_strings.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/singup.dart';
import 'package:blog_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:blog_app/features/blog/presentaion/pages/blog_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_gradient_btn.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailureState) {
              if (kDebugMode) {
                print(state.message);
              }
              showSnackBar(context: context, content: state.message);
            } else if (state is AuthSuccessState) {
              Navigator.pushReplacement(context, BlogPage.route());
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Loader(
                color1: AppColors.gradient1,
                color2: AppColors.gradient2,
              );
            }
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    AppStrings.signIn,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    hasIcon: false,
                    keyboardType: TextInputType.text,
                    controller: emailController,
                    text: AppStrings.email,
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    hasIcon: false,
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    text: AppStrings.password,
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomGradientBtn(
                    buttonText: AppStrings.signIn,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthLogin(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, SingUpPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.dontHaveAccount,
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: AppStrings.signUp,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/common/widgets/snakebar.dart';
import 'package:blog_app/core/constants/app_strings.dart';
import 'package:blog_app/core/theme/app_colors.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin.dart';
import 'package:blog_app/features/auth/presentation/widgets/custom_gradient_btn.dart';
import 'package:blog_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SingUpPage());
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final nameController = TextEditingController();
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
              showSnackBar(context: context, content: state.message);
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
                    AppStrings.signUp,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    hasIcon: false,
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    text: AppStrings.name,
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
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
                    hasIcon: true,
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    text: AppStrings.password,
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomGradientBtn(
                    buttonText: AppStrings.signUp,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthSignUp(
                                name: nameController.text.trim(),
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
                      Navigator.push(context, SignInPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.aleardyHaveAnAccount,
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: AppStrings.signIn,
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

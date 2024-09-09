import 'package:blog_app/core/theme/app_theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // final supabase = await Supabase.initialize(
  //   anonKey: AppSecrets.supabaseAnonKey,
  //   url: AppSecrets.supabaseUrl,
  // );
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SignInPage(),
    );
  }
}

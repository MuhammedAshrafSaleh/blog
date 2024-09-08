import 'package:blog_app/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blog_app/core/constants/app_strings.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<String> loginEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRespositoryImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRespositoryImpl({required this.supabaseClient});
  @override
  Future<String> loginEmailPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> signUpEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Learn -> If you sign up with any other data except the email and password add to data map
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {
        'name': name,
      });
      if (response.user == null) {
        throw const ServerException(message: AppStrings.userIsNull);
      }
      return response.user!.id;
    } catch (e) {
      throw  ServerException(message: e.toString());
    }
  }
}

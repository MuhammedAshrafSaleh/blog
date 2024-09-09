import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUpUsecase _userSignUpUsecase;
  AuthBloc({required UserSignUpUsecase userSignUpUsecase})
      : _userSignUpUsecase = userSignUpUsecase,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoadingState());
      final response = await _userSignUpUsecase(UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ));
      response.fold(
        (failureReponse) =>
            emit(AuthFailureState(message: failureReponse.message)),
        (user) => emit(AuthSuccessState(user: user)),
      );
    });
  }
}

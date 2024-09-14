import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUpUsecase _userSignUpUsecase;
  final UserLoginUsecase _userLoginUsecase;
  final CurrentUserUsecase _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUpUsecase userSignUpUsecase,
    required UserLoginUsecase userLoginUsecase,
    required CurrentUserUsecase currentUser,
    required AppUserCubit appUserCubit,
  })  : _currentUser = currentUser,
        _userSignUpUsecase = userSignUpUsecase,
        _userLoginUsecase = userLoginUsecase,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    //TODO: Very Important: on any event that triggered call the onAuthEvent
    on<AuthEvent>((_, emit) => emit(AuthLoadingState()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    // emit(AuthLoadingState());
    final response = await _userSignUpUsecase(UserSignUpParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));
    response.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    // emit(AuthLoadingState());
    final response = await _userLoginUsecase(
      UserLoginParameters(email: event.email, password: event.password),
    );
    response.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (User user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthIsUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    // emit(AuthLoadingState());
    final response = await _currentUser(NoParams());
    response.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (User user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccessState(user: user));
  }
}

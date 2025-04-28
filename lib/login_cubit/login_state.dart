abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final dynamic userData;
  LoginSuccess(this.userData);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

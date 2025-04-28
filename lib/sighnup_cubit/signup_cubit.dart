import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> signup(String email, String password) async {
    emit(SignupLoading());
    try {
      // TODO: Implement actual signup API call
      await Future.delayed(const Duration(seconds: 1));
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}

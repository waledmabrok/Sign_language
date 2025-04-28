import 'package:flutter_application/network/apiService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final Apiservice apiService = Apiservice();
  void login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await apiService.post("login", {
        "email": email,
        "password": password,
      });

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // حفظ كل البيانات
        await prefs.setString(
            'access_token', response.data['access_token'] ?? '');
        await prefs.setString('token_type', response.data['token_type'] ?? '');

        var user = response.data['user'];
        await prefs.setInt('user_id', user['id'] ?? 0);
        await prefs.setString('user_name', user['name'] ?? '');
        await prefs.setString('user_email', user['email'] ?? '');
        await prefs.setString('user_avatar', user['avatar'] ?? '');
        await prefs.setString('user_profile', user['profile'] ?? '');

        // اطبع كل حاجة بعد التخزين للتأكيد
        print("Saved Access Token: ${prefs.getString('access_token')}");
        print("Saved Token Type: ${prefs.getString('token_type')}");
        print("Saved User ID: ${prefs.getInt('user_id')}");
        print("Saved User Name: ${prefs.getString('user_name')}");
        print("Saved User Email: ${prefs.getString('user_email')}");
        print("Saved User Avatar: ${prefs.getString('user_avatar')}");
        print("Saved User Profile: ${prefs.getString('user_profile')}");

        emit(LoginSuccess(response.data));
      } else {
        emit(LoginFailure(
            "Login failed: ${response.data['message'] ?? 'Unknown error'}"));
      }
    } catch (e) {
      print("Login error: $e");
      emit(LoginFailure("Exception: $e"));
    }
  }
}

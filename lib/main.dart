import 'package:flutter/material.dart';
import 'package:flutter_application/screens/communication_page.dart';
import 'package:flutter_application/screens/edit_profile.dart';
import 'package:flutter_application/screens/forget_password.dart';
import 'package:flutter_application/screens/videoCall.dart';
import 'package:flutter_application/screens/login_page.dart';
import 'package:flutter_application/screens/profilescreen.dart';
import 'package:flutter_application/screens/signup_page.dart';
import 'package:flutter_application/screens/welcome1.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/screens/signlanguage_model.dart';

import 'login_cubit/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  const SignLanguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color(0xffE9E9E9),
          primaryColor: const Color(0xff0051FF), // اللون الأساسي للتطبيق
          hintColor: const Color(0xffFF6F00), // اللون المساعد
          buttonTheme: ButtonThemeData(
            buttonColor: const Color(0xff0051FF), // لون الأزرار
            textTheme: ButtonTextTheme.primary, // نص الأزرار
          ),
          appBarTheme: AppBarTheme(
            color: const Color(0xff0051FF), // لون الـ AppBar
            elevation: 0, // إلغاء الظل
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(
                color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
            bodyMedium:
                TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 16),
            labelLarge: TextStyle(color: Colors.white), // لون النص في الأزرار
          ),
          iconTheme: IconThemeData(
            color: Colors.black, // لون الأيقونات
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white, // خلفية الحقول النصية
            filled: true,
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color(0xffE9E9E9)), // لون الحدود
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // لون المؤشر الأزرق
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: const Color(0xff0051FF), // لون المؤشر الأزرق
            selectionColor:
                const Color(0xff0051FF).withOpacity(0.4), // لون النسخ
            selectionHandleColor:
                const Color(0xff0051FF), // لون اليد عند التحديد
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xff0051FF), // لون الزر العائم
          ),
          dividerTheme: DividerThemeData(
            color: Colors.grey.withOpacity(0.5), // لون الخطوط
            thickness: 1, // سمك الخطوط
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}

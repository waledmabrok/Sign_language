import 'package:flutter/material.dart';
import 'package:flutter_application/login_cubit/login_cubit.dart';
import 'package:flutter_application/screens/forget_password.dart';
import 'package:flutter_application/screens/videoCall.dart';
import 'package:flutter_application/screens/signup_page.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import '../constant/MainColors.dart';
import '../constant/SnacBar.dart' show showCustomSnackBar;
import '../login_cubit/login_state.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      appBar: AppBar(
        toolbarHeight: 30,
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        elevation: 0,
        backgroundColor: const Color(0xFFE8E8E8),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null, // لا تعرض الزر إذا لم يكن هناك صفحة خلفية
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Hand Dialogue',
                  style: TextStyle(
                    color: Color(0xff0051FF),
                    fontSize: 24,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                  child: Image.asset(
                "assets/images/signin.png",
                width: double.infinity,
              )),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your Account',
                  style: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: emailcontroller,
                hintText: 'Email',
                icon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xff939393),
                ),
                borderRadius: 8,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordcontroller,
                hintText: 'Password',
                icon: const Icon(
                  Icons.visibility_off_outlined,
                  color: Color(0xff939393),
                ),
                borderRadius: 8,
                isPassword: true,
                isReadOnly: false,
              ),
              const SizedBox(height: 16),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPassword()));
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Forget Password',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xff0051FF),
                          fontSize: 12,
                          color: Color(0xff0051FF),
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              const SizedBox(height: 24),
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else if (state is LoginFailure) {
                    showCustomSnackBar(context,
                        icon: Icons.error_outline,
                        message: 'Erorr !',
                        backgroundColor: Colors.red);
                  }
                },
                builder: (context, state) {
                  return state is LoginLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colorss.mainColor,
                        ))
                      : ElevatedButton(
                          onPressed: () {    if (emailcontroller.text.isEmpty) {
                            showCustomSnackBar(
                              context,
                              message: "Please enter your email.",
                              backgroundColor: Colors.red,
                            );
                            return;
                          }

                          if (passwordcontroller.text.isEmpty) {
                            showCustomSnackBar(
                              context,
                              message: "Please enter a password.",
                              backgroundColor: Colors.red,
                            );
                            return;
                          }
                          if (!EmailValidator.validate(emailcontroller.text)) {
                            showCustomSnackBar(
                              context,
                              message: 'Please enter a valid email address.',
                              backgroundColor: Colors.red,
                            );
                            return;
                          }
                          BlocProvider.of<LoginCubit>(context).login(
                              emailcontroller.text,
                              passwordcontroller.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0051FF),
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(double.infinity, 47),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                color: Color(0xffE9E9E9),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account?  ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage()));
                      // ✅ تصحيح المسار إلى صفحة التسجيل
                    },
                    child: const Text(
                      ' Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff0051FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

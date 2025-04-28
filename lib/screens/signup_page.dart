import 'package:flutter/material.dart';
import 'package:flutter_application/screens/videoCall.dart';
import 'package:flutter_application/screens/login_page.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';
import '../constant/SnacBar.dart';
import '../constant/api_service.dart';
import 'home_page.dart';
import 'package:email_validator/email_validator.dart';
import '../constant/MainColors.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          elevation: 0,
          backgroundColor: const Color(0xFFE8E8E8),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
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
                  Center(child: Image.asset("assets/images/signup.png")),
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'CrimsonText',
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: emailcontroller,
                    hintText: 'Email',
                    icon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xff939393),
                    ),
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: passwordcontroller,
                    hintText: 'Password',
                    icon: const Icon(
                      Icons.visibility_off,
                      color: Color(0xff939393),
                    ),
                    borderRadius: 8,
                    isReadOnly: false,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: confirmpasswordcontroller,
                    hintText: 'Confirm password',
                    icon: const Icon(
                      Icons.visibility_off,
                      color: Color(0xff939393),
                    ),
                    borderRadius: 8,
                    isReadOnly: false,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
           isLoading
          ? const Center(
          child: CircularProgressIndicator(
          color: Colorss.mainColor,
          ))
            : ElevatedButton(
                    onPressed: () async {  setState(() {
                      isLoading = true; // Set loading to true when the button is pressed
                    });
                      if (emailcontroller.text.isEmpty) {setState(() {
                        isLoading = false; // Stop loading if validation fails
                      });
                      showCustomSnackBar(
                        context,
                        message: "Please enter your email.",
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    if (passwordcontroller.text.isEmpty) {setState(() {
                      isLoading = false; // Stop loading if validation fails
                    });
                      showCustomSnackBar(
                        context,
                        message: "Please enter a password.",
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    if (confirmpasswordcontroller.text.isEmpty) {setState(() {
                      isLoading = false; // Stop loading if validation fails
                    });
                      showCustomSnackBar(
                        context,
                        message: "Please confirm your password.",
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                      if (passwordcontroller.text !=
                          confirmpasswordcontroller.text) {setState(() {
                        isLoading = false; // Stop loading if validation fails
                      });
                        showCustomSnackBar(
                          context,
                          message: "Passwords do not match",
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
// داخل الدالة onPressed
                      if (!EmailValidator.validate(emailcontroller.text)) {setState(() {
                        isLoading = false; // Stop loading if validation fails
                      });
                        showCustomSnackBar(
                          context,
                          message: 'Please enter a valid email address.',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      var result = await ApiService.register(
                        email: emailcontroller.text,
                        password: passwordcontroller.text,
                        passwordConfirmation: confirmpasswordcontroller.text,
                      );

                      if (result['error'] == true) {
                        // هنا يمكن التحقق من تفاصيل الخطأ بدقة
                        if (result['message'] ==
                            'The email has already been taken.') {
                          showCustomSnackBar(
                            context,
                            icon: Icons.error_outline,
                            message: 'Email is already taken.',
                            backgroundColor: Colors.red,
                          );
                        } else {
                          print(result);
                          // إذا كانت هناك أخطاء أخرى
                          showCustomSnackBar(
                            context,
                            icon: Icons.error_outline,
                            message: 'Email is already taken.' ??
                                'An unknown error occurred.',
                            backgroundColor: Colors.red,
                          );
                        }
                      } else {
                        // في حال النجاح، يمكنك حفظ التوكن أو التنقل للصفحة الرئيسية
                        showCustomSnackBar(
                          context,
                          icon: Icons.check_circle,
                          message: 'User created successfully!',
                          backgroundColor: Colors.green,
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0051FF),
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 47),
                    ),
                    child: const Text("Sign Up",
                        style: TextStyle(
                            color: Color(0xffE9E9E9),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account   ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: const Text(
                          ' Sign In',
                          style: TextStyle(
                            color: Color(0xff0051FF),
                            fontSize: 16,
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
        ));
  }
}

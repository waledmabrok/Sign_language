import 'package:flutter/material.dart';
import 'package:flutter_application/screens/login_page.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';

import '../constant/SnacBar.dart';
import '../constant/api_service.dart';

class CreatePassword extends StatefulWidget {
  final String otpCode;

  const CreatePassword({super.key, required this.otpCode});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
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
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Create Password',
                style: TextStyle(
                  fontFamily: 'CrimsonText',
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: passwordController,
              hintText: 'New Password',
              icon: const Icon(
                Icons.visibility_off,
                color: Color(0xff939393),
              ),
              borderRadius: 8,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: ' Confirm Password',
              icon: const Icon(
                Icons.visibility_off,
                color: Color(0xff939393),
              ),
              borderRadius: 8,
            ),
            const SizedBox(height: 20),
            isLoading
                ? Center(
                    child: const CircularProgressIndicator(
                        color: Color(0xff0051FF)),
                  ) // عرض مؤشر التحميل
                : ElevatedButton(
                    onPressed: () async {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        // تحقق من تطابق كلمة المرور
                        showCustomSnackBar(context,
                            icon: Icons.error,
                            message: 'Passwords do not match',
                            backgroundColor: Colors.yellow);
                        return;
                      }
                      setState(() {
                        isLoading = true; // تفعيل حالة التحميل
                      });
                      final response = await ApiService.resetPassword(
                        code: widget
                            .otpCode, // استخدم الكود المرسل من صفحة VerifyPage
                        password: passwordController.text,
                        passwordConfirmation: confirmPasswordController.text,
                      );
                      setState(() {
                        isLoading = false; // إيقاف حالة التحميل بعد استلام الرد
                      });
                      if (response['error'] == true) {
                        showCustomSnackBar(context,
                            icon: Icons.error,
                            message: "erorr code is valid",
                            backgroundColor: Colors.red);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } // ✅ تصحيح المسار إلى صفحة التسجيل
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0051FF),
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),

                        // ✅ استدارة الزر
                      ),
                      minimumSize: const Size(double.infinity, 10),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          color: Color(0xffE9E9E9),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      // ✅ تغيير النص ليعبر عن الانتقال إلى التسجيل
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

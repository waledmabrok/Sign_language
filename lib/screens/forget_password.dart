import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';
import 'package:flutter_application/screens/verify_page.dart';

import '../constant/SnacBar.dart';
import '../constant/api_service.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailcontroller = TextEditingController();

  bool isLoading = false;

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
      body: Padding(
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 42),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forget Password',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'CrimsonText',
                    ),
                  ),
                  const SizedBox(height: 8), // إضافة مسافة بين النصين
                  const Text(
                    'Please enter your email address to receive a verification code.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff939393),
                      fontFamily: 'CrimsonText',
                    ),
                  ),
                  const SizedBox(height: 20),
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

                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Color(0xff0051FF),
                        ))
                      : ElevatedButton(
                          onPressed: isLoading
                              ? null // تعطيل الزر أثناء التحميل
                              : () async {
                                  setState(() {
                                    isLoading = true; // تفعيل حالة التحميل
                                  });

                                  final email = emailcontroller.text.trim();

                                  if (email.isEmpty) {
                                    showCustomSnackBar(
                                      context,
                                      message:
                                          'Please enter your email address',
                                      backgroundColor: Colors.red,
                                      icon: Icons.error_outline,
                                    );
                                    setState(() {
                                      isLoading =
                                          false; // إيقاف التحميل بعد الخطأ
                                    });
                                    return;
                                  }

                                  final data =
                                      await ApiService.forgotPassword(email);

                                  setState(() {
                                    isLoading =
                                        false; // إيقاف التحميل بعد استلام الرد
                                  });

                                  if (data['error'] == true) {
                                    // التحقق من وجود رسالة أخطاء
                                    if (data['errors'] != null &&
                                        data['errors']['email'] != null) {
                                      // عرض الأخطاء المتعلقة بالبريد الإلكتروني
                                      showCustomSnackBar(
                                        context,
                                        message: data['errors']['email'][
                                            0], // عرض أول خطأ في البريد الإلكتروني
                                        backgroundColor: Colors.red,
                                        icon: Icons.error_outline,
                                      );
                                    } else {
                                      // في حالة وجود خطأ عام
                                      String message = data['message'];
                                      if (message.length > 100) {
                                        message =
                                            "The selected email is invalid."; // تقليص الرسالة
                                      }
                                      showCustomSnackBar(
                                        context,
                                        message: message,
                                        backgroundColor: Colors.red,
                                        icon: Icons.error_outline,
                                      );
                                    }
                                  } else {
                                    // التحقق من إرسال رمز التحقق بنجاح
                                    String message = data['message'];
                                    if (message ==
                                            "تم إرسال رمز التحقق إلى بريدك الإلكتروني" ||
                                        message ==
                                            "Verification code sent to your email") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VerifyPage()),
                                      );
                                    } else {
                                      if (message.length > 100) {
                                        message =
                                            "The selected email is invalid."; // تقليص الرسالة
                                      }
                                      showCustomSnackBar(
                                        context,
                                        message: message ??
                                            'An unexpected error occurred',
                                        backgroundColor: Colors.orange,
                                        icon: Icons.warning_amber_rounded,
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLoading
                                ? Colors.transparent
                                : const Color(
                                    0xff0051FF), // خلفية شفافة أثناء التحميل
                            side: BorderSide(
                                color: const Color(
                                    0xff0051FF)), // يمكنك إضافة حدود حول الزر إذا رغبت
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(double.infinity, 10),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2, // تعديل سمك المؤشر إذا رغبت
                                )
                              : const Text(
                                  'Send',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffE9E9E9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

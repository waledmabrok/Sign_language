import 'package:flutter/material.dart';
import 'package:flutter_application/screens/create_password.dart';
import 'package:flutter_application/screens/forget_password.dart';
import 'package:pinput/pinput.dart'; // استيراد مكتبة Pinput
import 'package:flutter_application/network/apiService.dart';

import '../constant/SnacBar.dart';
import '../constant/api_service.dart'; // استيراد ApiService

class VerifyPage extends StatefulWidget {
  final String email;
  const VerifyPage({super.key, required this.email});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false; // حالة التحميل
  bool isOtpValid = false;
  // دالة للتحقق من OTP
  void verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      // إذا كان OTP فارغاً، عرض رسالة خطأ
      showCustomSnackBar(context,
          message: 'Please enter the OTP',
          backgroundColor: Colors.red,
          icon: Icons.error_outline);
      setState(() {
        isLoading = false;
      });
      return;
    }

    final data = await ApiService.verifyOtp(otp);

    setState(() {
      isLoading = false;
    });

    if (data['error'] == true) {
      showCustomSnackBar(
        context,
        message: "الكود خطأ أو انتهت صلاحيته" ?? 'An unexpected error occurred',
        backgroundColor: Colors.red,
        icon: Icons.error_outline,
      );
    } else {
      // إذا تم التحقق بنجاح
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePassword(
                otpCode: otp)), // الانتقال إلى صفحة إنشاء كلمة المرور
      );
    }
  }

  void resendOtp() async {
    setState(() {
      isLoading = true;
    });

    final data =
        await ApiService.resendOtp(email: widget.email); // نرسل الإيميل

    setState(() {
      isLoading = false;
    });

    if (data['error'] == true) {
      showCustomSnackBar(
        context,
        message: data['message'] ?? 'An unexpected error occurred',
        backgroundColor: Colors.red,
        icon: Icons.error_outline,
      );
    } else {
      showCustomSnackBar(
        context,
        message: data['message'] ?? 'A new code has been sent to your email',
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
    }
  }

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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'CrimsonText',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter your verification code',
              style: TextStyle(
                fontFamily: 'CrimsonText',
                fontSize: 16,
                color: Color(0xff939393),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Pinput(
                controller: _otpController,
                length: 4, // عدد الخانات
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // لون الخلفية
                    borderRadius: BorderRadius.circular(30), // جعل الشكل دائري
                    border: Border.all(color: Colors.black), // لون الحدود
                  ),
                ),
                onChanged: (otp) {
                  // تحقق إذا كان عدد الخانات المدخلة هو 4
                  setState(() {
                    isOtpValid = otp.length == 4;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'If you don’t receive a code, ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: resendOtp,
                  child: const Text(
                    'Resend ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff0051FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? Center(
                    child: const CircularProgressIndicator(
                        color: Color(0xff0051FF)),
                  ) // عرض مؤشر التحميل
                : ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : verifyOtp, // تعطيل الزر أثناء التحميل
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0051FF),
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 10),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white) // عرض مؤشر التحميل
                        : const Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}

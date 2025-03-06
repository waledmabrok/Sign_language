import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Hand Dialogue',
                style: TextStyle(
                  color: Color(0xff0051FF),
                  fontSize: 35,
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.bold,
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
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Text('Email'),
                        Spacer(),
                        Icon(Icons.email, color: Color(0xff939393)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          '/verify'); // ✅ تصحيح المسار إلى صفحة التسجيل
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                        "Send"), // ✅ تغيير النص ليعبر عن الانتقال إلى التسجيل
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

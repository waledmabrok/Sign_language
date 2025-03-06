import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, //  يجعل النصوص على الشمال
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
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment
                  .centerLeft, //  يضمن أن النص يكون على الشمال حتى لو داخل عنصر أوسع
              child: Text(
                'Login to your Account',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Container contain the Text [Email] and Icon[Email];

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white, // ✅ لون الخلفية
                borderRadius: BorderRadius.circular(10), // ✅ استدارة الحواف
              ),
              child: const Row(
                children: [
                  Text('Email'),
                  Spacer(),
                  Icon(Icons.email, color: Color(0xff939393)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Container contain the Text password and Icon hidden password ;
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white, // ✅ لون الخلفية
                borderRadius: BorderRadius.circular(10), // ✅ استدارة الحواف
              ),
              child: const Row(
                children: [
                  Text('Password'),
                  Spacer(),
                  Icon(Icons.visibility_off, color: Color(0xff939393)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white, // ✅ لون الخلفية
                borderRadius: BorderRadius.circular(10), // ✅ استدارة الحواف
              ),
              child: const Row(
                children: [
                  Text('Confirm Password'),
                  Spacer(),
                  Icon(Icons.visibility_off, color: Color(0xff939393)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Sign In"),
            ),
            Expanded(
              child: Divider(
                color: Colors.black,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
            ),
            Text(
              'Or',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

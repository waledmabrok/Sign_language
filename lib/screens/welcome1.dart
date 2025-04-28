import 'package:flutter/material.dart';
import 'package:flutter_application/screens/welcome2.dart';
// ✅ استبدل بمسار صفحتك الثانية

class Welcome1 extends StatefulWidget {
  const Welcome1({super.key});

  @override
  _Welcome1State createState() => _Welcome1State();
}

class _Welcome1State extends State<Welcome1> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Welcome2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0051FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ توسيط عمودي
          crossAxisAlignment: CrossAxisAlignment.center, // ✅ توسيط أفقي
          children: [
            Image.asset(
              'assets/images/Splash.png',
              width: 200,
              height: 250,
            ),
          ],
        ),
      ),
    );
  }
}

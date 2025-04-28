import 'package:flutter/material.dart';
import 'package:flutter_application/screens/login_page.dart';

class Welcome4 extends StatelessWidget {
  const Welcome4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 30,
        elevation: 0,
        backgroundColor: Colors.white,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ مسافة من الأعلى
          const Text(
            'Hand Dialogue',
            style: TextStyle(
              color: Color(0xff0051FF),
              fontSize: 24,
              fontFamily: 'Pacifico', // ✅ تأكد أن اسم الخط صحيح
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Center(
              // ✅ يجعل الصورة في منتصف الشاشة تمامًا
              child: Image.asset(
                'assets/images/Frame 494.png',
                width: 400,
                height: 500,
              ),
            ),
          ),
          const SizedBox(height: 30), // ✅ مسافة بين الصورة والنقاط

          // ✅ نقاط التنقل بين الصفحات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIndicator(isActive: false), //  الصفحة الأولى غير نشطة
              buildIndicator(isActive: false), //  الصفحة الثانية غير نشطة
              buildIndicator(isActive: true), //  الصفحة الثالثة نشطة
            ],
          ),

          const SizedBox(height: 20), // ✅ مسافة بين النقاط والزر

          // ✅ زر "Next" بعرض الشاشة بالكامل
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // ✅ مسافة جانبية للزر
            child: SizedBox(
              width: double.infinity, // ✅ يجعل الزر يأخذ العرض بالكامل
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage()), // ✅ تأكد من استخدام `LoginPage`
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0051FF), // ✅ لون الزر
                  padding: const EdgeInsets.symmetric(
                      vertical: 15), // ✅ يجعل الزر أطول قليلًا
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // ✅ استدارة الزر
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40), // ✅ مسافة من الأسفل
        ],
      ),
    );
  }
}

// ✅ دالة إنشاء نقاط التنقل
Widget buildIndicator({required bool isActive}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    width: isActive ? 12 : 8,
    height: isActive ? 12 : 8,
    decoration: BoxDecoration(
      color: isActive ? const Color(0xff0051FF) : Colors.grey,
      shape: BoxShape.circle,
    ),
  );
}

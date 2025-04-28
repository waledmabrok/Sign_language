import 'package:flutter/material.dart';
import 'package:flutter_application/screens/welcome4.dart';
// ✅ استدعاء الصفحة الرابعة

class Welcome3 extends StatelessWidget {
  const Welcome3({super.key});

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
              fontFamily: 'Pacifico', // ✅ تأكد من أن اسم الخط مكتوب بشكل صحيح
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Center(
              // ✅ يجعل الصورة في منتصف الشاشة
              child: Image.asset(
                'assets/images/Frame2.png',
                width: 400,
                height: 400,
              ),
            ),
          ),
          const SizedBox(height: 30), // ✅ مسافة بين الصورة والنقاط

          // ✅ نقاط التنقل بين الصفحات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIndicator(isActive: false), // ❌ الصفحة الأولى غير نشطة
              buildIndicator(isActive: true), // ✅ الصفحة الحالية نشطة
              buildIndicator(isActive: false), // ❌ الصفحة الثالثة غير نشطة
            ],
          ),

          const SizedBox(height: 20), // ✅ مسافة بين النقاط والزر

          // ✅ زر "Next"
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // ✅ مسافة جانبية للزر
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Welcome4()), // ✅ الانتقال إلى الصفحة الرابعة
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0051FF), // ✅ لون الزر
                padding: const EdgeInsets.symmetric(
                    vertical: 15), // ✅ يجعل الزر أطول قليلًا
                minimumSize: const Size(double.infinity,
                    50), // ✅ جعل الزر بعرض الشاشة بدون `SizedBox`
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application/screens/edit_profile.dart';
import 'package:flutter_application/screens/login_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? '';
      userEmail = prefs.getString('user_email') ?? '';
      String? imagePath = prefs.getString('profile_image'); // جلب مسار الصورة
      if (imagePath != null) {
        _profileImage = File(imagePath); // تحميل الصورة إذا كانت موجودة
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      uploadAvatar(image); // ارسال الصورة للسيرفر
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profile_image', pickedFile.path); // حفظ المسار في SharedPreferences
      setState(() {
        _profileImage = image; // تحديث الصورة في الواجهة
      });
    } else {
      print('No image selected.');
    }
  }

  void uploadAvatar(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      print('No token found');
      return;
    }

    var result = await ApiService.updateAvatar(token: token, avatar: image);

    if (result['error'] == true) {
      print('Error uploading avatar: ${result['message']}');

    } else {
      print('Avatar uploaded successfully: $result');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // صورة اليدين في الأعلى
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/Rectangle 49.png', // صورة اليدين
                height: 150,
                fit: BoxFit.fitWidth,
              ),
            ),

            // محتوى الشاشة
            Column(
              children: [
                const SizedBox(height: 120),

                // صورة البروفايل + زر تعديل
                Stack(
                  alignment: Alignment.center,
                  children: [
                   CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          :  AssetImage('assets/images/Rectangle 6.png'),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage, // لما يضغط على القلم يفتح المعرض
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.edit, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 16),

                // الاسم والإيميل
                Text(
                  userName.isNotEmpty ? userName : ' Puerto Rico',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail.isNotEmpty ? userEmail : 'youremail@domain.com',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 30),

                // زرارين داخل مستطيل أبيض
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    // تحديد العرض
                    height: 121, // تحديد الارتفاع
                    decoration: BoxDecoration(
                      color: Colors.white, // خلفية بيضاء
                      borderRadius: BorderRadius.circular(8), // زوايا دائرية
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25), // تأثير الظل
                          blurRadius: 4, // شدة الضباب
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // أول ListTile
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/navbar/editProfile.svg', // المسار إلى ملف الـ SVG
                            width: 24, // تحديد العرض
                            height: 24, // تحديد الارتفاع
                            color: Colors.black, // تحديد لون الأيقونة
                          ),
                          title: const Text(
                            'Edit profile information',
                            style: TextStyle(
                              fontFamily: 'Roboto', // استخدام الخط المناسب
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          /*       trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),*/
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfile(),
                              ),
                            );
                            // تعديل البيانات
                          },
                        ),
                        /*   const Divider(height: 1),*/
                        // ثاني ListTile
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/navbar/Logout.svg', // المسار إلى ملف الـ SVG
                            width: 24, // تحديد العرض
                            height: 24, // تحديد الارتفاع
                            color: Colors.black, // تحديد لون الأيقونة
                          ),
                          title: const Text(
                            'Log Out',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          /*    trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),*/
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                            // تسجيل الخروج
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

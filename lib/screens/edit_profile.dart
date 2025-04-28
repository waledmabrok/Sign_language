import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // مهم
import 'package:shimmer/shimmer.dart';
import '../constant/Custom_textField_profile.dart';
import '../constant/SnacBar.dart';
import '../constant/api_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();
  final countryController = TextEditingController();
  final genderController = TextEditingController();

  String? _token;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _updateProfile() async {
    if (_token == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.updateProfile(
        token: _token!,
        fullName: nameController.text,
        phone: phoneController.text,
        birthday: birthdayController.text,
        country: countryController.text,
        gender: genderController.text,
        avatar: null, // حالياً بدون صورة
      );

      if (response['error'] == true) {
        showCustomSnackBar(context,
            icon: Icons.error_outline,
            message: 'Error updating profile',
            backgroundColor: Colors.red);
      } else {
        // ✅ هنا نحفظ المعلومات الجديدة في SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', nameController.text);
        await prefs.setString('user_email', emailController.text);
        await prefs.setString('user_phone', phoneController.text);
        await prefs.setString('user_birthday', birthdayController.text);
        await prefs.setString('user_country', countryController.text);
        await prefs.setString('user_gender', genderController.text);

        // تأكيد حفظ البيانات
        print("Updated User Name: ${prefs.getString('user_name')}");
        print("Updated User Email: ${prefs.getString('user_email')}");
        print("Updated User Phone: ${prefs.getString('user_phone')}");
        print("Updated User Birthday: ${prefs.getString('user_birthday')}");
        print("Updated User Country: ${prefs.getString('user_country')}");
        print("Updated User Gender: ${prefs.getString('user_gender')}");

        showCustomSnackBar(context,
            icon: Icons.check_circle,
            message: 'Profile updated successfully',
            backgroundColor: Colors.green);
        Navigator.pop(context); // ترجع وخلصنا
      }
    } catch (e) {
      print('Error updating profile: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token =
          prefs.getString('access_token'); // تأكد من أنك خزنت التوكن بنفس الاسم
    });

    if (_token != null) {
      _getProfileData(); // بعد ما التوكن يوصل روح هات الداتا
    } else {
      print('No token found.');
    }
  }

  Future<void> _getProfileData() async {
    if (_token == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.getProfile(_token!);
      setState(() {
        nameController.text = response['full_name'] ?? '';
        emailController.text = response['email'] ?? '';
        phoneController.text = response['phone'] ?? '';
        birthdayController.text = response['birthday'] ?? '';
        countryController.text = response['country'] ?? '';
        genderController.text = response['gender'] ?? '';
      });
    } catch (e) {
      print('Error getting profile: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? _buildLoadingSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomText(hintText: "Full name", controller: nameController),
                  const SizedBox(height: 24),
                  CustomText(hintText: "Email", controller: emailController),
                  const SizedBox(height: 24),
                  CustomText(
                      hintText: "Phone number", controller: phoneController),
                  const SizedBox(height: 24),
                  CustomText(
                      hintText: "Birthday", controller: birthdayController),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                            hintText: "Country", controller: countryController),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: CustomText(
                            hintText: "Gender", controller: genderController),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0051FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSkeleton(),
          const SizedBox(height: 24),
          _buildSkeleton(),
          const SizedBox(height: 24),
          _buildSkeleton(),
          const SizedBox(height: 24),
          _buildSkeleton(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildSkeleton()),
              const SizedBox(width: 17),
              Expanded(child: _buildSkeleton()),
            ],
          ),
          const SizedBox(height: 24),
          _buildSkeletonButton(),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSkeletonButton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

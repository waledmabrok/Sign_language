import 'package:flutter/material.dart';
import 'package:flutter_application/screens/communication_page.dart';
import 'package:flutter_application/screens/profilescreen.dart';

import 'package:flutter_application/screens/signlanguage_model.dart';
import 'package:flutter_application/widgets/custom_container_home.dart';
import 'join_meeting.dart';
import 'schedule_meeting.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home, color: Color(0xFF007BFF)),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person, color: Color(0xFF007BFF)),
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onGalleryButtonPressed() {
    // هنا تحط اللوجيك لما تدوس على زر الجاليري
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignLanguageSlider()),
    );
  }

  void _openGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignLanguageSlider()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: const Color(0xff334E87),
        leading: const SizedBox(),
        title: const Text(
          'Hand Dialogue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: 'Pacifico',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomContainerHome(
                        iconPath: 'assets/navbar/video.svg',
                        text: 'Communication with hand signal',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommunicationPage(
                                title: 'Communication with hand signal',
                              ),
                            ),
                          );
                        },
                      ),
                      CustomContainerHome(
                        iconPath: 'assets/navbar/add.svg',
                        text: 'Join Meeting',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JoinMeeting(
                                title: 'Join Meeting',
                              ),
                            ),
                          );
                        },
                      ),
                      CustomContainerHome(
                        iconPath: 'assets/navbar/calender.svg',
                        text: 'Schedule',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScheduleMeeting(
                                title: 'Schedule Meeting',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xffCDCDCD), thickness: 2),
              ],
            )
          : const ProfileScreen(),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: -10,
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                  iconPath: 'assets/navbar/home-2-svgrepo-com.svg',
                  label: 'Home',
                  index: 0),
              SizedBox(width: 48),
              _buildNavItem(
                  iconPath: 'assets/navbar/profile.svg',
                  label: 'Profile',
                  index: 1),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: _onGalleryButtonPressed,
          backgroundColor: Color(0xFF007BFF),
          elevation: 0,
          shape: CircleBorder(
            side: BorderSide(color: Colors.white, width: 8),
          ),
          child: SvgPicture.asset(
            'assets/navbar/image.svg',
            width: 24,
            height: 24,
            color: Colors.white, // لو عايز تتحكم في اللون لو SVG يدعم التلوين
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(
      {required String iconPath, required String label, required int index}) {
    bool isSelected = _selectedIndex == index;
    return Stack(
      clipBehavior: Clip.none, // لكي تخرج الدائرة خارج حدود الـ Stack
      children: [
        InkWell(
          onTap: () => _onItemTapped(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                color: /*isSelected ? Color(0xFF007BFF) :*/ Color(0xff0C0C0C),
                width: 28,
                height: 28,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: /* isSelected ? Color(0xFF007BFF) :*/ Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
        // دائرة تحت العنصر عند اختياره
        if (isSelected)
          Positioned(
            left: 0, // تعديل المسافة من اليسار حسب الحاجة
            right: 0, // تأكد من أن العنصر يتوسط
            bottom: -27, // المسافة من الأسفل (تأكد من أنها مناسبة)
            child: Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF007BFF),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application/screens/videoCall.dart';
import 'home_page.dart';

class SignLanguageSlider extends StatefulWidget {
  const SignLanguageSlider({super.key});

  @override
  State<SignLanguageSlider> createState() => _SignLanguageSliderState();
}

class _SignLanguageSliderState extends State<SignLanguageSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<String> imagePaths = List.generate(
    26,
    (index) => 'assets/images/image${String.fromCharCode(97 + index)}.png',
  );

  @override
  Widget build(BuildContext context) {
    String currentLetter = String.fromCharCode(65 + _currentIndex); // A-Z

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Text(
              'Detected Sign : $currentLetter',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Inter'),
            ),
            const SizedBox(height: 64),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: imagePaths.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Image.asset(imagePaths[index]),
                    ),
                  );
                },
              ),
            ),
            Text(
              '${_currentIndex + 1}/${imagePaths.length}',
              style: const TextStyle(color: Colors.grey, fontSize: 24),
            ),
            const SizedBox(height: 32),
            Text(
              currentLetter,
              style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Inter'),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.black, width: 1),
                    ),
                    onPressed: () {
                      if (_currentIndex > 0) {
                        _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 48),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    // ignore: sort_child_properties_last
                    child: const Icon(
                      Icons.home,
                      color: Colors.black,
                      size: 48,
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(width: 16),
                  OutlinedButton(
                      onPressed: () {
                        if (_currentIndex < imagePaths.length - 1) {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                      // ignore: sort_child_properties_last
                      child: const Icon(Icons.arrow_forward,
                          color: Colors.black, size: 48),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

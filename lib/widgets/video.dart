import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VideoOnlySelector extends StatefulWidget {
  const VideoOnlySelector({super.key});

  @override
  State<VideoOnlySelector> createState() => _VideoOnlySelectorState();
}

class _VideoOnlySelectorState extends State<VideoOnlySelector> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Video',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xff0051FF) : Colors.black,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    "assets/navbar/video.svg",
                    color: isSelected ? const Color(0xff0051FF) : Colors.black,
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Video',
                style: TextStyle(
                  fontFamily: "Inter",
                  color: isSelected ? const Color(0xff0051FF) : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

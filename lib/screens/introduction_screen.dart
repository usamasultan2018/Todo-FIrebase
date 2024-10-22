import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_todo_app/components/rounded_button.dart';
import 'package:firebase_todo_app/screens/login_screen.dart';
import 'package:firebase_todo_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        // Remove NeverScrollableScrollPhysics() to allow swiping
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center items vertically
              children: [
                const SizedBox(height: 10),
                SvgPicture.asset(
                  "${items[index]["image"]}",
                  height: 300,
                  width: double.maxFinite,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 40),
                Center(
                  child: DotsIndicator(
                    dotsCount: items.length,
                    position: _currentIndex,
                    decorator: DotsDecorator(
                      color: Colors.blueAccent,
                      size: const Size.square(8.0),
                      activeSize: const Size(20.0, 8.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      activeColor: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 37),
                Text(
                  "${items[index]["title"]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "${items[index]["des"]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                RoundedButton(
                  text: _currentIndex == items.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: () {
                    if (_currentIndex == items.length - 1) {
                      // Handle "Get Started" action
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (ctx) {
                        return LoginScreen();
                      }));
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                    }
                  },
                  // Add style for better visibility (you might want to define this in your RoundedButton component)
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

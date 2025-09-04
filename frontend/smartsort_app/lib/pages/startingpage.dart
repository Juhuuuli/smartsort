import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smartsort_app/pages/home.dart';


/// Splash/starting screen:
/// - Shows branding and a brief message
/// - Triggers a white flash transition
/// - Navigates to [HomePage] after a short delay
class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  /// Controls the brief white "flash" overlay before navigation.
  bool _showFlash = false;

  @override
  void initState() {
    super.initState();


    // Delay, then trigger flash, then navigate.
    // Note: uses nested timers to sequence animation -> navigation.
    // Consider checking `mounted` before `setState`/navigation if timeouts can outlive the widget.
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _showFlash = true;
      });

      Timer(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Small decorative half-circle accent in top-left.
            Positioned(
              top: 8,
              left: 8,
              child: ClipPath(
                clipper: _LeftHalfClipper(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Small rounded bar accent in bottom-right.
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                width: 28,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Centered content: logo + tagline.
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical:40),
                child: SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.06),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0), 
                      child: const Text(
                        'smartsort',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0), 
                      child: const Text(
                        'thank you for making the world a better place.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 87, 85, 85),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ),
            ),

            // White flash overlay that fades in before navigation.
            AnimatedOpacity(
              opacity: _showFlash ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// Clips a circle to show only its left half.
class _LeftHalfClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    return Path.combine(
      PathOperation.intersect,
      path,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width / 2, size.height)),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
















import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:smartsort_app/pages/home.dart';
import 'package:smartsort_app/pages/underpage_about_us.dart';
import 'package:smartsort_app/pages/underpage_history.dart';
import 'package:smartsort_app/pages/underpage_motivation.dart';
import 'package:smartsort_app/pages/underpage_wastecategory.dart';

/// Static "How it works" information page.
///
/// Explains the SmartSort process in sequential steps
/// using icons, arrows, and descriptive text.
class UnderpageHowitworks extends StatelessWidget {
  const UnderpageHowitworks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const SizedBox(width: 12),

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'smarts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Image.asset(
              'assets/logo.png',
              height: 30,
            ),
            const Text(
              'rt',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),

        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.menu),
            offset: const Offset(20, 50),
            onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()), 
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UnderpageHistory()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UnderpageAboutUs()),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UnderpageMotivation()), 
                  ); 
                  break;
                case 5:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UnderpageCategories()), 
                  ); 
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Home"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("History"),
              ),
              const PopupMenuItem<int>(
                value: 3, 
                child: Text("About us")
              ),   
              const PopupMenuItem<int>(
                value: 4,
                child: Text("Motivation"),
              ),
              const PopupMenuItem<int>(
                value: 5,
                child: Text("Waste categories"),
              ),
            ],
          ),
        ],
      ),


      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'How it works',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),


              const SizedBox(height: 30),
              _buildStep(
                icon: Icons.camera_enhance_outlined,
                iconColor: Colors.blue.shade400,
                title: 'Image Recognition Model',
                text: 'This app uses a trained computer vision model to identify different types of waste materials – such as plastic, general, and organic waste – from images captured with your phone.',
                isLeftAligned: true,
              ),
              const SizedBox(height: 8),
              _buildArrow(isRightward: true),
              const SizedBox(height: 8),
              _buildStep(
                icon: Icons.fact_check_outlined,
                iconColor: Colors.green.shade400,
                title: 'Scan and Classify',
                text: 'By leveraging image recognition technology, the app analyzes photos of waste items and determines the correct waste category they belong to.',
                isLeftAligned: false,
              ),
              const SizedBox(height: 8),
              _buildArrow(isRightward: false),
              const SizedBox(height: 8),
              _buildStep(
                icon: Icons.category_outlined,
                iconColor: Colors.grey.shade800,
                title: 'Waste Categories',
                text: 'The model has been trained on thousands of real-world images to ensure accurate detection in recycling waste. By using this tool, users are encouraged to sort their waste properly, and more sustainable.',
                isLeftAligned: true,
              ),
              const SizedBox(height: 8),
              _buildArrow(isRightward: true),
              const SizedBox(height: 8),
              _buildStep(
                icon: Icons.task_alt_outlined,
                iconColor: Colors.grey.shade800,
                title: 'Sort smart.',
                text: 'Recycle right. Make a difference.',
                isLeftAligned: false,
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Builds a visual step with:
  /// - an icon
  /// - title
  /// - description
  /// - alignment flipped for alternating left/right layout
  Widget _buildStep({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String text,
    required bool isLeftAligned,
  }) {
    final textDirection = isLeftAligned ? TextDirection.ltr : TextDirection.rtl;
    final crossAxisAlignment = isLeftAligned ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final textAlign = isLeftAligned ? TextAlign.left : TextAlign.right;

    return Row(
      textDirection: textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 45, color: iconColor),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Text(
                title,
                textAlign: textAlign,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                text,
                textAlign: textAlign,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Draws a curved arrow between steps.
  /// The arrow flips direction depending on [isRightward]
  Widget _buildArrow({required bool isRightward}) {
    return Align(
      alignment: isRightward ? Alignment.centerLeft : Alignment.centerRight,
      child: CustomPaint(
        size: const Size(100, 50),
        painter: _ArrowPainter(isRightward: isRightward),
      ),
    );
  }
}

/// Custom painter for drawing a directional curved arrow.
class _ArrowPainter extends CustomPainter {
  final bool isRightward;

  _ArrowPainter({required this.isRightward});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Define start, control, and end points of Bezier curve.
    final Offset startPoint, controlPoint, endPoint;

    if (isRightward) {
      startPoint = Offset(size.width * 0.25, size.height * 0.1);
      controlPoint = Offset(size.width * 0.1, size.height * 0.7);
      endPoint = Offset(size.width * 0.6, size.height * 0.9);
    } else {
      startPoint = Offset(size.width * 0.75, size.height * 0.1);
      controlPoint = Offset(size.width * 0.9, size.height * 0.7);
      endPoint = Offset(size.width * 0.4, size.height * 0.9);
    }

    path.moveTo(startPoint.dx, startPoint.dy);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    final angle = math.atan2(endPoint.dy - controlPoint.dy, endPoint.dx - controlPoint.dx);
    const arrowSize = 11.0;
    const arrowAngle = math.pi / 6;

    final p1 = Offset(
      endPoint.dx - arrowSize * math.cos(angle - arrowAngle),
      endPoint.dy - arrowSize * math.sin(angle - arrowAngle),
    );
    final p2 = Offset(
      endPoint.dx - arrowSize * math.cos(angle + arrowAngle),
      endPoint.dy - arrowSize * math.sin(angle + arrowAngle),
    );

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(endPoint.dx, endPoint.dy);
    path.lineTo(p2.dx, p2.dy);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

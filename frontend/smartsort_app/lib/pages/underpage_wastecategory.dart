import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:smartsort_app/pages/home.dart';
import 'package:smartsort_app/pages/underpage_about_us.dart';
import 'package:smartsort_app/pages/underpage_history.dart';
import 'package:smartsort_app/pages/underpage_howitworks.dart';
import 'package:smartsort_app/pages/underpage_motivation.dart';
/// Domain model for a waste category card (front/back content + styling).
class WasteCategory {
  final String title;
  final String imagePath;
  final String contents;
  final String explanation;
  final Color color;
  final IconData icon;

  WasteCategory({
    required this.title,
    required this.imagePath,
    required this.contents,
    required this.explanation,
    required this.color,
    required this.icon,
  });
}
/// Underpage showing waste categories as horizontally paged, flippable cards.
class UnderpageCategories extends StatefulWidget {
  const UnderpageCategories({super.key});

  @override
  _UnderpageCategoriesState createState() => _UnderpageCategoriesState();
}

class _UnderpageCategoriesState extends State<UnderpageCategories> {
  /// Static catalog of categories displayed in the carousel.
  final List<WasteCategory> _categories = [
    WasteCategory(
      title: 'Recyclable',
      icon: Icons.recycling,
      imagePath: 'assets/recycable_waste.png',
      color: Colors.blue.shade200,
      contents: '• Plastic (bottles, packaging, cups)\n• Aluminum (cans, lids)\n• Paper & cardboard (if clean)\n• Glass',
      explanation: 'These materials can be recycled and are often visually easy to recognize. Grouping them simplifies the sorting process.',
    ),
    WasteCategory(
      title: 'Organic',
      icon: Icons.eco,
      imagePath: 'assets/organic_waste.png',
      color: Colors.green.shade200,
      contents: '• Fruit and vegetable scraps\n• Rice, noodles, bread\n• Eggshells\n• Coffee grounds, tea bags\n',
      explanation: 'Organic waste is compostable and plays a key role in a sustainable circular economy, especially in Thailand.',
    ),
    WasteCategory(
      title: 'General Waste',
      icon: Icons.delete_outline,
      imagePath: 'assets/general_waste.png',
      color: Colors.grey.shade300,
      contents: '• Dirty packaging\n• Styrofoam\n• Cigarette butts, hygiene products\n• Items that are not recyclable',
      explanation: 'This category includes all waste that cannot be sorted into the other groups. It usually has to be incinerated or landfilled.',
    ),
  ];
 /// Controls the paged carousel; viewportFraction shows partial neighbors for depth.
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _currentPage,
    );
     // Track current page to render the dot indicators.
        _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // prevent controller leak
    super.dispose();
  }

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
                    MaterialPageRoute(builder: (_) => const UnderpageHowitworks()), 
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
                child: Text("How it works"),
              ),
            ],
          ),
        ],
      ),

      body: SafeArea(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 30),

      // Page title
      Center(
        child: Column(
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),

      // Category carousel: each page is a flippable card.
      // Use Expanded instead of a fixed-height SizedBox to prevent bottom overflow.
      Expanded(
        child: PageView.builder(
          controller: _pageController,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FlipCard(category: _categories[index]),
            );
          },
        ),
      ),

      // Dot indicators for current page (pagination UI).
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_categories.length, (index) {
          return Container(
            margin: const EdgeInsets.all(4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? Colors.black
                  : Colors.grey.shade300,
            ),
          );
        }),
      ),

      // Bottom note text (removed Spacer to avoid overflow).
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            'Tap on a card to learn more about each category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    ],
  ),
),
    );
  }
}
/// Flippable card with an image front and descriptive back.
/// Uses AnimatedSwitcher with a Y-rotation + slight perspective tilt.
class FlipCard extends StatefulWidget {
  final WasteCategory category;

  const FlipCard({super.key, required this.category});

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _isFlipped = false;

  void _toggleFlip() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
         // Custom 3D flip transition between front/back children.
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: math.pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(_isFlipped) != child?.key);
              var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
              tilt *= isUnder ? -1.0 : 1.0;
              final value = isUnder ? math.min(rotateAnim.value, math.pi / 2) : rotateAnim.value;
              return Transform(
                transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        // Keys tell AnimatedSwitcher which child is which.
        child: _isFlipped
            ? _buildCardFace(key: const ValueKey(true), isFront: false)
            : _buildCardFace(key: const ValueKey(false), isFront: true),
      ),
    );
  }

 /// Builds either the image front or colored-back face of the card.
  Widget _buildCardFace({required Key key, required bool isFront}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
        color: isFront ? Colors.transparent : widget.category.color,
        image: isFront
            ? DecorationImage(
                image: AssetImage(widget.category.imagePath),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: isFront
          ? _buildFrontContent()
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: _buildBackContent(),
            ),
    );
  }

  Widget _buildFrontContent() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withValues(alpha: 0.1), Colors.transparent],
              stops: const [0.0, 0.4],
            ),
          ),
        ),
        Center(
          child: Icon(
            widget.category.icon,
            color: Colors.white,
            size: 90,
            shadows: [
              Shadow(
                blurRadius: 15.0,
                color: Colors.black.withValues(alpha: 0.5),
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.category.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
/// Back face: scrollable details (contents + explanation).
  Widget _buildBackContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            const Text(
              'Contents:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              widget.category.contents,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Explanation:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              widget.category.explanation,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 12),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

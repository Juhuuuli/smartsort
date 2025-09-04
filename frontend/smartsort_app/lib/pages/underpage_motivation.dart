import 'package:flutter/material.dart';
import 'package:smartsort_app/pages/home.dart';
import 'package:smartsort_app/pages/underpage_about_us.dart';
import 'package:smartsort_app/pages/underpage_history.dart';
import 'package:smartsort_app/pages/underpage_howitworks.dart';
import 'package:smartsort_app/pages/underpage_wastecategory.dart';


/// "Motivation" underpage:
/// - Explains mission, vision, and values
/// - Simple static content with light theming and navigation menu
class UnderpageMotivation extends StatelessWidget {
  const UnderpageMotivation({super.key});

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
                    MaterialPageRoute(builder: (_) => const UnderpageHowitworks()), 
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
                child: Text("How it works"),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Motivation',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),


                const SizedBox(height: 40),
                _buildSection(
                  icon: Icons.track_changes,
                  iconColor: Colors.pink[400]!,
                  title: 'MISSION',
                  contentWidget: Text(
                    'Our mission is to make waste separation simple, accessible, and effective for everyone. Using our app, we help users quickly and accurately identify types of waste – thus promoting better recycling habits in everyday life.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _buildSection(
                  icon: Icons.visibility,
                  iconColor: Colors.blue[400]!,
                  title: 'VISION',
                  contentWidget: Text(
                    'We envision a world where sustainable behavior is simple and intuitive, supported by technology. By combining AI with practical tools, we empower individuals to make environmentally conscious decisions – starting with a single photo.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _buildSection(
                  icon: Icons.diamond,
                  iconColor: Colors.green[400]!,
                  title: 'VALUES',
                  contentWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBulletPoint('Simplicity', 'Making waste separation understandable for all'),
                      _buildBulletPoint('Responsibility', 'Encouraging conscious daily actions'),
                      _buildBulletPoint('Impact', 'Supporting global efforts to reduce pollution'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget contentWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(
            icon,
            size: 40,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        contentWidget,
      ],
    );
  }

  Widget _buildBulletPoint(String boldText, String normalText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '$boldText - ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: normalText,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smartsort_app/pages/home.dart';
import 'package:smartsort_app/pages/underpage_about_us.dart';
import 'package:smartsort_app/pages/underpage_howitworks.dart';
import 'package:smartsort_app/pages/underpage_motivation.dart';
import 'package:smartsort_app/pages/underpage_wastecategory.dart';
import 'history_store.dart';

class UnderpageHistory extends StatelessWidget {
  const UnderpageHistory({super.key});

  Color _chipColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'recyclable':
        return Colors.blue.shade100;
      case 'organic':
        return Colors.green.shade100;
      case 'general':
        return Colors.grey.shade300;
      default:
        return Colors.orange.shade100;
    }
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
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Image.asset('assets/logo.png', height: 30),
            const Text(
              'rt',
              style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.menu),
            offset: const Offset(20, 50),
            onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HomePage()));
                  break;
                case 2:
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UnderpageAboutUs()));
                  break;                
                case 3:
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UnderpageMotivation()));
                  break;
                case 4:
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UnderpageHowitworks()));
                  break;
                case 5:
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UnderpageCategories()));
                  break;

              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<int>(value: 1, child: Text("Home")),
              PopupMenuItem<int>(value: 2, child: Text("About us")),  
              PopupMenuItem<int>(value: 3, child: Text("Motivation")),
              PopupMenuItem<int>(value: 4, child: Text("How it works")),
              PopupMenuItem<int>(value: 5, child: Text("Waste categories")),
            ],
          ),
        ],
      ),

      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 30, 16, 8),
            child: Text(
              "History",
              style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: HistoryStore.items.isEmpty
                ? const Center(
                    child: Text("No items yet", style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: HistoryStore.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = HistoryStore.items[index];
                      final heroTag = item.imagePath; 

                      return Card(
                        elevation: 2,
                        shadowColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => _ImagePreview(
                                  tag: heroTag, filePath: item.imagePath),
                                transitionDuration:
                                    const Duration(milliseconds: 250),
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 250),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Hero(
                                  tag: heroTag,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(item.imagePath),
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(width: 30),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _chipColor(item.category),
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.open_in_full, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// full picture shown as soon as image is clicked 
class _ImagePreview extends StatelessWidget {
  final String tag;
  final String filePath;
  const _ImagePreview({required this.tag, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.95),
        body: Center(
          child: Hero(
            tag: tag,
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(filePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

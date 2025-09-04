import 'dart:convert'; 
import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:smartsort_app/pages/underpage_about_us.dart';
import 'package:smartsort_app/pages/underpage_history.dart'; 
import 'package:smartsort_app/pages/underpage_howitworks.dart';
import 'package:smartsort_app/pages/underpage_motivation.dart';
import 'package:smartsort_app/pages/underpage_wastecategory.dart';
import 'package:smartsort_app/pages/history_store.dart';




/// Home page for SmartSort:
/// - Lets users pick images from the gallery
/// - Sends each image to a backend for classification
/// - Allows users to confirm or correct the predicted class
class HomePage extends StatefulWidget { 
  
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  /// Holds all selected images for display + subsequent actions.
  final List<XFile> _images = []; 
  final Map<String, bool> _correctionStates = {}; 
  final Map<String, bool> _submittedStates = {};
  final Map<String, String> _predictions = {}; 


    /// Opens the gallery, allows multi-selection, appends each image,
  /// and sends them to the backend sequentially.
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile>? picked = await picker.pickMultiImage();
      if (picked != null && picked.isNotEmpty) {
        for (var img in picked) {
          _images.add(img);
          await _sendToBackend(img); // send each image directly
        }
        setState(() {}); // refresh UI after all images are added
      }
    } catch (e) {
      print("Error while picking from gallery: $e");
    }
  }

  /// Opens the device camera, takes a single picture,
  /// appends it to the list, and sends it to the backend.
  Future<void> _pickSingleImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        _images.add(photo);
        await _sendToBackend(photo); // send captured image
        setState(() {}); // refresh UI
      }
    } catch (e) {
      print("Error while taking photo with camera: $e");
    }
  }



  /// Sends an image to the prediction endpoint and updates local UI state based on the response.
  ///
  /// Implementation notes:
  /// - Uses 10.0.2.2 to reach the host machine from Android emulator.
  /// - Keys state maps by image.path; this assumes the file remains accessible for the session.
  ///   Consider hashing bytes or generating a stable ID if paths can change.
  Future<void> _sendToBackend(XFile image) async {
    final String backendUrl = 'http://10.0.2.2:8001/predict';
    final uri = Uri.parse(backendUrl);
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        final predictions = decoded['predictions'];
        if (predictions.isEmpty) {
          // No model prediction: fall back to manual labeling and mark as submitted.
          await _sendToManualLabeling(image);
          setState(() {
            _predictions[image.path] = "Unknown";
            _submittedStates[image.path] = true;
            _correctionStates[image.path] = false;
          });
        } else {
          // Use the top prediction returned by the backend.
          final prediction = predictions[0]['class'];
          setState(() {
            _predictions[image.path] = prediction;
            _submittedStates[image.path] = false;
            _correctionStates[image.path] = false;
          });
        }
      } else {
        print("Backend error: ${response.statusCode}");
      }
    } catch (e) {
      print("Fehler beim Senden: $e");
    }
  }
  
/// Confirms the backend's prediction for [image] and records that decision server-side.
/// On success, the image is marked as submitted in the UI.  
Future<void> _sendAgree(XFile image) async {
  final uri = Uri.parse('http://10.0.2.2:8001/submit/agreed');
  final request = http.MultipartRequest('POST', uri);
  request.files.add(await http.MultipartFile.fromPath('file', image.path));
  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final decoded = jsonDecode(responseBody);
      final label = decoded['label'];
      final confidence = decoded['confidence'];
      setState(() {
        _predictions[image.path] = label;
        _submittedStates[image.path] = true;
        _correctionStates[image.path] = false;
      });
      print("✅ Bild gespeichert mit Label: $label ($confidence)");
    } else {
      print("❌ Fehler bei Agree-Upload: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Fehler beim Senden (Agree): $e");
  }
}

  
  Future<void> _sendCorrection(XFile image, String correctedClass) async {
    final uri = Uri.parse('http://10.0.2.2:8001/submit/correction');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    request.fields['corrected_class'] = correctedClass;
    await request.send();
  }
  
  /// Sends an image to a manual labeling queue when the model cannot determine a class.
  Future<void> _sendToManualLabeling(XFile image) async {
    final uri = Uri.parse('http://10.0.2.2:8001/submit/manual');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    await request.send();
  }
  
  /// Helper to build a categorical correction button (Recyclable/General/Organic).
  /// Encapsulates the correction action and local state updates.
  Widget _buildCategoryButton(String label, IconData icon, Color color, String imagePath) {
    final image = _images.firstWhere((img) => img.path == imagePath);
    return ElevatedButton.icon(
      onPressed: () async {
        await _sendCorrection(image, label.toLowerCase());
        setState(() {
          _correctionStates[imagePath] = false;
          _submittedStates[imagePath] = true;

          // Store in history
          HistoryStore.items.add(
            HistoryItem(imagePath: image.path, category: label),
          );

          // remove image from homepage
          _images.removeWhere((img) => img.path == image.path);


        });
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
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
                    MaterialPageRoute(builder: (_) => const UnderpageHistory()), 
                  );
                  break;
                case 2:
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const UnderpageAboutUs()),
                    );
                  break;                     
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UnderpageMotivation()),
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
                child: Text("History"),
              ),
              const PopupMenuItem<int>(
                value: 2, 
                child: Text("About us")
              ), 
              const PopupMenuItem<int>(
                value: 3,
                child: Text("Motivation"),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              const SizedBox(height: 60),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    Center(
  child: GestureDetector(
    onTap: () async {
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Select image source'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      );

      if (source == ImageSource.camera) {
        await _pickSingleImageFromCamera();
      } else if (source == ImageSource.gallery) {
        await _pickImages();
      }
    },
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(162, 156, 244, 159),
      ),
      child: const Icon(Icons.photo_library, size: 50),
    ),



  ),
),

const SizedBox(height: 12),

const Padding(
  padding: EdgeInsets.symmetric(horizontal: 24.0),
  child: Text(
    'Tap the button above to choose images from your gallery or take a picture.',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 15,
      color: Color.fromARGB(255, 104, 104, 104),
    ),
  ),
),


                    const SizedBox(height: 20),

                    if (_images.isNotEmpty)
                      Center( 
                        child: Wrap(
                          alignment: WrapAlignment.center,        
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 24,
                          children: _images.map((image) {
                            final path = image.path;
                            final showPrompt = _correctionStates[path] ?? false;
                            final submitted  = _submittedStates[path] ?? false;
                            final prediction = _predictions[path] ?? "Identifying...";

                            return SizedBox(                     
                              width: 400,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center, 
                                children: [
                                  Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.file(
                                        File(path),
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "'$prediction'",
                                    textAlign: TextAlign.center,   
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  if (!submitted) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center, 
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await _sendAgree(image);
                                            setState(() {
                                              _submittedStates[path] = true;
                                              _correctionStates[path] = false;
                                              
                                              HistoryStore.items.add(
                                                HistoryItem(imagePath: image.path, category: _predictions[path] ?? "Unknown"),
                                              );

                                              _images.removeWhere((img) => img.path == image.path);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF76CE7B),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            "Agree",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 56, 53, 53),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _images.removeWhere((img) => img.path == image.path);
                                              _predictions.remove(path);
                                              _submittedStates.remove(path);
                                              _correctionStates.remove(path);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey.shade400,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 56, 53, 53),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _correctionStates[path] = true;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent.shade200,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text(
                                            "Disagree",
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 56, 53, 53),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),


                                    if (showPrompt) ...[
                                      const SizedBox(height: 16),
                                      const Text(
                                        textAlign: TextAlign.center,
                                        "What type of waste is it really?",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      Wrap(
                                        spacing: 12,
                                        children: [
                                          _buildCategoryButton("Recyclable", Icons.recycling, Colors.blue[100]!, path),
                                          _buildCategoryButton("General", Icons.delete_outline, Colors.grey[300]!, path),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 80),
                                            child: _buildCategoryButton("Organic", Icons.eco, Colors.green[100]!, path),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ] 
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),




    
    );
  }
}



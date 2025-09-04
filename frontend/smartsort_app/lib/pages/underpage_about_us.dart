import 'package:flutter/material.dart';
import 'package:smartsort_app/pages/home.dart';
import 'package:smartsort_app/pages/underpage_history.dart';
import 'package:smartsort_app/pages/underpage_howitworks.dart';
import 'package:smartsort_app/pages/underpage_motivation.dart';
import 'package:smartsort_app/pages/underpage_wastecategory.dart';

class UnderpageAboutUs extends StatelessWidget {
  const UnderpageAboutUs({super.key});

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
                child: Text("Home"),
              ),
           
              const PopupMenuItem<int>(
                value: 2,
                child: Text("History"),
              ),
              const PopupMenuItem<int>(
                value: 3, 
                child: Text("Motivation")
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
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group photo (rounded)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    'assets/group_photo.png', 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Project context (short)
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "The smartsort application was developed as part of an international project in Bangkok. "
                  "We are a group of four students from Technische Hochschule Augsburg (THA) — three studying Business Informatics (4th semester) "
                  "and one studying Computer Science (6th semester). The project was carried out in collaboration with "
                  "King Mongkut’s Institute of Technology Ladkrabang (KMITL).",
                  style: TextStyle(fontSize: 16, height: 1.35),
                ),
              ),

              const SizedBox(height: 24),
              _SectionHeader(title: "Team"),
              const SizedBox(height: 12),

              // Single-column intros: name then text directly below

              const _MemberIntro(
                name: "Arbnor — Business Informatics, 4th semester",
                text:
                    "If there’s a problem, Arbnor will solve it — or at least make a funny comment first. "
                    "Loves debugging almost as much as late-night pizza.",
              ),
              const _MemberIntro(
                name: "Janneck — Business Informatics, 4th semester",
                text:
                    "Janneck is the most humorous one of us. "
                    "Keeps the team on track and still lands jokes at the right time.",
              ),
              const _MemberIntro(
                name:"Julian — Business Informatics, 4th semester",
                text:
                    "Always finds a way to connect theory with practice — and coffee with coding. "
                    "Known as the “database whisperer” of the group.",
              ),              
              const _MemberIntro(
                name: "Seyit — Computer Science, 6th semester",
                text:
                    "The veteran of the team. Brings extra semesters of wisdom (and memes). "
                    "Seyit keeps the commits flowing — whenever Git complains, he’s the one who makes peace.",
              ),

              const SizedBox(height: 8),
              const Divider(height: 32),

              _SectionHeader(title: "Thank You"),
              const SizedBox(height: 8),
              const Text(
                "We would like to express our sincere gratitude to Professor Isara Anantavrasilp, "
                "who supported and guided us during our stay in Bangkok. His help was invaluable to the success of this project." 
                "We would also like to thank King Mongkut’s Institute of Technology Ladkrabang and Technische Hochschule Augsburg for making this international project possible.",
                style: TextStyle(fontSize: 16, height: 1.35),
              ),

              const SizedBox(height: 16),

              // Logos row
              Row(
                children: [
                  Expanded(
                    child: _LogoCard(
                      label: "THA",
                      assetPath: 'assets/logo_technische_hochschule_augsburg.png', 
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LogoCard(
                      label: "KMITL",
                      assetPath: 'assets/logo_kmitl.png', 
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MemberIntro extends StatelessWidget {
  final String name;
  final String text;
  const _MemberIntro({required this.name, required this.text});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name line
          Text(
            name,
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: Colors.green, // coloring the names 
            ),
          ),
          const SizedBox(height: 6),
          // Text directly under name
          Text(
            text,
            style: const TextStyle(fontSize: 15.5, height: 1.4, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _LogoCard extends StatelessWidget {
  final String label;
  final String assetPath;
  const _LogoCard({required this.label, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 6),
            color: Color(0x14000000),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

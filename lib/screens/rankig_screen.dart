import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classificação App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RankingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class RankingArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    const double arcHeight = 40.0; 

   
    path.moveTo(0, arcHeight);

    
    path.quadraticBezierTo(size.width / 2, 0, size.width, arcHeight);

    
    path.lineTo(size.width, size.height); 
    path.lineTo(0, size.height);          
    path.close();                         

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Classificação', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const PodiumWidget(),
          const SizedBox(height: 30),

          
          Expanded(
            
            child: ClipPath(
              clipper: RankingArcClipper(), 
              child: Container(
                
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: const RankingList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PodiumWidget extends StatelessWidget {
  const PodiumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PodiumPlace(
          name: 'Carmem Dias',
          points: '2879 Pts',
          imageUrl: 'assets/foto de foco raso da mulher na jaqueta cinza.png',
          radius: 50,
        ),
        PodiumPlace(
          name: 'Joao Santana',
          points: '5678 Pts',
          imageUrl: 'assets/um homem de óculos e camisa branca.png',
          radius: 65,
          hasCrown: true,
        ),
        PodiumPlace(
          name: 'Beatriz Silva',
          points: '3244 Pts',
          imageUrl: 'assets/Uma jovem com cabelo comprido vestindo uma camiseta branca.png',
          radius: 50,
        ),
      ],
    );
  }
}


class PodiumPlace extends StatelessWidget {
  final String name;
  final String points;
  final String imageUrl;
  final double radius;
  final bool hasCrown;

  const PodiumPlace({
    super.key,
    required this.name,
    required this.points,
    required this.imageUrl,
    required this.radius,
    this.hasCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: radius,
              backgroundImage: AssetImage(imageUrl),
            ),
            if (hasCrown)
              Positioned(
                top: -15,
                left: (radius - 20),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFE3C500),
                  size: 40,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(points, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}


class RankingList extends StatelessWidget {
  const RankingList({super.key});

  final List<Map<String, dynamic>> rankings = const [
    {'position': '4', 'name': 'Carol Dias', 'points': '2000 Pts', 'imageUrl': 'assets/Um homem de camisa branca está posando para uma foto.png'},
    {'position': '5', 'name': 'Carlos Peira', 'points': '1890 Pts', 'imageUrl': 'assets/um homem de cabelos cacheados sorrindo para a câmera.png'},
    {'position': '6', 'name': 'Cristiana Rodrigues', 'points': '1600 Pts', 'imageUrl': 'assets/Uma jovem empresária de pé ao ar livre contra o fundo verde, olhando para a câmera.png'},
    {'position': '7', 'name': 'Heloisa Vital', 'points': '1456 Pts', 'imageUrl': 'assets/uma mulher em um vestido sorrindo contra uma parede azul.png'},
    {'position': '8', 'name': 'Roberto Carlos', 'points': '1302 Pts', 'imageUrl': 'assets/camisa cinza e preta do homem.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 20), 
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final item = rankings[index];
        final bool isCurrentUser = item['name'] == 'Jon';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: isCurrentUser ? Colors.blueAccent : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    item['position'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(item['imageUrl']),
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
            title: Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            trailing: Text(
              item['points'],
              style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
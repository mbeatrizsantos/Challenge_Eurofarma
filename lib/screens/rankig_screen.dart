import 'package:flutter/material.dart';

// 1. PONTO DE PARTIDA DA APLICAÇÃO
void main() {
  runApp(const MyApp());
}

// 2. WIDGET RAIZ COM O MATERIAL APP
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

// NOVA CLASSE PARA CRIAR O ARCO
class RankingArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    const double arcHeight = 40.0; // Altura do arco

    // Começa o desenho do canto esquerdo, na altura do final do arco
    path.moveTo(0, arcHeight);

    // Cria a curva de Bézier quadrática
    // O ponto de controle (x1, y1) fica no meio da largura e no topo (y=0)
    // O ponto final (x2, y2) fica no canto direito, na altura do final do arco
    path.quadraticBezierTo(size.width / 2, 0, size.width, arcHeight);

    // Desenha as linhas retas para fechar o container
    path.lineTo(size.width, size.height); // Lado direito
    path.lineTo(0, size.height);          // Lado de baixo
    path.close();                         // Fecha o caminho

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


// 3. A TELA DE RANKING COMPLETA E MODIFICADA
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

          // Container da lista MODIFICADO para usar ClipPath
          Expanded(
            // O ClipPath "recorta" o widget filho (Container) com o formato customizado
            child: ClipPath(
              clipper: RankingArcClipper(), // Usando nosso recortador customizado
              child: Container(
                // A decoração do container não tem mais o borderRadius
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

// 4. WIDGET DO PÓDIO (sem alterações)
class PodiumWidget extends StatelessWidget {
  const PodiumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PodiumPlace(
          name: 'Bil-al',
          points: '2879 Pts',
          imageUrl: 'assets/person1.png',
          radius: 50,
        ),
        PodiumPlace(
          name: 'Davy Jones',
          points: '5678 Pts',
          imageUrl: 'assets/person2.png',
          radius: 65,
          hasCrown: true,
        ),
        PodiumPlace(
          name: 'Michael J',
          points: '3244 Pts',
          imageUrl: 'assets/person3.png',
          radius: 50,
        ),
      ],
    );
  }
}

// 5. WIDGET AUXILIAR PARA CADA LUGAR NO PÓDIO (sem alterações)
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

// 6. WIDGET DA LISTA DE RANKING (sem alterações)
class RankingList extends StatelessWidget {
  const RankingList({super.key});

  final List<Map<String, dynamic>> rankings = const [
    {'position': '4', 'name': 'Smith Carol', 'points': '2000 Pts', 'imageUrl': 'assets/person4.png'},
    {'position': '5', 'name': 'Harry', 'points': '1890 Pts', 'imageUrl': 'assets/person5.png'},
    {'position': '6', 'name': 'Jon', 'points': '1600 Pts', 'imageUrl': 'assets/person6.png'},
    {'position': '7', 'name': 'Ken', 'points': '1456 Pts', 'imageUrl': 'assets/person7.png'},
    {'position': '8', 'name': 'Petter', 'points': '1302 Pts', 'imageUrl': 'assets/person8.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 20), // Aumentei o padding de cima para a lista não ficar colada no arco
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
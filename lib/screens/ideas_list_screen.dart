import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IdeasListScreen extends StatelessWidget {
  const IdeasListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lista de\nIdeias',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('ideias').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Erro ao carregar ideias', style: TextStyle(color: Colors.white)));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        return IdeaCard(data: data);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF0A1931),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Notícias'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class IdeaCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const IdeaCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data['status'] == 'Em Andamento' ? const Color(0xFFF9E45E) : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem e botão
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/ideia_exemplo.png'), // Imagem genérica de ideia
                radius: 24,
              ),
              const Icon(Icons.open_in_new, color: Colors.black),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Ideia ${data['id']}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14),
              const SizedBox(width: 4),
              Text('Até ${data['dataEnvio']}', style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text(data['descricao'], style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),

          // Avatares + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.only(right: 4),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/avatar.png'), // Placeholder
                      radius: 12,
                    ),
                  );
                }),
              ),
              Column(
                children: [
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text('Em análise', style: TextStyle(fontSize: 12)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

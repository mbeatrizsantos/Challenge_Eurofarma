import 'package:flutter/material.dart';

class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  Future<List<NewsItem>> fetchNoticias() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay
    return [
      NewsItem(
        title: 'A23: Dia Mundial da Pessoa com Esquizofrenia',
        date: 'Jul 14, 2023',
        imageUrl: 'assets/a23.jpg',
      ),
      NewsItem(
        title: 'Dia Nacional do Medicamento Gen',
        date: 'Jul 11, 2023',
        imageUrl: 'assets/med.jpg',
      ),
      NewsItem(
        title: '6 Laboratórios de 7ª geração',
        date: 'Jul 20, 2023',
        imageUrl: 'assets/lab.jpg',
      ),
      NewsItem(
        title: 'SpaceX: Lançamento de Equipamentos',
        date: 'Jul 11, 2023',
        imageUrl: 'assets/spacex.jpg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[900],
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Seção "Noticias recentes"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Noticias recentes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Ação para "Ver mais"
                },
                child: const Text(
                  'Ver mais',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<NewsItem>>(
            future: fetchNoticias(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar notícias'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma notícia disponível'));
              }
              final noticias = snapshot.data!;
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: noticias.map((news) => NewsCard(news: news)).toList(),
              );
            },
          ),
          const SizedBox(height: 32),
          // Seção "Perguntas frequentes"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Perguntas frequentes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Ação para "Ver mais"
                },
                child: const Text(
                  'Ver mais',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
            children: [
              FAQCard(
                title: 'O que é Esquizofrenia?',
                date: 'Atualizado: Aug 30, 2025', // Simulado
              ),
              FAQCard(
                title: 'Como usar medicamentos genéricos?',
                date: 'Atualizado: Aug 28, 2025',
              ),
              FAQCard(
                title: 'Quais são os laboratórios disponíveis?',
                date: 'Atualizado: Aug 25, 2025',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewsItem {
  final String title;
  final String date;
  final String imageUrl;

  NewsItem({required this.title, required this.date, required this.imageUrl});
}

class NewsCard extends StatelessWidget {
  final NewsItem news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(news.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  news.date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  final String title;
  final String date;

  const FAQCard({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.grey[300], // Placeholder para imagem ou fundo genérico
            child: const Center(child: Icon(Icons.question_answer, size: 40, color: Colors.black54)), // Ícone para FAQs
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
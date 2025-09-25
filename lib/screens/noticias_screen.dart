import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar para SystemChrome
import 'news_detail_screen.dart'; // Importe a nova tela

// Classe para modelar um item de notícia
class NewsItem {
  final String title;
  final String date;
  final String imageUrl;

  NewsItem({required this.title, required this.date, required this.imageUrl});
}

// Classe para modelar um item de FAQ (Perguntas Frequentes)
class FAQItem {
  final String question;
  final String answer;
  final String imageUrl;

  FAQItem({required this.question, required this.answer, required this.imageUrl});
}

// Tela principal de Notícias e FAQs
class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  Future<List<NewsItem>> fetchNoticias() async {
    await Future.delayed(const Duration(seconds: 1));
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

  Future<List<FAQItem>> fetchFAQs() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      FAQItem(
        question: 'O que é Esquizofrenia?',
        answer: 'É uma doença mental crônica e complexa...',
        imageUrl: 'assets/faq_esquizofrenia.jpg',
      ),
      FAQItem(
        question: 'Como usar medicamentos genéricos?',
        answer: 'Os medicamentos genéricos possuem o mesmo...',
        imageUrl: 'assets/faq_genericos.jpg',
      ),
      FAQItem(
        question: 'Quais são os laboratórios disponíveis?',
        answer: 'Temos parceria com diversos laboratórios...',
        imageUrl: 'assets/faq_laboratorios.jpg',
      ),
      FAQItem(
        question: 'Onde posso encontrar eventos?',
        answer: 'Você pode verificar a aba de notícias...',
        imageUrl: 'assets/faq_eventos.jpg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF041C40),
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
                onPressed: () {},
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
                return const Center(child: Text('Erro ao carregar notícias', style: TextStyle(color: Colors.white)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma notícia disponível', style: TextStyle(color: Colors.white)));
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
                onPressed: () {},
                child: const Text(
                  'Ver mais',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<FAQItem>>(
            future: fetchFAQs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar FAQs', style: TextStyle(color: Colors.white)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma FAQ disponível', style: TextStyle(color: Colors.white)));
              }
              final faqs = snapshot.data!;
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: faqs.map((faq) => FAQCard(faq: faq)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget para exibir um card de notícia.
class NewsCard extends StatelessWidget {
  final NewsItem news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Adicionado GestureDetector para o clique
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(news: news),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(news.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

// Widget para exibir um card de pergunta frequente (agora ajustado para GridView).
class FAQCard extends StatelessWidget {
  final FAQItem faq;

  const FAQCard({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    // ### ALTERAÇÃO 2: Card agora não tem mais margem vertical (o GridView cuida do espaçamento) ###
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ### ALTERAÇÃO 3: Usando Expanded para a imagem se ajustar ao GridView ###
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(faq.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  faq.answer,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 1, // Reduzido para 1 linha para caber melhor no card menor
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
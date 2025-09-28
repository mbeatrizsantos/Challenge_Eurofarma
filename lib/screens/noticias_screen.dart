import 'package:bd/screens/info_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'news_detail_screen.dart';

class NewsItem {
  final String id;
  final String title;
  final String author;
  final String status;
  final String imageUrl;
  final String content;

  NewsItem({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    required this.imageUrl,
    required this.content,
  });

  factory NewsItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return NewsItem(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      status: data['status'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      content: data['content'] ?? 'Nenhum conteúdo adicional.',
    );
  }
}

class InfoItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String fullContent;

  InfoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.fullContent,
  });

  factory InfoItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return InfoItem(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      fullContent: data['fullContent'] ?? 'Nenhuma informação adicional.',
    );
  }
}

class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  Future<List<NewsItem>> fetchIdeiasEmAndamento() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('noticias')
        .get();
    return snapshot.docs.map((doc) => NewsItem.fromFirestore(doc)).toList();
  }

  Future<List<InfoItem>> fetchInfoItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('faq').get();
    return snapshot.docs.map((doc) => InfoItem.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF041C40),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Notícias e Ideias em Destaque',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<NewsItem>>(
            future: fetchIdeiasEmAndamento(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.isEmpty)
                return const Center(
                  child: Text(
                    'Nenhuma ideia em destaque.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              final ideas = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: ideas.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => NewsCard(news: ideas[index]),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Perguntas Frequentes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<InfoItem>>(
            future: fetchInfoItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.isEmpty)
                return const Center(
                  child: Text(
                    'Nenhuma informação disponível.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              final infoItems = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: infoItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    InfoCard(info: infoItems[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}


class NewsCard extends StatelessWidget {
  final NewsItem news;
  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(newsItem: news),
        ),
      ),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                news.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  );
                },
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
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Por: ${news.author}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
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

class InfoCard extends StatelessWidget {
  final InfoItem info;
  const InfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoDetailScreen(infoItem: info),
          ),
        );
      },

      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                info.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
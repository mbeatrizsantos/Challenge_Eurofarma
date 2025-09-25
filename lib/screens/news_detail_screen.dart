import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Abaixo, a linha de import foi corrigida como você indicou
import 'noticias_screen.dart'; 

class NewsDetailScreen extends StatelessWidget {
  final NewsItem news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    // Deixa os ícones da barra de status (hora, bateria) brancos para contrastar com a imagem
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            backgroundColor: Colors.transparent, // Fundo da barra fica transparente
            elevation: 0,
            pinned: true, // A barra permanece visível (só com a seta) ao rolar

            // Seta de voltar
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Ação para voltar para a tela anterior
                Navigator.of(context).pop();
              },
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                news.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Usamos SliverToBoxAdapter para colocar um widget normal dentro de um CustomScrollView
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              // Este transform "puxa" o container branco para cima, sobrepondo a imag
              transform: Matrix4.translationValues(0.0, -30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF041C40),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'EuroLab',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        news.date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.circle, size: 5, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text(
                        '8 min',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'O Eurolab conta com fábrica de escalonamento, uma cópia em tamanho reduzido da planta industrial. Assim, não é mais necessário interromper uma linha de produção para fazer testes. A mini fábrica será certificada e poderá produzir lotes para estudos clínicos.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
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
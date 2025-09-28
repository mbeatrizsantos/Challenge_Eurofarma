import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'noticias_screen.dart'; // Importa o arquivo para ter acesso à classe NewsItem

class NewsDetailScreen extends StatelessWidget {
  // A tela recebe um objeto NewsItem completo, com todos os dados do documento do Firebase
  final NewsItem newsItem;

  const NewsDetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    // Deixa os ícones da barra de status (hora, bateria) brancos para contrastar com a imagem
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true, // Mantém a barra (com a seta) visível no topo ao rolar

            // Seta para voltar à tela anterior
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                // Carrega a imagem a partir da URL vinda do Firebase
                newsItem.imageUrl,
                fit: BoxFit.cover,
                // Mostra um indicador de carregamento enquanto a imagem baixa
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                // Mostra um ícone de erro se a imagem não carregar
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.image_not_supported, color: Colors.white70));
                },
              ),
            ),
          ),
          // Adaptador para colocar o conteúdo principal da tela que não é "rolável" por si só
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              // O transform "puxa" o container branco para cima, sobrepondo parte da imagem
              transform: Matrix4.translationValues(0.0, -30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exibe o TÍTULO da notícia/ideia
                  Text(
                    newsItem.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF041C40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Exibe o AUTOR e o STATUS
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Por: ${newsItem.author}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.flag_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Status: ${newsItem.status}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const Divider(height: 48, thickness: 0.5),
                  // Exibe o CONTEÚDO COMPLETO vindo do Firebase
                  Text(
                    newsItem.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6, // Espaçamento entre linhas para melhor leitura
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
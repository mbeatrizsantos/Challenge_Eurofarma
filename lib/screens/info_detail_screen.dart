import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'noticias_screen.dart'; // Importa para ter acesso à classe InfoItem

class InfoDetailScreen extends StatelessWidget {
  // A tela recebe um objeto InfoItem completo
  final InfoItem infoItem;

  const InfoDetailScreen({super.key, required this.infoItem});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                infoItem.imageUrl, // Usa a imagem do InfoItem
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.image_not_supported, color: Colors.white70));
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              transform: Matrix4.translationValues(0.0, -30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exibe o TÍTULO do InfoItem
                  Text(
                    infoItem.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF041C40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Exibe a DESCRIÇÃO curta como subtítulo
                  Text(
                    infoItem.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const Divider(height: 48, thickness: 0.5),
                  // Exibe o CONTEÚDO COMPLETO vindo do Firebase
                  Text(
                    infoItem.fullContent,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'noticias_screen.dart'; 

class InfoDetailScreen extends StatelessWidget {
  final InfoItem infoItem;

  const InfoDetailScreen({super.key, required this.infoItem});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            backgroundColor: const Color(0xFF041C40),
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                infoItem.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(32.0), 
              child: Container(
                height: 32.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0), 
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF0F0F0),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    infoItem.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF041C40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    infoItem.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const Divider(height: 48, thickness: 0.5),
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
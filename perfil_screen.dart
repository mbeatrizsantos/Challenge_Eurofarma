import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados fictícios
    final String userName = 'Carolino Dias';
    final int pontos = 590;
    final int rank = 86;
    final int rankEquipe = 56;
    final int ideiasEnviadas = 6;
    final int ideiasAceitas = 4;
    final int ideiasSugeridas = 20;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Foto e Nome
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/user_avatar.png'), // sua imagem
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Card de Pontos / Rank
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('PONTOS', pontos.toString()),
                    _buildStat('RANK', '#$rank'),
                    _buildStat('RANK EQUIPE', '#$rankEquipe'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status mensal
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Você enviou $ideiasEnviadas ideias esse mês!'),
                        DropdownButton<String>(
                          value: 'Mensal',
                          items: const [
                            DropdownMenuItem(value: 'Mensal', child: Text('Mensal')),
                            DropdownMenuItem(value: 'Semanal', child: Text('Semanal')),
                          ],
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Progresso circular
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: ideiasEnviadas / ideiasSugeridas,
                            strokeWidth: 8,
                            color: Colors.blue,
                            backgroundColor: Colors.grey[300],
                          ),
                          Center(
                            child: Text(
                              '$ideiasEnviadas/$ideiasSugeridas',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Estatísticas adicionais
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMiniStat('Ideias enviadas', ideiasEnviadas.toString()),
                        _buildMiniStat('Ideias aceitas', ideiasAceitas.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

import 'package:flutter/material.dart';

// MAIN WIDGET - PROFILE SCREEN
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedTab = 'Status';

  // Dados fi-ctícios
  final String userName = 'Junior Souza';
  final int pontos = 590;
  final int rank = 86;
  final int rankEquipe = 56;
  final int ideiasEnviadas = 6;
  final int ideiasAceitas = 4;
  final int ideiasSugeridas = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: CustomScrollView(
        slivers: [
          // Nosso cabeçalho customizado que resolve o corte da foto
          SliverPersistentHeader(
            floating: true,
            delegate: _ProfileHeaderDelegate(
              userName: userName,
              pontos: pontos,
              rank: rank,
              rankEquipe: rankEquipe,
            ),
          ),

          // O conteúdo que fica abaixo do cabeçalho
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF0F0F0),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Abas de navegação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 'Status';
                          });
                        },
                        child: _buildTabButton('Status', _selectedTab == 'Status'),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 'Pontos';
                          });
                        },
                        child: _buildTabButton('Pontos', _selectedTab == 'Pontos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Conteúdo condicional com a nova versão do Status
                  if (_selectedTab == 'Status')
                    _buildStatusContent(
                      ideiasEnviadas,
                      ideiasAceitas,
                      ideiasSugeridas,
                    )
                  else
                    _buildRewardsList(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // MÉTODO ATUALIZADO PELO SEU COLABORADOR
  Widget _buildStatusContent(
    int ideiasEnviadas,
    int ideiasAceitas,
    int ideiasSugeridas,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE666),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Você enviou 6 ideias esse mês!",
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: 'Mensal',
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: const [
                  DropdownMenuItem(value: 'Mensal', child: Text('Mensal')),
                  DropdownMenuItem(value: 'Semanal', child: Text('Semanal')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 12 / ideiasSugeridas,
                  strokeWidth: 10,
                  color: const Color(0xFF123C8C),
                  backgroundColor: Colors.white,
                ),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "12/$ideiasSugeridas\n",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: "ideias sugeridas",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // CARD 1: Ideias enviadas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Um cinza claro
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$ideiasEnviadas",
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Icon(Icons.edit, color: Colors.black, size: 28),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Ideias enviadas",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16), // Espaçamento entre os cards
              // CARD 2: Ideias aceitas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1), // Azul escuro
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$ideiasAceitas",
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.military_tech_outlined, // Ícone de medalha
                            color: Colors.white,
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Ideias aceitas",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Recompensas",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildRewardCard("Netflix", "Um mês de Netflix grátis.", 20),
        const SizedBox(height: 10),
        _buildRewardCard("Burger King", "15R\$ de desconto.", 20),
        const SizedBox(height: 10),
        _buildRewardCard("Centauro", "10% de desconto.", 20),
        const SizedBox(height: 10),
        _buildRewardCard("Drogasil", "5% de desconto.", 20),
      ],
    );
  }

  Widget _buildRewardCard(String title, String description, int points) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  "$points",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  "PTS",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? const Color(0xFF123C8C) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 4,
            width: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF123C8C),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

// CLASSE DO DELEGATE DO CABEÇALHO (VERSÃO ESTÁVEL)
class _ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String userName;
  final int pontos;
  final int rank;
  final int rankEquipe;

  _ProfileHeaderDelegate({
    required this.userName,
    required this.pontos,
    required this.rank,
    required this.rankEquipe,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        // Fundo azul
        Container(color: const Color(0xFF041C40)),
        
        // Container branco com as informações
        Positioned(
          top: 120.0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 60), // Espaço para o avatar
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Card azul de pontos/rank
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF123C8C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(Icons.star, 'PONTOS', pontos.toString()),
                      _buildStat(Icons.public, 'RANK', '#$rank'),
                      _buildStat(Icons.group, 'RANK EQUIPE', '#$rankEquipe'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Avatar
        const Positioned(
          top: 60.0, // Posição fixa: 120 (topo do container branco) - 60 (raio do avatar)
          left: 0,
          right: 0,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFFF0F0F0),
            child: CircleAvatar(
              radius: 56,
              backgroundImage: AssetImage('assets/camilo.jpg'),
            ),
          ),
        ),

        // Botões de Voltar e Configurações (sempre visíveis)
         Positioned(
          top: MediaQuery.of(context).padding.top,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  // Altura máxima e mínima são iguais para um cabeçalho estático
  @override
  double get maxExtent => 340;

  @override
  double get minExtent => 340;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
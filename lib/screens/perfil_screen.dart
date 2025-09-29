import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_screen.dart';
import 'login_screen.dart'; // Import necessário para o logout

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedTab = 'Status';
  bool _isLoading = true;

  String userName = 'Carregando...';
  int pontos = 0;
  int rank = 0;
  int rankEquipe = 0;
  int ideiasEnviadas = 0;
  int ideiasAceitas = 0;
  bool _isAdmin = false;
  
  final int ideiasSugeridas = 20;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final ideasQuery = await FirebaseFirestore.instance
          .collection('ideias')
          .where('creatorId', isEqualTo: user.uid)
          .count()
          .get();
          
      final userIdeiasCount = ideasQuery.count;

      if (mounted && userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          userName = data['displayName'] ?? 'Usuário sem nome';
          pontos = data['pontos'] ?? 0;
          rank = data['rank'] ?? 0;
          rankEquipe = data['rankEquipe'] ?? 0;
          ideiasAceitas = data['ideiasAceitas'] ?? 0;
          _isAdmin = data['role'] == 'admin';
          ideiasEnviadas = userIdeiasCount!;
        });
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
      if (mounted) {
        setState(() {
          userName = 'Erro ao carregar';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F0F0),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: _ProfileHeaderDelegate(
              userName: userName,
              pontos: pontos,
              rank: rank,
              rankEquipe: rankEquipe,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF0F0F0),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _selectedTab = 'Status'),
                        child: _buildTabButton('Status', _selectedTab == 'Status'),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => setState(() => _selectedTab = 'Pontos'),
                        child: _buildTabButton('Pontos', _selectedTab == 'Pontos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (_isAdmin)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('Painel do Administrador'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF123C8C),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )
                        ),
                      ),
                    ),

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
  
  Widget _buildStatusContent(int ideiasEnviadas, int ideiasAceitas, int ideiasSugeridas) { 
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
              Text(
                "Você enviou $ideiasEnviadas ideias esse mês!",
                style: const TextStyle(
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
                  value: ideiasSugeridas > 0 ? (ideiasEnviadas / ideiasSugeridas) : 0,
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
                           text: "$ideiasEnviadas/$ideiasSugeridas\n",
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
              Expanded(
                child: Container(
                   padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                     color: Colors.grey[200],
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
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                   horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1), 
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
                            Icons.military_tech_outlined,
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
                      fontWeight: FontWeight.bold),
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

  // --- NOVA FUNÇÃO PARA O LOGOUT ---
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você tem certeza que deseja sair?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Sair', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                
                if (Navigator.of(dialogContext).canPop()) {
                   Navigator.of(dialogContext).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Container(color: const Color(0xFF041C40)),
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
                const SizedBox(height: 60),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
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
        const Positioned(
          top: 60.0,
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
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            // --- ONPRESSED ATUALIZADO ---
            onPressed: () {
              _showLogoutDialog(context);
            },
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

  @override
  double get maxExtent => 340;
  @override
  double get minExtent => 340;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
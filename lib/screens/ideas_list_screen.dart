import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

//////////////APAGAR CODIGO DUPLICADO!!!!!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Ideias',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      home: const IdeasListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IdeasListScreen extends StatelessWidget {
  const IdeasListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const AddIdeaSheet(),
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Lista de\nIdeias',
                style: TextStyle(
                  fontSize: 42,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ideias')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erro ao carregar ideias',
                              style: TextStyle(color: Colors.white)));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('Nenhuma ideia encontrada.',
                              style: TextStyle(color: Colors.white70)));
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8.0),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        // AQUI ESTÁ CHAMANDO O NOVO IDEA CARD
                        return IdeaCard(data: data, documentId: doc.id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class IdeaCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;

  const IdeaCard({super.key, required this.data, required this.documentId});

  @override
  Widget build(BuildContext context) {
    final defaultColor = const Color(0xFFF9E45E); // Cor amarela do design
    final cardColor = data.containsKey('color') ? Color(data['color']) : defaultColor;

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) =>
              IdeaDetailsDialog(data: data, documentId: documentId),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black.withOpacity(0.05),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.black54,
                    size: 30,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black54, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.black54,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              data['titulo'] ?? 'Ideia sem título',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  'Até ${data['dataEnvio'] ?? 'N/D'}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              data['descricao'] ?? 'Sem descrição.',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CollaboratorAvatars(),
                StatusIndicator(status: data['status'] ?? 'Em Análise'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CollaboratorAvatars extends StatelessWidget {
  const CollaboratorAvatars({super.key});

  final List<String> collaborators = const [
    'assets/avatar1.png',
    'assets/avatar2.png',
    'assets/avatar3.png',
  ];

  @override
  Widget build(BuildContext context) {
    const avatarRadius = 16.0;
    const overlap = 10.0;

    return SizedBox(
      height: avatarRadius * 2,
      width: avatarRadius * 2 + (collaborators.length - 1) * (avatarRadius * 2 - overlap),
      child: Stack(
        children: List.generate(collaborators.length, (index) {
          return Positioned(
            left: index * (avatarRadius * 2 - overlap),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(collaborators[index]),
            ),
          );
        }),
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final String status;
  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 60,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}


// =======================================================================
// CÓDIGO ORIGINAL (DIALOG E FORMULÁRIO)
// =======================================================================

class IdeaDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> data;
  final String documentId;

  const IdeaDetailsDialog(
      {super.key, required this.data, required this.documentId});

  Future<void> _deleteIdea(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir esta ideia?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('ideias')
            .doc(documentId)
            .delete();
        if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ideia excluída com sucesso!'))
            );
        }
      } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir ideia: $e'))
            );
        }
      }
    }
  }
  
  void _editIdea(BuildContext context) {
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: AddIdeaSheet(
          initialData: data,
          documentId: documentId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['titulo'] ?? 'Ideia sem título',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  data['categoria'] ?? 'Não definida',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              data['descricao'] ?? 'Sem descrição.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text('Editar', style: TextStyle(color: Colors.blue)),
                  onPressed: () => _editIdea(context),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Excluir', style: TextStyle(color: Colors.red)),
                  onPressed: () => _deleteIdea(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddIdeaSheet extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final String? documentId;

  const AddIdeaSheet({super.key, this.initialData, this.documentId});

  @override
  State<AddIdeaSheet> createState() => _AddIdeaSheetState();
}

class _AddIdeaSheetState extends State<AddIdeaSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _collaboratorController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;
  late final bool _isEditing;

  final List<int> _cardColors = [
    0xFFF9E45E, // Amarelo
    0xFFCBD5E1, // Branco acinzentado
    0xFFB0C4DE, // Azul
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.initialData != null;

    if (_isEditing) {
      _titleController.text = widget.initialData!['titulo'] ?? '';
      _descriptionController.text = widget.initialData!['descricao'] ?? '';
      _collaboratorController.text = widget.initialData!['colaborador'] ?? '';
      _selectedCategory = widget.initialData!['categoria'];
    }
  }

  Future<void> _saveIdea() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, preencha o título e a descrição.')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      if (_isEditing) {
        await FirebaseFirestore.instance
            .collection('ideias')
            .doc(widget.documentId!)
            .update({
          'titulo': _titleController.text,
          'descricao': _descriptionController.text,
          'categoria': _selectedCategory ?? 'Não definida',
          'colaborador': _collaboratorController.text,
        });
      } else {
        final randomColor = _cardColors[Random().nextInt(_cardColors.length)];
        await FirebaseFirestore.instance.collection('ideias').add({
          'titulo': _titleController.text,
          'descricao': _descriptionController.text,
          'categoria': _selectedCategory ?? 'Não definida',
          'colaborador': _collaboratorController.text,
          'dataEnvio': '20 de Julho',
          'status': 'Em Análise',
          'timestamp': FieldValue.serverTimestamp(),
          'color': randomColor,
        });
      }

      if (mounted) { Navigator.of(context).pop(); }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar ideia: $e')),
      );
    } finally {
      if (mounted) { setState(() { _isLoading = false; }); }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _collaboratorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEditing ? 'Editar Ideia' : 'Submeta sua ideia',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A1931),
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(label: 'Título da Ideia', controller: _titleController),
          const SizedBox(height: 16),
          _buildTextField(
              label: 'Descrição', controller: _descriptionController, maxLines: 3),
          const SizedBox(height: 16),
          _buildCategoryDropdown(),
          const SizedBox(height: 16),
          _buildTextField(
              label: 'Marcar colaborador',
              controller: _collaboratorController,
              hint: '@matheus'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.black54)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveIdea,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ))
                    : Text(
                        _isEditing ? 'Salvar Alterações' : 'Enviar Ideia',
                        style: const TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      int maxLines = 1,
      String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categoria',
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          hint: const Text('Selecione a categoria',
              style: TextStyle(color: Colors.black45)),
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: ['Farmacêuticos', 'Tecnologia', 'Marketing', 'RH']
              .map((label) => DropdownMenuItem(
                    value: label,
                    child: Text(label),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
      ],
    );
  }
}
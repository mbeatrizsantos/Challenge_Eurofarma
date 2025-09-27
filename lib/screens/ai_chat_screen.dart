import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para a função de copiar
import 'package:cloud_functions/cloud_functions.dart';

// Modelo para representar uma mensagem no chat
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, {this.isUser = false});

  // Converte a mensagem para o formato que a Cloud Function espera
  Map<String, dynamic> toJson() {
    return {
      'role': isUser ? 'user' : 'model',
      'parts': [{'text': text}],
    };
  }
}

class AiChatScreen extends StatefulWidget {
  // A tela recebe um histórico inicial opcional
  final List<ChatMessage>? initialHistory;

  const AiChatScreen({super.key, this.initialHistory});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  late final List<ChatMessage> _messages;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  String _lastAiResponse = "";

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.initialHistory ?? []);

    // Se a conversa for nova, adiciona uma mensagem de boas-vindas
    if (_messages.isEmpty) {
      _messages.add(ChatMessage("Olá! Sou seu assistente de ideias. Qual conceito você gostaria de explorar hoje?"));
    } 
    // Se a tela recebeu uma ideia inicial do usuário, busca a primeira resposta da IA
    else if (_messages.length == 1 && _messages.first.isUser) {
      _getFirstAiResponse();
    }
    
    _updateLastResponse();
  }

  // Função para a primeira chamada automática da IA
  Future<void> _getFirstAiResponse() async {
    setState(() { _isLoading = true; });
    await _callApi(_messages.first.text);
  }

  // Função para enviar uma mensagem do usuário
  Future<void> _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;
    final userMessage = _textController.text;
    
    setState(() {
      _messages.add(ChatMessage(userMessage, isUser: true));
      _isLoading = true;
    });
    _textController.clear();
    
    await _callApi(userMessage);
  }
  
  // Lógica de chamada da API extraída para uma função separada
  Future<void> _callApi(String textToSend) async {
    try {
      final callable = FirebaseFunctions.instanceFor(region: "us-central1")
          .httpsCallable('developIdeaWithAI');
      
      final result = await callable.call<Map<String, dynamic>>({
        'text': textToSend,
        'history': _messages.map((m) => m.toJson()).toList(),
      });

      final suggestion = result.data['suggestion'];
      if (suggestion != null) {
        setState(() {
          _messages.add(ChatMessage(suggestion));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage("Desculpe, ocorreu um erro. Tente novamente."));
      });
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
        _updateLastResponse();
        _scrollToBottom();
      }
    }
  }

  void _updateLastResponse() {
    if (_messages.isNotEmpty && !_messages.last.isUser) {
      _lastAiResponse = _messages.last.text;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refinar Ideia com IA"),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_outlined),
            tooltip: "Copiar conversa",
            onPressed: () {
              final conversationText = _messages.map((m) => "${m.isUser ? 'Você' : 'IA'}: ${m.text}").join('\n\n');
              Clipboard.setData(ClipboardData(text: conversationText));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conversa copiada!')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.blueAccent : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: SelectableText(
                      message.text,
                      style: TextStyle(color: message.isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
          
          Container(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade300))
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "Faça uma pergunta...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onSubmitted: _isLoading ? null : (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      icon: const Icon(Icons.send),
                      onPressed: _isLoading ? null : _sendMessage,
                      style: IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text("Usar esta versão da ideia"),
                    onPressed: () {
                      Navigator.of(context).pop(_lastAiResponse);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
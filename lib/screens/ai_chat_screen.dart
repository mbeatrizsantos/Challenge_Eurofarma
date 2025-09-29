import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage(this.text, {this.isUser = false});

  Map<String, dynamic> toJson() {
    return {
      'role': isUser ? 'user' : 'model',
      'parts': [{'text': text}],
    };
  }
}


class AiChatService {
  final _functions = FirebaseFunctions.instanceFor(region: "us-central1");


  Future<String> getSuggestion({
    required String text,
    required List<ChatMessage> history,
  }) async {
    try {
      final callable = _functions.httpsCallable('developIdeaWithAI');
      final result = await callable.call<Map<String, dynamic>>({
        'text': text,
        'history': history.map((m) => m.toJson()).toList(),
      });

      final suggestion = result.data['suggestion'] as String?;
      if (suggestion == null || suggestion.isEmpty) {
        throw Exception("A IA não retornou uma sugestão válida.");
      }
      return suggestion;
    } on FirebaseFunctionsException catch (e) {
    
      throw Exception("Erro na comunicação com a IA: ${e.message}");
    } catch (e) {
    
      throw Exception("Ocorreu um erro inesperado: ${e.toString()}");
    }
  }
}

class AiChatScreen extends StatefulWidget {
  final List<ChatMessage>? initialHistory;

  const AiChatScreen({super.key, this.initialHistory});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {

  final _chatService = AiChatService();
  final _messages = <ChatMessage>[];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  String _lastAiResponse = "";

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _initializeChat() {
    final initialHistory = widget.initialHistory;
    if (initialHistory == null || initialHistory.isEmpty) {
    
      _messages.add(ChatMessage(
          "Olá! Sou seu assistente de ideias. Qual conceito você gostaria de explorar hoje?"));
    } else {

      _messages.addAll(initialHistory);
      if (_messages.length == 1 && _messages.first.isUser) {
        _fetchAiResponse(initialText: _messages.first.text);
      } else {
        _updateLastResponse();
      }
    }
  }


  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }


  Future<void> _handleSendPressed() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    _addMessage(ChatMessage(text, isUser: true));
    await _fetchAiResponse(initialText: text);
  }


  Future<void> _fetchAiResponse({required String initialText}) async {
    setState(() => _isLoading = true);

    try {
      final suggestion = await _chatService.getSuggestion(
        text: initialText,
        history: _messages,
      );
      _addMessage(ChatMessage(suggestion));
    } catch (e) {
      _addMessage(ChatMessage("Desculpe, ocorreu um erro: ${e.toString()}"));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _updateLastResponse();
      }
    }
  }


  void _updateLastResponse() {
    final lastMessage = _messages.lastWhere((m) => !m.isUser, orElse: () => ChatMessage(""));
    _lastAiResponse = lastMessage.text;
  }


  void _copyConversationToClipboard() {
    final conversationText = _messages
        .map((m) => "${m.isUser ? 'Você' : 'IA'}: ${m.text}")
        .join('\n\n');
    Clipboard.setData(ClipboardData(text: conversationText));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Conversa copiada!')));
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
            onPressed: _copyConversationToClipboard,
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
                
                return _MessageBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        
          _ChatInputBar(
            controller: _textController,
            isLoading: _isLoading,
            onSend: _handleSendPressed,
            onUseIdea: () {
              
              if (_lastAiResponse.isNotEmpty) {
                Navigator.of(context).pop(_lastAiResponse);
              }
            },
          ),
        ],
      ),
    );
  }
}


class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: isUser ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: SelectableText(
          message.text,
          style: TextStyle(
            color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}


class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;
  final VoidCallback onUseIdea;

  const _ChatInputBar({
    required this.controller,
    required this.isLoading,
    required this.onSend,
    required this.onUseIdea,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      elevation: 4.0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: "Faça uma pergunta...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: isLoading ? null : (_) => onSend(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.send),
                    onPressed: isLoading ? null : onSend,
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onUseIdea,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Usar esta versão da ideia"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
# Inova+ (Challenge Eurofarma)


Repositório do projeto **Inova+**, um aplicativo multiplataforma desenvolvido em Flutter para gamificar o processo de inovação e engajamento de colaboradores na Eurofarma.

---

## 📜 Sobre o Projeto

Este aplicativo foi criado para resolver o desafio do baixo engajamento de funcionários na criação e envio de ideias. Inspirado em plataformas como o Duolingo, o Inova+ transforma a inovação em um jogo, com rankings, pontos e prêmios, incentivando uma cultura de colaboração e criatividade contínua.

## ✨ Features

* ✅ **Autenticação Segura:** Login com Firebase Authentication.
* 💡 **Submissão de Ideias:** Formulário simples para criar e descrever ideias, com opção de coautoria.
* 🏆 **Sistema de Gamificação:** Perfil com estatísticas, ranking de usuários e recompensas.
* 📊 **Acompanhamento de Status:** Visualize o progresso de suas ideias, desde a submissão até a aprovação pelo comitê.
* 🤖 **Categorização com IA:** Sugestão inteligente de projetos para novas ideias.
* 📢 **Quadro de Avisos:** Central de notícias sobre o impacto das inovações.


## 🛠️ Arquitetura e Tecnologias

Este projeto foi construído utilizando uma arquitetura limpa e escalável, com foco na separação de responsabilidades.

* **Framework:** [**Flutter**](https://flutter.dev/)
* **Gerenciamento de Estado:** [**BLoC (Business Logic Component)**](https://bloclibrary.dev/)
* **Backend & Banco de Dados:** [**Firebase (Authentication, Cloud Firestore)**](https://firebase.google.com/)
* **Comparação de Objetos:** [**Equatable**](https://pub.dev/packages/equatable)

## 📁 Estrutura de Pastas

O projeto segue uma estrutura baseada em features, facilitando a manutenção e a escalabilidade:

lib
├── apis/         # Configuração de clientes de API (ex: Firebase)
├── blocs/        # Lógica de negócio (BLoCs e Cubits)
├── models/       # Modelos de dados (ex: User, Idea)
├── repositories/ # Camada de abstração de dados
├── screens/      # Widgets que representam as telas
├── widgets/      # Widgets reutilizáveis
└── main.dart     # Ponto de entrada da aplicação
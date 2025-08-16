# Challenge_Eurofarma
Repositório criado para armazenar todos os códigos referentes ao Challenge da Eurofarma

# 🚀 Projeto Flutter + Firebase

## 📌 Pré-requisitos
- Flutter SDK instalado (versão >= 3.x)
- Dart SDK
- Android Studio ou VS Code com extensões Flutter/Dart
- Firebase CLI instalado
- Uma conta no Firebase

## 🔧 Como rodar o projeto

1. Clone este repositório(ou baixe o arquivo): 
   git clone https://github.com/seu-usuario/nome-projeto.git
   cd nome-projeto
   
Instale as dependências:
flutter pub get

Configure o Firebase (Caso o arquivo firebase_options.dart já esteja incluso, pule esta etapa) Senão, rode:
flutterfire configure
Isso vai gerar o arquivo lib/firebase_options.dart.

Execute o app(apague o BUILD toda vez antes de rodar a aplicação):
flutter run

🔑 Observações
O projeto usa Firebase Authentication (Email/Senha).
Então para login, use as credenciais:
- fulaninha@hotmail.com
- 123456789

Ou vá nesse link: https://console.firebase.google.com/u/0/project/eurofarma-e0432/authentication/users
e adicione algum email+senha e use os mesmos para logar.



____________________________________________________________________________________________________
CONFIGURANDO O FIREBASE:

1°  - baixar esse negócio do firebase: https://firebase.google.com/docs/cli?hl=pt-BR&authuser=0&_gl=1*jia8tv*_ga*MTUxNTY0NjI2OC4xNzUyNzExNzk3*_ga_CW55HF8NVT*czE3NTI3MTE3OTckbzEkZzEkdDE3NTI3MTgwMDckajYwJGwwJGgw#sign-in-test-cli

2° - vai abrir um cli automatico onde vc precisa fazer o login(vai direcionar a uma pagina no google, coloque a conta que ta no firebase)

3° - dentro do projeto, rodar o comando "flutterfire configure" (olha se apareceu o arquivo firebase_options, se sim ta certo.)

e pronto, o objetivo é esse firebase options aparecer la no lib, se não aparecer, roda de novo o "flutterfire configure" (aqui só deu certo quando eu na opção de escolher o configuration support, coloquei todos que tinha lá, mas tenta só com o android e web, deveria funcionar).

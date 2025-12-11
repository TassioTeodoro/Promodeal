# 📱 PromoDeal

**PromoDeal** é um aplicativo desenvolvido em Flutter para **divulgação e gerenciamento de promoções**, conectando **comerciantes** e **clientes** em um ambiente simples, intuitivo e interativo. Ele permite cadastrar promoções, visualizar ofertas, comentar e gerenciar dados diretamente através de uma API integrada ao **Supabase**.

---

## 🚀 Funcionalidades

### 👤 Usuários

* Cadastro de **usuário comum**
* Cadastro de **comerciante**, incluindo:

  * CNPJ
  * Endereço
* Autenticação e integração completa com Supabase

### 🏷️ Promoções

* Criar, editar e excluir promoções
* Definir preços, descontos, imagens e datas
* Associar promoções ao comerciante responsável

### 💬 Comentários

* Criar comentários em promoções
* Listar comentários por promoção
* Remover comentários

### 🔗 Integração com Supabase

* Banco de dados PostgreSQL
* CRUD completo para todas as entidades
* Comunicação via **Supabase REST API**
* Controle de tabelas, permissões e autenticação

### 🧪 Tela de Testes

* Botões para executar CRUD de:

  * Usuário
  * Promoção
  * Comentário
* Logs detalhados no console para facilitar debug

---

## 🛠️ Tecnologias Utilizadas

* **Flutter**
* **Dart**
* **Supabase**
* **PostgreSQL**
* Arquitetura baseada em **Services**

---

# ▶️ Como Rodar o Projeto

Abaixo está um passo a passo completo para executar o projeto **incluindo a instalação do Supabase via Docker**.

---

## 1️⃣ Pré-requisitos

Certifique-se de ter instalado:

* **Flutter (SDK atualizado)**
* **Docker + Docker Compose**
* **Git**

---

## 2️⃣ Clonar o Repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd promodeal
```

---

## 3️⃣ Subir o Supabase via Docker

O projeto depende de uma instância local do Supabase.

### 📦 Passo 1: Instalar o Supabase CLI

```bash
npm install -g supabase
```

### 📁 Passo 2: Inicializar o projeto Supabase

```bash
supabase init
```

### 🐳 Passo 3: Subir os containers

```bash
supabase start
```

Isso vai iniciar:

* PostgreSQL
* Authentication
* API REST
* Studio

Depois da inicialização, você verá informações como:

* URL da API
* Anon Key
* Service Role Key

Copie esses valores e coloque no seu projeto Flutter em `lib/config/supabase_config.dart` (ou arquivo equivalente).

---

## 4️⃣ Configurar Ambiente no Flutter

Edite o arquivo de configuração e inclua:

```dart
class SupabaseConfig {
  static const String url = 'http://localhost:54321';
  static const String anonKey = 'CHAVE_ANON_AQUI';
}
```

> **Atenção:** As portas padrão do Supabase local normalmente são **54321** para REST e **54322** para o banco.

---

## 5️⃣ Instalar Dependências do Flutter

```bash
flutter pub get
```

---

## 6️⃣ Rodar o Projeto

```bash
flutter run
```

O aplicativo será aberto no emulador ou dispositivo físico.

---

# 🧪 Testando a Aplicação

A aplicação inclui uma **tela de testes** com botões para executar operações CRUD, permitindo validar:

* Conexão com Supabase
* Criação e listagem de usuários
* Registro e leitura de promoções
* Comentários associados a promoções

Os logs são exibidos no terminal durante a execução.

---

# 🏗️ Como Gerar Build do Flutter

A seguir estão os comandos para gerar builds do aplicativo em diferentes plataformas.

---

## 📦 Build Android (APK)

Gerar APK para testes:

```bash
flutter build apk --debug
```

Gerar APK otimizado para produção:

```bash
flutter build apk --release
```

Gerar App Bundle (AAB) — formato exigido pela Play Store:

```bash
flutter build appbundle --release
```

O arquivo gerado ficará em:

```
build/app/outputs/
```

---

## 📱 Build iOS

> Necessário macOS + Xcode.

Gerar build para distribuição:

```bash
flutter build ios --release
```

O projeto será preparado em:

```
ios/Runner.xcworkspace
```

Pelo Xcode você finaliza a assinatura e o envio para a App Store.

---

## 🖥️ Build Web

```bash
flutter build web --release
```

Os arquivos finais ficam em:

```
build/web/
```

---

# 👥 Autores

* **Jhefferson Marques de Brito** – Desenvolvedor
* **Tassio Henrique Teodoro Pereira** – Desenvolvedor
* **André Martins** – Orientador do Projeto


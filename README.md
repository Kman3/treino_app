# treino_app

App pessoal de treino e dieta personalizados, pensado para funcionar **offline/local** com opção de backup na nuvem e custo zero (ou quase).

## Stack

- **App:** Flutter (Dart)
- **Armazenamento principal:** SQLite local no dispositivo
- **Backup / sincronização:** Supabase (opcional)

## Roteiro

1. **Módulo de treino** (em desenvolvimento): cadastro de exercícios, montagem de treinos, registro de séries/cargas e histórico.
2. **Backup e sincronização** com Supabase.
3. **Módulo de dieta**: planos alimentares e registro de refeições.

## Como rodar

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.

```bash
git clone https://github.com/Kman3/treino_app.git
cd treino_app
flutter pub get
flutter run
```

> O projeto Flutter ainda será gerado (`flutter create .`). Até lá, este repositório contém apenas a documentação inicial.

## Segurança

Não versione chaves do Supabase. Use um arquivo `.env` (já ignorado no `.gitignore`) ou variáveis de build (`--dart-define`).

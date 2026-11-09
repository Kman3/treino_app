# Caramelo Mutante (`treino_app`)

Aplicativo **Local-First** de treino e dieta personalizados, construído com o sistema visual **Ferro & Giz** para funcionar 100% offline em SQLite, com portabilidade aberta para qualquer IA, exportação/importação SQL e opção futura de backup na nuvem.

## Documentação de Produto (PRDs v2.0)

- [PRD Mestre — Caramelo Mutante](docs/PRD_Mestre_Caramelo_Mutante.md): visão geral, sistema de marca *Ferro & Giz*, onboarding, anamneses, pipeline científico e arquitetura híbrida.
- [PRD do Módulo de Treino](docs/PRD_Modulo_Treino.md): arquitetura de UX/UI, 4 abas (`Hoje | Ficha | Evolução | Perfil`), pré-treino, execução não-linear, editor completo de ficha, regras de alteração e portabilidade IA/SQL.

## Stack

- **App:** Flutter (Dart) + Riverpod + GoRouter
- **Armazenamento principal:** SQLite local com Drift (`drift_schemas/`)
- **Backup / sincronização:** Supabase (opcional, etapa futura)

## Roteiro

1. **Módulo de treino** (em desenvolvimento — etapas 0 a 3 concluídas; etapas 4A–4D especificadas no [PRD do Módulo de Treino](docs/PRD_Modulo_Treino.md)).
2. **Backup e sincronização** opcional com Supabase.
3. **Módulo de dieta e IA integrada**: planos alimentares (TBCA/TACO), lista de compras e geração via RAG.

## Como rodar

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.

```bash
git clone https://github.com/Kman3/treino_app.git
cd treino_app
flutter pub get
flutter run
```

## Segurança

Não versione chaves do Supabase ou de APIs. Use um arquivo `.env` (já ignorado no `.gitignore`) ou variáveis de build (`--dart-define`).

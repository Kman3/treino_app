-- Backup do Caramelo Mutante (etapa 5): cópia das tabelas do app, por pessoa.
--
-- O SQLite do celular é a fonte da verdade; o Postgres guarda uma cópia.
-- Cada linha pertence a quem a enviou (usuario_id = auth.uid()) e a chave é
-- (usuario_id, id): o id vem do aparelho e a preferência tem id fixo 'local'.
-- O catálogo de exercícios vem embutido no app e não sobe.
-- Sem chaves estrangeiras entre as tabelas: o sync envia lotes por tabela,
-- e a ordem de chegada não deve recusar uma linha.

create table public.planos_treino (
  usuario_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  divisao text not null,
  semanas integer not null,
  inicio_em timestamptz not null,
  versao integer not null default 1,
  ativo boolean not null default true,
  atualizado_em timestamptz not null,
  excluido_em timestamptz,
  primary key (usuario_id, id)
);

create table public.sessoes_plano (
  usuario_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  plano_id text not null,
  dia text not null,
  foco text not null,
  ordem integer not null,
  atualizado_em timestamptz not null,
  excluido_em timestamptz,
  primary key (usuario_id, id)
);

create table public.itens_plano (
  usuario_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  sessao_plano_id text not null,
  exercicio_id text not null,
  ordem integer not null,
  series integer not null,
  reps_min integer not null,
  reps_max integer not null,
  rir_alvo integer,
  descanso_s integer not null,
  carga_plan_kg double precision,
  justificativa text,
  fonte_id text,
  atualizado_em timestamptz not null,
  excluido_em timestamptz,
  primary key (usuario_id, id)
);

create table public.treinos (
  usuario_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  sessao_plano_id text not null,
  iniciado_em timestamptz not null,
  finalizado_em timestamptz,
  status text not null,
  modo text not null,
  descanso_termina_em timestamptz,
  descanso_serie_id text,
  atualizado_em timestamptz not null,
  excluido_em timestamptz,
  primary key (usuario_id, id)
);

create table public.series (
  usuario_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  treino_id text not null,
  item_plano_id text,
  exercicio_id text not null,
  numero integer not null,
  carga_plan_kg double precision,
  reps_plan integer,
  carga_kg double precision,
  reps integer,
  rir integer,
  confirmado boolean not null default false,
  editado boolean not null default false,
  dor boolean not null default false,
  aquecimento boolean not null default false,
  manter_carga boolean not null default false,
  registrada_em timestamptz not null,
  atualizado_em timestamptz not null,
  excluido_em timestamptz,
  primary key (usuario_id, id)
);

create table public.substituicoes (
  usuario_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  item_plano_id text not null,
  exercicio_original_id text not null,
  exercicio_novo_id text not null,
  escopo text not null,
  treino_id text,
  carga_kg double precision,
  carga_original_kg double precision,
  atualizado_em timestamptz not null,
  excluido_em timestamptz,
  primary key (usuario_id, id)
);

create table public.ajustes_execucao (
  usuario_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  treino_id text not null,
  item_plano_id text not null,
  progressao_pr boolean not null default false,
  aquecimento boolean not null default false,
  novo_zero_respondido boolean not null default false,
  removido boolean not null default false,
  dor boolean not null default false,
  atualizado_em timestamptz not null,
  excluido_em timestamptz,
  primary key (usuario_id, id)
);

create table public.preferencias (
  usuario_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  sugestao_carga_menor boolean not null default true,
  modo_novo_zero text not null default '1rm',
  atualizado_em timestamptz not null,
  excluido_em timestamptz,
  primary key (usuario_id, id)
);

-- Índice para "o que mudou desde o último download", em todas as tabelas.
create index planos_treino_atualizado on public.planos_treino (usuario_id, atualizado_em);
create index sessoes_plano_atualizado on public.sessoes_plano (usuario_id, atualizado_em);
create index itens_plano_atualizado on public.itens_plano (usuario_id, atualizado_em);
create index treinos_atualizado on public.treinos (usuario_id, atualizado_em);
create index series_atualizado on public.series (usuario_id, atualizado_em);
create index substituicoes_atualizado on public.substituicoes (usuario_id, atualizado_em);
create index ajustes_execucao_atualizado on public.ajustes_execucao (usuario_id, atualizado_em);
create index preferencias_atualizado on public.preferencias (usuario_id, atualizado_em);

-- Row Level Security: cada pessoa só vê e grava as próprias linhas.
-- `(select auth.uid())` é avaliado uma vez por consulta, não por linha.
do $$
declare
  tabela text;
begin
  foreach tabela in array array[
    'planos_treino', 'sessoes_plano', 'itens_plano', 'treinos', 'series',
    'substituicoes', 'ajustes_execucao', 'preferencias'
  ]
  loop
    execute format('alter table public.%I enable row level security', tabela);
    execute format(
      'create policy "dono le" on public.%I for select to authenticated using (usuario_id = (select auth.uid()))',
      tabela
    );
    execute format(
      'create policy "dono insere" on public.%I for insert to authenticated with check (usuario_id = (select auth.uid()))',
      tabela
    );
    execute format(
      'create policy "dono altera" on public.%I for update to authenticated using (usuario_id = (select auth.uid())) with check (usuario_id = (select auth.uid()))',
      tabela
    );
    execute format(
      'create policy "dono apaga" on public.%I for delete to authenticated using (usuario_id = (select auth.uid()))',
      tabela
    );
    execute format('revoke all on public.%I from anon', tabela);
    execute format('grant select, insert, update, delete on public.%I to authenticated', tabela);
  end loop;
end
$$;

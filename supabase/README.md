# Supabase do Caramelo Mutante

Backup opcional da etapa 5. O app funciona sem ele; com ele, os treinos sobem
para o projeto `mmitzourarmxhxnrbgxt` (organização pessoal).

Nada daqui guarda segredo: a chave do Resend e a secret key do Supabase ficam
só no painel do Supabase.

## 1. Tabelas

Rodar [`migrations/20261108120000_backup_caramelo.sql`](migrations/20261108120000_backup_caramelo.sql)
no **SQL Editor**. Cria as 8 tabelas com RLS (cada pessoa só lê e grava as
próprias linhas) e tira todo acesso de quem não fez login.

Conferir de fora, sem login (todas devem responder `401 permission denied`):

```bash
curl -s "$SUPABASE_URL/rest/v1/treinos?select=id" -H "apikey: $SUPABASE_PUBLISHABLE_KEY"
```

## 2. Login por código

O app pede um código de 6 dígitos por e-mail (`signInWithOtp` + `verifyOTP`),
não um link.

- **Authentication → Emails → Templates**: em **Magic Link** e em
  **Confirm signup** (usado no primeiro login de um e-mail novo), o corpo é
  o modelo [`templates/email-codigo.html`](templates/email-codigo.html), que
  mostra `{{ .Token }}`. Assunto: `Seu código do Caramelo Mutante`.

  Sem `{{ .ConfirmationURL }}`: o link levaria para o Site URL
  (`localhost:3000`) e não faz login no app.

- **Authentication → Sign In / Providers → Email**: Email OTP Length = **6**
  (o projeto novo vem com 8, e o app pede 6) e Email OTP Expiration = 600 s.

## 3. Envio de e-mail (Resend)

O carteiro padrão do Supabase manda só 2 e-mails por hora no projeto todo.
Por isso o envio sai pelo Resend:

- **Authentication → Emails → SMTP Settings → Enable Custom SMTP**
  - Sender email: `onboarding@resend.dev`
  - Sender name: `Caramelo Mutante`
  - Host: `smtp.resend.com` · Port: `465` · Username: `resend`
  - Password: API key do Resend (*Sending access*), guardada só aqui
- **Authentication → Rate Limits**: e-mails por hora = 30.

Sem domínio verificado, o Resend só entrega para o e-mail dono da conta do
Resend. Para outras pessoas usarem o app, verificar um domínio no Resend e
trocar o remetente.

## 4. App

Copiar `.env.example` para `.env` (fora do Git) com a URL do projeto e a
**publishable key** (`sb_publishable_...`) e compilar com:

```bash
flutter build apk --debug --dart-define-from-file=.env
```

Nunca colocar a secret key no app.

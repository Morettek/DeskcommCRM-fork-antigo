---
impacto: exige_acao
secao: alterado
titulo: O CRM passa a vir de Morettek/DeskcommCRM, e a telemetria nasce desligada
---
Este repositório segue caminho próprio e deixa de acompanhar o projeto original. O produto é o mesmo; muda de onde ele vem. O kit de instalação clona `https://github.com/Morettek/DeskcommCRM`, as imagens são baixadas de `ghcr.io/morettek` (os nomes `deskcommcrm`, `deskcomm-worker`, `deskcomm-scheduler` e `deskcomm-voice-agent` não mudam), e as versões são cortadas aqui. Antes de criar o projeto Supabase, o `.env` ou o schema, o instalador confere se a imagem do app existe no registro e recusa, nomeando a referência, quando ela ainda não foi publicada ou não é pública. Sem `SENTRY_DSN` configurado, nenhum relatório de erro sai da instalação: o envio automático ao Sentry do projeto original foi desligado, e o instalador não pergunta mais sobre ele. Para receber os erros, aponte `SENTRY_DSN` para o seu próprio Sentry.

## Requer atenção

Só vale depois da primeira versão publicada por este repositório, listada em `https://github.com/Morettek/DeskcommCRM/releases`. Uma instalação feita pelo projeto original que queira passar a seguir este repositório roda, na pasta do CRM na VPS e trocando `<versão>` pela versão publicada aqui (no formato `v1.109.0`): `git remote set-url origin https://github.com/Morettek/DeskcommCRM.git && git fetch --tags --force origin && git checkout <versão> && bash hostgator-setup-kit/update.sh --to <versão> --force`. O `--force` do `git fetch` é obrigatório: os dois repositórios numeram as versões a partir da v1.108.0, e a mesma tag pode apontar para commits diferentes em cada um. O `update.sh` dessa versão faz o backup, atualiza o banco e regrava sozinho as imagens do `.env` para `ghcr.io/morettek`; nenhum arquivo precisa ser editado à mão. Instalações com `SENTRY_DSN` vazio deixam de enviar erros ao Sentry do projeto original sem precisar de ação.

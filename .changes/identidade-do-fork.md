---
impacto: exige_acao
secao: alterado
titulo: O CRM passa a vir de Morettek/DeskcommCRM, e a telemetria nasce desligada
---
Este repositório segue caminho próprio e deixa de acompanhar o projeto original. O produto é o mesmo; muda de onde ele vem. O kit de instalação clona `https://github.com/Morettek/DeskcommCRM`, as imagens são baixadas de `ghcr.io/morettek` (os nomes `deskcommcrm`, `deskcomm-worker`, `deskcomm-scheduler` e `deskcomm-voice-agent` não mudam), e as versões são cortadas aqui. Sem `SENTRY_DSN` configurado, nenhum relatório de erro sai da instalação: o envio automático ao Sentry do projeto original foi desligado, e o instalador não pergunta mais sobre ele. Para receber os erros, aponte `SENTRY_DSN` para o seu próprio Sentry.

## Requer atenção

Uma instalação existente que queira seguir este repositório precisa de duas trocas na VPS, nesta ordem: apontar o `origin` do clone para cá (`git remote set-url origin https://github.com/Morettek/DeskcommCRM.git`) e trocar, no `.env`, o dono das variáveis de imagem `APP_IMAGE`, `WORKER_IMAGE`, `SCHEDULER_IMAGE` e `VOICE_AGENT_IMAGE` de `ghcr.io/melgarafael/` para `ghcr.io/morettek/`, mantendo o nome e a versão de cada imagem. Sem as duas, a instalação continua atualizando a partir do projeto original. Quem tinha deixado `SENTRY_DSN` vazio para mandar erros ao Sentry da comunidade deixa de enviar a partir desta versão.

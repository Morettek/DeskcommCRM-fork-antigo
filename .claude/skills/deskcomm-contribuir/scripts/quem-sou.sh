#!/usr/bin/env bash
# quem-sou.sh — diz se quem está neste clone é o mantenedor do DeskcommCRM ou um
# contribuidor, e POR QUÊ. A skill deskcomm-contribuir (e os hooks) usam a
# primeira palavra da saída; o resto é para gente ler.
#
# Sinais, em ordem de custo (nenhum toca a rede sem `gh` já logado):
#   1. o e-mail do git está no .mailmap do repo como o dono do produto;
#   2. o `gh` está logado como o dono do produto;
#   3. o `origin` é o repositório principal ou um fork (informativo).
# O dono é UM login, `DONO_DO_PRODUTO`, em dono.sh (ao lado deste arquivo).
#
# Uso: bash quem-sou.sh            → "mantenedor — ..." ou "contribuidor — ..."
#      bash quem-sou.sh --curto    → só a palavra
# Sai sempre com 0: identidade é informação, não veredito.
set -uo pipefail

# Sem dono.sh (cópia antiga dos guias), o dono fica vazio e ninguém vira mantenedor
# por engano: na dúvida, o lembrete do contribuidor aparece.
DONO_DO_PRODUTO=""
. "$(dirname "${BASH_SOURCE[0]}")/dono.sh" 2>/dev/null || true
dono_min="$(tr 'A-Z' 'a-z' <<<"$DONO_DO_PRODUTO")"

raiz="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$raiz" ]; then
  [ "${1:-}" = "--curto" ] && echo "contribuidor" || echo "contribuidor — fora de um clone git"
  exit 0
fi

email="$(git -C "$raiz" config user.email 2>/dev/null || true)"
origin="$(git -C "$raiz" remote get-url origin 2>/dev/null || true)"
motivo=""

# 1) .mailmap: as linhas do dono começam com o login dele e listam cada e-mail
#    provado entre <>. Lido do arquivo, não copiado para cá — a fonte é uma só.
if [ -n "$DONO_DO_PRODUTO" ] && [ -n "$email" ] && [ -f "$raiz/.mailmap" ]; then
  # Duas etapas e busca LITERAL (-F): o e-mail do noreply do GitHub tem "+", que
  # numa expressão regular quer dizer outra coisa e fazia esse e-mail não casar.
  if grep -i "^${DONO_DO_PRODUTO} <" "$raiz/.mailmap" 2>/dev/null | grep -qiF "<${email}>"; then
    motivo="o e-mail do git ($email) está no .mailmap como o dono do produto"
  fi
fi

# 2) gh logado como o dono (só se o gh existe; nunca pede login).
if [ -z "$motivo" ] && [ -n "$DONO_DO_PRODUTO" ] && command -v gh >/dev/null 2>&1; then
  login="$(gh api user --jq .login 2>/dev/null || true)"
  # Login do GitHub não distingue caixa: `morettek` e `Morettek` são a mesma conta.
  [ "$(tr 'A-Z' 'a-z' <<<"$login")" = "$dono_min" ] && motivo="o gh está logado como @$login"
fi

case "$(tr 'A-Z' 'a-z' <<<"$origin")" in
  *github.com[:/]"$dono_min"/deskcommcrm*) remoto="origin é o repositório principal" ;;
  "")                                       remoto="sem origin configurado" ;;
  *)                                        remoto="origin é um fork ($origin)" ;;
esac

if [ -n "$motivo" ]; then
  [ "${1:-}" = "--curto" ] && echo "mantenedor" || echo "mantenedor — $motivo; $remoto"
else
  [ "${1:-}" = "--curto" ] && echo "contribuidor" || echo "contribuidor — e-mail do git: ${email:-não configurado}; $remoto"
fi
exit 0

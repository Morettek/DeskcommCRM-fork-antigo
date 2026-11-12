import { readFileSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

const RAIZ = process.cwd();
const template = readFileSync(join(RAIZ, ".env.hostgator.example"), "utf8");
const install = readFileSync(join(RAIZ, "hostgator-setup-kit/install.sh"), "utf8");

function linhasAtivasDaChave(texto: string, chave: string): string[] {
  return texto
    .split("\n")
    .map((linha) => linha.trim())
    .filter((linha) => linha.startsWith(`${chave}=`));
}

describe("consentimento de telemetria no primeiro install", () => {
  it("o template não decide SENTRY_DSN pela pessoa", () => {
    expect(
      linhasAtivasDaChave(template, "SENTRY_DSN"),
      "SENTRY_DSN ativo no template faz load_env marcar a variável como definida e pula a pergunta de consentimento",
    ).toEqual([]);
    expect(template).toContain("# SENTRY_DSN=");
  });

  it("o instalador distingue primeira execução de uma escolha já gravada", () => {
    expect(install).toContain('if [ -z "${SENTRY_DSN+x}" ]; then');
    expect(install).toContain('SENTRY_DSN="off"');
    expect(install).toContain('envq SENTRY_DSN "${SENTRY_DSN:-}"');
  });

  it("o instalador não oferece enviar a um Sentry que não existe", () => {
    // Não há Sentry de comunidade (lib/sentry/dsn.ts): um "sim" aqui não enviaria
    // nada, e o instalador agradeceria por uma telemetria desligada.
    expect(install).not.toContain("Enviar relatórios de erro anonimizados");
    expect(install).not.toContain("Sentry da comunidade, com");
  });

  it("a documentação do template explica o padrão desligado e as duas escolhas", () => {
    expect(template).toContain("DESLIGADA por padrão");
    expect(template).toContain("SENTRY_DSN=off");
    expect(template).toContain("SENTRY_DSN=<seu-dsn>");
    expect(template).not.toContain("aceita o Sentry da comunidade");
  });
});

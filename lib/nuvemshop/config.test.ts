import { describe, expect, it, vi } from "vitest";

// A barra final é de propósito: o contato sai sem ela.
vi.mock("@/lib/env", () => ({ env: { NEXT_PUBLIC_APP_URL: " https://crm.loja.test/ " } }));

import { appUserAgent } from "./config";

describe("User-Agent da Nuvemshop", () => {
  it("leva o nome do app e, entre parênteses, o contato da instalação — o formato que a Nuvemshop pede", () => {
    // O nome do app não é repetido aqui de propósito: tests/unit/branding.test.ts
    // conta a marca também nos testes. O que se cobra é a forma "Nome (contato)".
    expect(appUserAgent()).toMatch(/^[A-Za-z]+ \(https:\/\/crm\.loja\.test\)$/);
  });

  it("não leva e-mail de ninguém", () => {
    expect(appUserAgent()).not.toContain("@");
  });
});

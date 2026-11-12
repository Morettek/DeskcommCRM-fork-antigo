---
impacto: nada_mudou
secao: corrigido
titulo: Um teste da automação de ligação perdida deixa de depender da hora em que roda
---

O teste do gatilho "ligação perdida" usava o relógio real e falhava quando a suíte rodava entre 22h e 7h em São Paulo, fora da janela de envio do número. Agora o relógio é fixado dentro da janela. Só teste: nada muda para quem opera a VPS.

# cine-colombia-cli

**Comprar boletas de cine desde la terminal, o pidiéndoselo a Claude.**

Cartelera, teatros, horarios, mapa de sillas en ASCII y compra de boletas de Cine
Colombia sin salir de la consola. Incluye un servidor MCP, así que un agente de IA
puede hacer todo el recorrido conversando: "quiero ver Obsesión el martes en Centro
Mayor, dos sillas juntas".

## Probarlo en 30 segundos

Requiere Node 20+. No hay que clonar ni configurar nada:

```bash
npx cine-colombia-cli cartelera --ciudad bogota
npx cine-colombia-cli horarios "la odisea" --teatro andino
npx cine-colombia-cli asientos 6461-18858
```

Ese último dibuja la sala:

```
           P A N T A L L A
─────────────────────────────────────

    GENERAL (138 libres)
   A ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○
   B ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○
   C ○ ○ ○ ○ ○ ○ ● ● ○ ○ ○ ○ ○ ○
   ...
```

Los huecos son pasillos reales y la silla 1 queda a la derecha, igual que en la carta
de Cine Colombia.

## Usarlo con Claude

```json
{
  "mcpServers": {
    "cine-colombia": {
      "command": "npx",
      "args": ["-y", "--package=cine-colombia-cli", "cine-mcp"]
    }
  }
}
```

Diez herramientas. `cotizar_compra` es de solo lectura; `crear_orden` aparta sillas
reales y **exige `confirmar: true`** por esquema, no por prompt — un modelo no puede
comprar por su cuenta ni equivocándose de tipo.

## Qué tiene de interesante

- **No es scraping de HTML.** Se ingenió a la inversa la API interna de Vista Cinema
  (OCAPI) grabando el tráfico del sitio, y se consume JSON directo.
- **Cloudflare discrimina por el casing de los headers HTTP.** `User-Agent` pasa,
  `user-agent` recibe 403. Como la spec de `Headers` obliga a minúsculas, el `fetch` de
  cualquier runtime es estructuralmente incapaz de pasar; se usa un subproceso `curl`.
- **El mapa de sillas sale de la geometría de la sala**, no de las etiquetas: la silla
  `A16` está en la columna 18, y el eje horizontal va espejado respecto de la API para
  coincidir con la sala física.
- **Salvaguardas en código, no en instrucciones**: confirmación explícita, `--dry-run`,
  y cancelación automática de la orden en cualquier fallo o Ctrl+C.
- 215 tests sin red, type-check y lint en verde, más un smoke test contra la API real.

## Límites, dichos de frente

- **El pago lo completa una persona.** La pasarela es PCI con fingerprinting
  antifraude; automatizarla no es viable ni correcto. La CLI llega hasta generar el
  enlace de pago.
- **El login necesita una persona** por el reCAPTCHA: abre un navegador real y solo
  captura la cookie. La contraseña nunca pasa por la CLI.
- **La sesión de cuenta dura poco.** La cookie declara 30 días, pero el servidor la
  invalida entre los 15 y 20 minutos (medido). Comprar como invitado no la necesita.

## Enlaces

- Código y documentación completa: https://github.com/JGaldo-beep/cine-colombia-cli
- Paquete: https://www.npmjs.com/package/cine-colombia-cli

Construido en Platanus Build Night — Bogotá @ Buk, con Claude Opus 5.
MIT.

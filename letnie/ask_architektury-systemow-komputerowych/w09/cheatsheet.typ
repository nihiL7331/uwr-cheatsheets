#set page(
  paper: "us-letter",
  fill: rgb("121212"),
  margin: 0.25in,
  footer: align(right)[
    #text(fill: rgb("333333"), size: 8pt)[
      Patryk Pujanek | gh: \@nihiL7331
    ]
  ],
)

#set text(
  font: "Iosevka NF",
  fill: rgb("e4e4e4"),
  size: 7.75pt,
  lang: "pl",
  region: "pl",
)

#show: rest => columns(2, rest)

#show heading.where(level: 2): it => block(
  width: 100%,
  fill: rgb("1e1e1e"),
  inset: 8pt,
  stroke: (left: 3pt + rgb("2188FF")),
  [*#it.body*],
)

#show raw: set text(font: "BigBlueTerm437 Nerd Font Mono")
#show strong: set text(fill: white, weight: 700)

#show raw.where(block: true): block.with(
  fill: rgb("1e1e1e"),
  inset: 10pt,
  radius: 4pt,
  stroke: rgb("333333"),
  width: 100%,
)

#show raw.where(block: false): box.with(
  fill: rgb("2a2a2a"),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show math.equation: set text(size: 1.15em)

#let split-reg16(r16, r8_h, r8_l, clr) = {
  box(
    fill: rgb("3F3F3F44"),
    inset: 3pt,
    width: 100%,
  )[
    #stack(
      dir: ttb,
      spacing: 4pt,
      align(center)[#text(
        font: "BigBlueTerm437 Nerd Font Mono",
        fill: rgb("8b949e"),
      )[#r16]],
      grid(
        columns: (1fr, 1fr),
        align: (left, right),
        text(font: "BigBlueTerm437 Nerd Font Mono", fill: rgb("8b949e"))[#r8_h],
        text(font: "BigBlueTerm437 Nerd Font Mono", fill: rgb("8b949e"))[#r8_l],
      ),
    )
  ]
}

#let sub-reg(name, clr, content) = {
  box(
    stroke: (top: 2pt + clr),
    fill: rgb("3F3F3F44"),
    inset: 3pt,
    width: 100%,
  )[
    #grid(
      columns: (1fr, 1.5fr),
      align: horizon,
      text(font: "BigBlueTerm437 Nerd Font Mono", fill: rgb("e4e4e4"))[#name],
      content,
    )
  ]
}

#let reg(name, clr) = {
  let numbered = name.match(regex("\d+")) != none
  let (r64, r32, r16, r8_l, r8_h) = ("%" + name, "", "", "", "")

  if numbered {
    r32 = "%" + name + "d"
    r16 = "%" + name + "w"
    r8_l = "%" + name + "b"
  } else {
    let core = name.slice(1, 2)
    let suffix = name.slice(2, 3)
    r32 = "%e" + core + suffix
    r16 = "%" + core + suffix
    if suffix == "x" {
      r8_h = "%" + core + "h"
      r8_l = "%" + core + "l"
    } else {
      r8_l = "%" + core + suffix + "l"
    }
  }
  sub-reg(r64, clr, sub-reg(r32, rgb("3F3F3F44"), split-reg16(
    r16,
    r8_h,
    r8_l,
    rgb("3F3F3F44"),
  )))
}

#let reg-pair(reg1, reg2, clr1: rgb("3F3F3F44"), clr2: rgb("3F3F3F44")) = {
  grid(
    columns: (1fr, 1fr),
    gutter: 10pt,
    reg(reg1, clr1), reg(reg2, clr2),
  )
  v(0.4em)
}

#let reg-desc(name, desc) = {
  grid(
    columns: (45pt, 1fr),
    gutter: 8pt,
    [*#name*], desc,
  )
  v(0.2em)
}

#let addr-row(name, synt, calc) = {
  grid(
    columns: (35%, 25%, 1fr),
    gutter: 10pt,
    align: (left, left, left),
    [*#name*], raw(synt), calc,
  )
  v(0.4em)
}
#let hregs(clr, body) = [
  #show regex("[%,\-]"): set text(fill: white)
  #text(fill: clr)[#body]
]

= Architektury systemów komputerowych: Reference
*Data:* #datetime.today().display() \
*Zakres:* Do wykładu 9 włącznie

== 1. Rejestry x86\_64
#reg-pair("rax", "rbx")
#reg-pair("rcx", "rdx")
#reg-pair("rsi", "rdi")
#reg-pair("rbp", "rsp", clr2: rgb("D73A49"))
#reg-pair("r8", "r9")
#v(2pt)
#align(center)[
  #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
    *Uwaga:* Rejestry od %r10 do %r15 używają schematu: \
    #raw("%r10"), #raw("%r10d"), #raw("%r10w"), #raw("%r10b").
  ]
]

=== Rejestry ogólnego przeznaczenia
#reg-desc(
  `%rax`,
  [Akumulator. Główny rejestr arytmetyczny. Przechowuje *wartość zwracaną* z funkcji.],
)
#reg-desc(`%rbx`, [Rejestr bazowy. Callee-saved.])
#reg-desc(`%rcx`, [Licznik w pętlach i przesunięciach bitowych. *4. argument*.])
#reg-desc(
  `%rdx`,
  [Rejestr danych. Używany w mnożeniu/dzieleniu. *3. argument*.],
)

=== Indeksy i wskaźniki
#reg-desc(`%rdi`, [Indeks docelowy (DI). *1. argument*.])
#reg-desc(`%rsi`, [Indeks źródłowy (SI). *2. argument*.])
#reg-desc(
  `%rsp`,
  [Wskaźnik stosu (SP). Wskazuje wierzchołek ramki. Modfikowany przez `push`/`pop`/`call`/`ret`.],
)
#reg-desc(`%rbp`, [Wskaźnik bazy (BP). Początek ramki stosu. Callee-saved.])

=== Nowe i specjalne rejestry
#reg-desc(`%r8-9`, [Kolejno: *5. i 6. argument*. Caller-saved.])
#reg-desc(`%r10 oraz %r11`, [Rejestry tymczasowe. Caller-saved.])
#reg-desc(`%r12 do %r15`, [Ogólnego przeznaczenia. Wszystkie *callee-saved*.])
#reg-desc(
  `%rip`,
  [Wskaźnik instrukcji (IP). Następna instrukcja. Modyfikowany przez skoki i wywolania.],
)
#reg-desc(`%rflags`, [Rejestr flag statusu. Zmieniany przez `cmp`, `test`.])

=== Rejestry wektorowe (zmiennoprzecinkowe)
#reg-desc(
  `%xmm0 do %xmm15`,
  [128-bitowe rejestry. `%xmm0` to *wartość zwracana* (float/double). `%xmm0-%xmm7` to pierwsze *8 argumentów*. Wszystkie są *caller-saved*.],
)
#reg-desc(
  `%ymm0 do %ymm15`,
  [256-bitowe rozszerzenie rejestrów XMM. Dzielą z nimi najmłodsze 128 bitów.],
)

#colbreak()
== 2. Flagi stanu (Rejestr `%rflags`)
#reg-desc(`ZF`, [Zero. Wynik to 0 (np. argumenty są równe).])
#reg-desc(`SF`, [Sign. Wynik jest ujemny (MSB = 1).])
#reg-desc(`CF`, [Carry. Przepełnienie dla liczb *bez znaku* (unsigned).])
#reg-desc(`OF`, [Overflow. Przepełnienie dla liczb *ze znakiem* (signed).])

== 3. Tryby adresowania (operandy)
#v(0.5em)
#grid(
  columns: (35%, 25%, 1fr),
  gutter: 10pt,
  text(fill: rgb("8b949e"))[*Tryb*],
  text(fill: rgb("8b949e"))[*Format*],
  text(fill: rgb("8b949e"))[*Obliczanie adresu*],
)
#line(length: 100%, stroke: rgb("333333"))
#v(0.5em)

#addr-row("Natychmiastowy (Immediate)", "$Imm", [`Imm`])
#addr-row("Rejestrowy (Register)", "%Ra", [`%Ra`])
#addr-row("Bezpośredni (Direct)", "Imm", [`M[Imm]`])
#addr-row("Pośredni (Indirect)", "(%Rb)", [`M[%Rb]`])
#addr-row(
  "Z przesunięciem (Indirect displacement)",
  "D(%Rb)",
  [`M[%Rb + D]`],
)
#addr-row(
  "Skalowany (Indirect scaled-index)",
  "D(%Rb, %Ri, S)",
  [`M[%Rb+%Ri*S+D]`],
)
#addr-row(
  "Skalowany (baseless)",
  "(, %Ri, S)",
  [`M[%Ri * S]`],
)

#v(2pt)
#align(center)[
  #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
    *Legenda:* `Imm` / `D` to stała liczbowa, `%Ra` / `%Rb` to rejestr bazowy, \
    `%Ri` to rejestr indeksowy, a `S` to skala (tylko wartości: 1, 2, 4 lub 8).
  ]
]

== 4. Konwencja wywoływań (System V AMD64 ABI)
#align(center)[*Przekazywanie argumentów*]
#align(center)[
  #box(fill: rgb("1a1a1a"), inset: 6pt, stroke: (top: 2pt + rgb("333333")))[
    #show regex("%"): set text(fill: white)
    #show math.equation: set text(fill: rgb("e4e4e4"))
    #text(fill: rgb("D73A49"))[
      `%rdi` $arrow.r$ `%rsi` $arrow.r$ `%rdx` $arrow.r$ `%rcx` $arrow.r$ `%r8` $arrow.r$ `%r9`
    ]
  ]
]
#align(center)[
  #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
    / Argumenty 7+: Na stosie od końca.
    / Wynik: Zawsze w #[
        #show regex("%"): set text(fill: white)
        #text(fill: rgb("D73A49"))[`%rax`].
      ]
  ]
]

#align(center)[*Ochrona rejestrów (ABI)*]
#v(4pt)
#table(
  columns: (1fr, 1fr),
  stroke: none,
  column-gutter: 10pt,

  table.cell(
    fill: rgb("1a1a1a"),
    stroke: (top: 2pt + rgb("D73A49")),
    inset: 8pt,
  )[
    *Caller-saved* \
    #text(fill: rgb("8b949e"), size: 8.5pt)[(Można niszczyć)] \
    #v(4pt)
    #hregs(rgb("D73A49"))[`%rax`, `%rdi`, `%rsi`, `%rdx`, `%rcx`, `%r8`-`%r11`]
  ],

  table.cell(
    fill: rgb("1a1a1a"),
    stroke: (top: 2pt + rgb("28A745")),
    inset: 8pt,
  )[
    *Callee-saved* \
    #text(fill: rgb("8b949e"), size: 8.5pt)[(Musi przywrócić)] \
    #v(4pt)
    #hregs(rgb("28A745"))[`%rbx`, `%rbp`, `%r12`-`%r15`]
  ],
)

#align(center)[*Ramka Stosu*]
#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  box(fill: rgb("1a1a1a"), stroke: (top: 2pt + rgb("333333")), inset: 8pt)[
    *Start* (alokacja)
    ```asm
    push %rbp
    mov  %rsp, %rbp
    sub  $32, %rsp
    ```
  ],
  box(fill: rgb("1a1a1a"), stroke: (top: 2pt + rgb("333333")), inset: 8pt)[
    *Koniec* (sprzątanie)
    ```asm
    leave
    ret
    /* równowaznie:
    * mov %rbp, %rsp
    * pop %rbp
    * ret */
    ```
  ],
)

#colbreak()
== 5. Struktury i wyrównanie
+ *Wyrównanie pola ($K$):* Zmienna $K$-bajtowa pod adresem $\pmod K = 0$.
+ *Rozmiar całkowity:* Całkowity `sizeof` struktury musi być podzielny przez największe wyrównanie w strukturze ($K_max$).
```c
struct {
  char  c;  // 1 bajt (offset 0)
            // [3 bajty wewn. paddingu]
  int   i;  // 4 bajty (offset 4)
  short s;  // 2 bajty (offset 8)
            // [2 bajty zewn. paddingu]
} // K_max = 4. Rozmiar: 1+3+4+2+2 = 12 bajtów.
```

== 6. Najważniejsze instrukcje (AT&T)
#table(
  columns: (30%, 30%, 1fr),
  stroke: none,
  row-gutter: 0.5em,
  align: horizon,
  table.header(
    text(fill: rgb("8b949e"))[*Opcode*],
    text(fill: rgb("8b949e"))[*Efekt*],
    text(fill: rgb("8b949e"))[*Opis*],
  ),
  table.hline(stroke: rgb("333333")),

  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Przesyłanie danych*],
  raw("mov S, D"), $D arrow.l S$, [Kopiuje wartość z S do D.],
  raw("push S"),
  $"%rsp" -= 8 \ M["%rsp"] arrow.l S$, [Odkłada na stos.],
  raw("pop D"), $D arrow.l M["%rsp"] \ "%rsp" += 8$, [Zdejmuje ze stosu do D.],
  raw("leave"), $"%rsp" arrow.l "%rbp" \ "pop" "%rbp"$, [Sprząta ramkę stosu.],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Adresowanie i arytmetyka*],
  raw("lea S, D"),
  $D arrow.l "addr"(S)$,
  [Oblicza adres S (bez czytania pamięci).],
  raw("add S, D"), $D arrow.l D + S$, [Dodawanie (ustawia flagi).],
  raw("sub S, D"), $D arrow.l D - S$, [Odejmowanie (ustawia flagi).],
  raw("imul S, D"), $D arrow.l D * S$, [Mnożenie liczb ze znakiem.],
  raw("inc / dec D"),
  $D arrow.l D plus.minus 1$,
  [Inkrementacja / dekrementacja.],
  raw("neg D"), $D arrow.l -D$, [Negacja arytmetyczna (jak w U2).],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Dzielenie (zawsze w parze)*],
  raw("cqto"),
  $"%rdx:%rax" arrow.l "sgn_ext"("%rax")$,
  [*Uwaga:* Rozszerza %rax do $128$-bit przed `idivq`.],
  raw("idiv S"),
  $"%rax" arrow.l "wynik" \ "%rdx" arrow.l "reszta"$,
  [Dzielenie `%rdx:%rax` przez S. Wynik w `%rax`, reszta w `%rdx`.],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Logiczne i bitowe*],
  raw("and / or S, D"),
  $D arrow.l D "& / |" S$,
  [Operacje bitowe (ustawiają flagi).],
  raw("xor S, D"),
  $D arrow.l D "^" S$,
  [Często używane jako `xor %rax, %rax` do zerowania.],
  raw("not D"), $D arrow.l ~D$, [Negacja bitowa (odwrócenie bitów).],
  raw("sal / shl k, D"),
  $D limits(<<)= k$,
  [Przesunięcie w lewo (mnożenie przez $2^k$).],
  raw("sar k, D"),
  $D limits(>>)= k$,
  [Arytmetyczne w prawo (dzielenie). *Kopiuje znak*.],
  raw("shr k, D"), $D limits(>>)= k$, [Logiczne w prawo. Dopełnia zerami.],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Porównania i skoki*],
  raw("cmp S1, S2"),
  $"S2" - "S1"$,
  [Ustawia flagi jak odejmowanie, nie zapisuje wyniku.],
  raw("test S1, S2"),
  $"S2 & S1"$,
  [Ustawia flagi jak *AND* (np. test czy rejestr jest zerem).],
  raw("jX dest"),
  $"if"(X) "%rip" arrow.l "dest"$,
  [Skok warunkowy (X = warunek).],
  raw("setX D"),
  $"if"(X) D arrow.l 1$,
  [Ustawia bajt (np. `%al`) na 0 lub 1 na podstawie flag.],
  raw("cmovX S, D"),
  $"if"(X) D arrow.l S$,
  [Warunkowe kopiowanie (optymalizacja zamiast skoku).],
  raw("call / ret"), [], [Skok do funkcji / Powrót (obsługa stosu i `%rip`).],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Operacje wektorowe*],
  raw("movaps / movups S, D"),
  $D arrow.l S$,
  [Kopiuje 128-bitów. `aps` (aligned) – wymaga wyrównania w pamięci, `ups` nie.],
  raw("movsd / movss S, D"),
  $D arrow.l S$,
  [Kopiuje pojedynczą wartość skalarną (`double`/(s)`float`).],
  raw("add/sub/mul/div pd/ps"),
  $D arrow.l D "op" S$,
  [Arytmetyka wektorowa. Wykonuje operację na wielu parach równocześnie.],
  raw("add/sub/mul/div sd/ss"),
  $D arrow.l D "op" S$,
  [Arytmetyka skalarna. Modyfikuje tylko najmłodszą wartość w rejestrze.],
  raw("vxorps S1, S2, D"),
  $D arrow.l "S2 ^ S1"$,
  [Wektorowy *XOR*.],
  raw("v... (np. vmulss)"),
  $D arrow.l "S2 op S1"$,
  [Przedrostek `v` wprowadza 3 argumenty (źródło 1, źródło 2, cel). Nie niszczy danych wejściowych.],
  raw("vfmadd231ss S1, S2, D"),
  $D arrow.l "S2" * "S1" + D$,
  [*Fused Multiply-Add*. Mnoży i dodaje. Cyfry `231` określają, że mnożymy dwa źródła, a wynik dodajemy do `D`.],
)

#v(2pt)
#align(center)[
  #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
    *Uwaga o sufiksach:* Instrukcje mogą przyjmować sufiks określający rozmiar danych: \
    #raw("b") (byte, $8$-bit), #raw("w") (word, $16$-bit), #raw("l") (long, $32$-bit), #raw("q") (quadword, $64$-bit). \
    Np. `movq` kopiuje $64$ bity, a `movl` kopiuje $32$ bity (i zeruje górną połowę rejestru!).
  ]
]

#colbreak()
== 7. Sufiksy warunkowe (dla `jX`, `setX`, `cmovX`)
#table(
  columns: (20%, 25%, 1fr),
  stroke: none,
  row-gutter: 0.4em,
  align: horizon,
  table.header(
    text(fill: rgb("8b949e"))[*Sufiks*],
    text(fill: rgb("8b949e"))[*Synonim*],
    text(fill: rgb("8b949e"))[*Znaczenie / Warunek*],
  ),
  table.hline(stroke: rgb("333333")),

  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Równość i znak (`ZF`, `SF`)*],
  raw("e"), raw("z"), [Equal / Zero (równe / wynik to $0$)],
  raw("ne"), raw("nz"), [Not Equal / Not Zero (nierówne)],
  raw("s"), [], [Sign (wynik ujemny, `SF=1`)],
  raw("ns"), [], [Not Sign (wynik dodatni lub $0$, `SF=0`)],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Liczby ze znakiem (signed)*],
  raw("g"), [], [Greater],
  raw("ge"), [], [Greater or Equal],
  raw("l"), [], [Less],
  raw("le"), [], [Less or Equal],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 3,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Liczby bez znaku (unsigned)*],
  raw("a"), [], [Above (powyżej: `>`)],
  raw("ae"), raw("nc"), [Above or Equal / No Carry (większe równe: `>=`)],
  raw("b"), raw("c"), [Below / Carry (poniżej: `<`)],
  raw("be"), [], [Below or Equal (mniejsze równe: `<=`)],
)

== 8. Optymalizacje i atrybuty
#table(
  columns: (25%, 75%),
  stroke: none,
  row-gutter: 0.5em,
  align: horizon,

  table.hline(stroke: rgb("333333")),
  table.cell(
    colspan: 2,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Podstawowe techniki*],
  [*Strength red.*],
  [Zamiana drogich operacji na tańsze (np. `mul` $arrow.r$ `lea` / `shl`).],
  [*Loop unroll.*],
  [Rozwinięcie pętli (np. skok co 4. iterację). Mniej skoków = mniejszy narzut.],
  [*Code motion*],
  [Wyrzucenie obliczeń niezmienników (np. stałych w pętli) przed pętlę.],
  [*Common subexpr. elim.*],
  [Obliczenie wspólnego fragmentu tylko raz.],
  [*Const folding*],
  [Obliczanie stałych wyrażeń (np. `2+2`) w czasie kompilacji.],
  [*Branch predict*],
  [Sprzętowe przewidywanie skoków. By unikać kar, mozna użyc `cmovX`.],
  [*Inlining*],
  [Wklejenie ciała funkcji w miejsce wywołania. Eliminuje narzut `call`/`ret`.],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 2,
    fill: rgb("1a1a1a"),
    align: center,
  )[*Analiza pamięci i atrybuty GCC*],
  [*Aliasing*],
  [Problem nakładania się wskaźników. Keyword `restrict`, pomaga w optymalizacji.],
  [*pure / const*],
  [Funkcja bez skutków ubocznych (`const` dodatkowo nie czyta zmiennych globalnych).],
)

== 9. Bezpieczeństwo kodu i exploity
#table(
  columns: (25%, 75%),
  stroke: none,
  row-gutter: 0.5em,
  align: horizon,

  table.hline(stroke: rgb("333333")),
  table.cell(
    colspan: 2,
    fill: rgb("251414"),
    align: center,
  )[*Zagrożenia i błędy*],
  [*Buffer overflow*],
  [Zapis poza limit bufora. Nadpisuje sąsiadującą pamięć.],
  [*Seg fault*],
  [Próba dostępu bez uprawnień (np. odczyt `NULL`, modyfikacja read-only).],
  [*Stack smashing*],
  [Atak nadpisujący *adres powrotu* na stosie, by przejąć kontrolę po `ret`.],
  [*ROP (Gadżety)*],
  [Łączenie legalnych instrukcji kończących się `ret` w celu ominięcia zabezpieczeń.],

  table.hline(stroke: rgb("222222")),
  table.cell(
    colspan: 2,
    fill: rgb("142517"),
    align: center,
  )[*Mechanizmy obronne*],
  [*Stack canaries*],
  [Losowa wartość ułożona przed adresem powrotu. Weryfikowana przed `ret`.],
  [*Nonexec code segments*],
  [Stos dostaje sprzętowy zakaz wykonywania kodu (tylko R/W).],
  [*Rand. stack offsets*],
  [Losowanie adresów stosu przy każdym starcie.],
)

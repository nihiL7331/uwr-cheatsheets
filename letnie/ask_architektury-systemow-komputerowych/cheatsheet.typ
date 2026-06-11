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

#set heading(numbering: (..n) => {
  let n = n.pos()
  if n.len() == 2 { numbering("1.", n.last()) }
})
#show heading.where(level: 2): it => block(
  width: 100%,
  fill: rgb("1e1e1e"),
  inset: 8pt,
  stroke: (left: 3pt + rgb("2188FF")),
  [*#counter(heading).display(it.numbering) #it.body*],
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

#let LECTURE-NUM-FROM = int(sys.inputs.at("od", default: "1"))
#let LECTURE-NUM-TO = int(sys.inputs.at("do", default: "13"))
#let from(n, body) = if LECTURE-NUM-TO >= n and n >= LECTURE-NUM-FROM { body }

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
*Zakres:* #LECTURE-NUM-FROM - #LECTURE-NUM-TO

#from(1)[
  == Logika cyfrowa
  #table(
    columns: (25%, 32%, 1fr),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.header(
      text(fill: rgb("8b949e"))[*Układ*],
      text(fill: rgb("8b949e"))[*Formuła / sygnatura*],
      text(fill: rgb("8b949e"))[*Opis*],
    ),
    table.hline(stroke: rgb("333333")),

    table.cell(
      colspan: 3,
      fill: rgb("1a1a1a"),
      align: center,
    )[*Sumatory*],
    [*Półsumator*],
    [#raw("s = x ^ y") \ #raw("c = x & y")],
    [Dodaje dwa bity. `s` to suma, `c` to bit przeniesienia (carry).],
    [*Pełny sumator (FA)*],
    [#raw("s = x ^ y ^ ci") \ #raw("co=x&y|ci&(x^y)")],
    [Jak półsumator, ale przyjmuje też przeniesienie wejściowe `ci`.],
    [*Sumator n-bitowy*],
    [$n times$ FA],
    [Kaskada (ripple-carry): wyjście $C_(i)$ trafia na wejście kolejnego FA. Ostatnie `co` to *Carry Out* całości.],

    table.hline(stroke: rgb("222222")),
    table.cell(
      colspan: 3,
      fill: rgb("1a1a1a"),
      align: center,
    )[*Układy kombinacyjne*],
    [*Dekoder*],
    [$n arrow.r 2^n$],
    [Wejście koduje liczbę $k$. Na wyjściu zapalony jest *tylko* bit nr $k$.],
    [*Multiplekser*],
    [$2^n + n arrow.r 1$],
    [$2^n$ bitów danych + $n$ bitów sterujących $S$. Na wyjście przechodzi $S$-ty bit danych.],
    [*ALU*],
    [$A, B, f arrow.r C$],
    [Dekoder na bitach $f$ wybiera operację (np. $A+B$, $A|B$, $A\&B$); multipleksowanie wyników bramkami AND/OR.],

    table.hline(stroke: rgb("222222")),
    table.cell(
      colspan: 3,
      fill: rgb("1a1a1a"),
      align: center,
    )[*Układy sekwencyjne (pamięć)*],
    [*Przerzutnik S-R*],
    [#raw("S") - set, #raw("R") - reset],
    [Przechowuje 1 bit ($Q$). `S=1` ustawia $Q=1$, `R=1` zeruje, `S=R=0` trzyma stan. Zbudowany z dwóch sprzężonych `NOR`-ów.],
    [*Sterowany poziomem*],
    [aktywny gdy #raw("CLK") $= 1$],
    [Wejścia `S`/`R` bramkowane AND-em z zegarem. Stan zmienia się tylko przy `CLK=1`.],
    [*Sterowany zboczem*],
    [zbocze $1 arrow.r 0$],
    [Dwa przerzutniki poziomowe w kaskadzie (master-slave), drugi z zanegowanym zegarem. Stan przepisuje się w *momencie* zmiany zegara.],
  )
]

#from(2)[
  == Bity, bajty i typy danych
  $1B = 8"b", "hex" = 4"b" => 1 B in ["0x00"; "0xFF"]$. Np. $15213 = "0x3B6D"$.
  #v(-2pt)
  #table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    stroke: none,
    align: center,
    row-gutter: 0.2em,
    table.header(
      [*Typ*], `char`, `short`, `int`, `long`, `float`, `double`, `void*`
    ),
    table.hline(stroke: rgb("333333")),
    text(fill: rgb("8b949e"))[*x86-64*], [1], [2], [4], [8], [4], [8], [8],
  )

  #colbreak()
  == Kodowanie liczb i konwersja
  #align(center)[
    $"B2U"(X) = sum_(i=0)^(w-1) x_i 2^i wide "B2T"(X) = -x_(w-1) 2^(w-1) + sum_(i=0)^(w-2) x_i 2^i$ \
    $"T2U"(x) = x < 0 ? x + 2^w : x wide "U2T"(u) = u > "TMax" ? u - 2^w : u$
  ]
  *Skróty:* `B` = bity, `U` = unsigned, `T` = ze znakiem (kod U2). Stąd `B2U` = bity $arrow.r$ unsigned, podobnie `U2T`, `UMax`, `TMax`, `UAdd`, `TAdd`.
  #table(
    columns: (auto, auto, 1fr),
    stroke: none,
    row-gutter: 0.3em,
    align: horizon,
    table.header(
      text(fill: rgb("8b949e"))[*Stała*],
      text(fill: rgb("8b949e"))[*Bity*],
      text(fill: rgb("8b949e"))[*Wartość*],
    ),
    table.hline(stroke: rgb("333333")),
    [*UMax*], `11...1`, [$2^w - 1$],
    [*TMax*], `01...1`, [$2^(w-1) - 1$ (`INT_MAX`)],
    [*TMin*], `10...0`, [$-2^(w-1)$ (`INT_MIN`)],
    [*$-1$*], `11...1`, [te same bity co UMax],
  )
  *Promocja w C:* `unsigned` i `int` w jednym wyrażeniu/porównaniu (`< > ==`) $arrow.r$ `int` promowany do `unsigned` (bity bez zmian, $-1 arrow.r$ UMax).

  == Rozszerzanie, obcinanie i przesunięcia
  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Rozszerz. 0* (`zext`)], [`unsigned`: dopisuje $0$ z góry],
    [*Rozszerz. znak* (`sext`)], [`signed`: powiela bit znaku (MSB)],
    [*Obcięcie* (`trunc`)], [$u mod 2^w$; może zmienić znak],
    `x << k`, [$x dot 2^k$ (sgn./uns.)],
    `u >> k`, [$floor(u \/ 2^k)$ — logiczne (zera)],
    `x >> k`, [arytmetyczne (kopia MSB), zaokr. do $-oo$],
    [$x \/ 2^k$ do $0$], `(x + (1<<k)-1) >> k`,
  )
  Strength red.: `x*24` $arrow.r$ `(x<<5)-(x<<3)`.

  == Operacje, overflow i endianness
  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*UAdd*], [$(u+v) mod 2^w$; carry ignorowane],
    [*TAdd*], [bitowo = UAdd; różne znaki nie przepełniają],
    [*Nadmiar (+)*], [$u,v>0$, a wynik $<0$ (wynik $-2^w$)],
    [*Nadmiar (−)*], [$u,v<0$, a wynik $>=0$ (wynik $+2^w$)],
    [*Negacja U2*], [`-x = ~x+1`; `-TMin=TMin`, `-0=0`],
    [*Wykr. nadmiaru* (`s=x+y`)], `((s^x)&(s^y))>>(w-1)`,
    [*Maska / abs*], `m=x>>31; abs=(x^m)-m`,
  )
  *Pamięć:* adres wskazuje najmłodszy bajt słowa. Napis = `char[]` ASCII + `0x00` (niezależny od endianness).
  #table(
    columns: (auto, 1fr, auto),
    stroke: none,
    row-gutter: 0.3em,
    align: horizon,
    table.header(
      text(fill: rgb("8b949e"))[*Schemat*],
      text(fill: rgb("8b949e"))[*Najniższy adres*],
      text(fill: rgb("8b949e"))[*`0x0123`*],
    ),
    table.hline(stroke: rgb("333333")),
    [*Big Endian*], [MSB], `[01][23]`,
    [*Little Endian*], [LSB], `[23][01]`,
  )
]

#from(3)[
  #colbreak()

  == Zmiennoprzecinkowe (IEEE 754)
  #align(center)[
    $V = (-1)^s times M times 2^E wide "Bias" = 2^(k-1) - 1$
  ]
  #v(-2pt)
  #table(
    columns: (auto, auto, auto, auto, 1fr),
    stroke: none,
    align: center,
    row-gutter: 0.2em,
    table.header([*Format*], [*bity*], [*s*], [*exp ($k$)*], [*frac ($n$)*]),
    table.hline(stroke: rgb("333333")),
    [*Single* (`float`)], [32], [1], [8 (Bias=127)], [23],
    [*Double* (`double`)], [64], [1], [11 (Bias=1023)], [52],
  )

  === Kategorie wartości
  #table(
    columns: (22%, 18%, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.header(
      text(fill: rgb("8b949e"))[*Kategoria*],
      text(fill: rgb("8b949e"))[*`exp`*],
      text(fill: rgb("8b949e"))[*Własności*],
    ),
    table.hline(stroke: rgb("333333")),

    [*Znormalizowane*],
    [`!= 0...0` \ `!= 1...1`],
    [$E = "exp" - "Bias"$. Ukryta jedynka: $M = 1."frac"$. Najgęściej ułożone wokół 0.],

    [*Zdenormaliz.*],
    [`== 0...0`],
    [$E = 1 - "Bias"$. Brak jedynki: $M = 0."frac"$. Reprezentują $+0.0$ i $-0.0$ ($"frac"=0$) oraz liczby bardzo bliskie zera (stopniowy underflow).],

    [*Specjalne*],
    [`== 1...1`],
    [Gdy $"frac" == 0$, to $+oo$ lub $-oo$ (nadmiar/dzielenie przez 0). Gdy $"frac" != 0$, to `NaN` (np. $sqrt(-1)$, $oo - oo$).],
  )

  === Zaokrąglanie GRS i Round-to-Even
  Domyślny tryb to *Round-to-Even* (zapobiega błędowi statycznemu przy sumowaniu).
  #align(center)[
    #box(fill: rgb("1a1a1a"), inset: 6pt, radius: 2pt, stroke: rgb("333333"))[
      `... x x G ` #text(fill: rgb("D73A49"), weight: "bold")[ `|` ] ` R S S S ...`
    ] \
    #text(
      fill: rgb("8b949e"),
      size: 0.8em,
    )[`G` – ostatni zachowany, `R` – pierwszy usunięty, `S` – OR reszty]
  ]
  #v(-4pt)
  #table(
    columns: (auto, auto, 1fr),
    stroke: none,
    row-gutter: 0.3em,
    align: horizon,
    table.header(
      text(fill: rgb("8b949e"))[*Warunek*],
      text(fill: rgb("8b949e"))[*Ułamek*],
      text(fill: rgb("8b949e"))[*Akcja*],
    ),
    table.hline(stroke: rgb("333333")),
    `R=0`, $< 0.5$, [W dół (odcięcie)],
    `R=1, S=1`, $> 0.5$, [W górę (+1 do `G`)],
    `R=1, S=0`, $= 0.5$, [*Do parzystej:* w górę gdy `G=1`, w dół gdy `G=0`],
  )

  === Własności matematyczne i rzutowanie
  - *Brak łączności:* $(a+b)+c != a+(b+c)$, przez zaokrąglenia i utratę danych.
  - *Brak rozdzielności:* $a(b+c) != a b + a c$.
  - *Rzutowanie `int` $arrow.r$ `float`:* Może stracić precyzję (zaokrągla zgodnie z trybem).
  - *Rzutowanie `int` $arrow.r$ `double`:* Dokładne i bezstratne (bo $52$ bity mantysy $> 32$ bity inta).
  - *Rzutowanie `float/double` $arrow.r$ `int`:* Obcina ułamek w stronę 0. Jeśli poza zakresem lub `NaN` $arrow.r$ z reguły zwraca `TMin` (`0x80000000`).
]

#from(4)[
  == Instrukcja `leaq` (Load Effective Address)
  Instrukcja *obliczeniowa*, nie pamięciowa. Ładuje *obliczony adres*, a nie wartość z pamięci: `leaq Src, Dst` $arrow.r$ `Dst = addr(Src)`.

  *Zastosowania:*
  1. *Pobieranie adresu zmiennej:* C-owe `p = &x[i]`.
  2. *Szybka arytmetyka bez flag:* Obliczenia $x + k dot y$ dla stałych $k in {1, 2, 4, 8}$.
  *Przykład:* Optymalizacja `x * 12`:
  ```asm
  leaq (%rdi, %rdi, 2), %rax  ; t = x + 2*x = 3*x
  salq $2, %rax ; return t << 2 (czyli 3*x * 4 = 12*x)
  ```

  == Rejestry x86\_64
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

  === Podział ról rejestrów
  #reg-desc(
    `%rax`,
    [Akumulator. Główny rejestr arytmetyczny. Przechowuje *wartość zwracaną*.],
  )
  #reg-desc(
    `%rdi, %rsi, %rdx, %rcx, %r8, %r9`,
    [Kolejno: *od 1. do 6. argumentu funkcji*. Caller-saved.],
  )
  #reg-desc(`%rsp`, [Wskaźnik stosu (SP). Wskazuje wierzchołek ramki.])
  #reg-desc(`%rbp`, [Wskaźnik bazy (BP). Początek ramki stosu. Callee-saved.])
  #reg-desc(
    `%rbx, %r12-%r15`,
    [Ogólnego przeznaczenia. Wszystkie *callee-saved*.],
  )
  #reg-desc(`%rip`, [Wskaźnik instrukcji (Program Counter).])
]

// #from(5)[
//   === Rejestry wektorowe (zmiennoprzecinkowe)
//   #reg-desc(
//     `%xmm0 do %xmm15`,
//     [128-bitowe rejestry. `%xmm0` to wartość zwracana (`float`/`double`). Pierwsze 8 to argumenty. Caller-saved.],
//   )
//   #reg-desc(
//     `%ymm0 do %ymm15`,
//     [256-bitowe rozszerzenie rejestrów XMM. Dzielą z nimi najmłodsze 128 bitów.],
//   )
// ]

#from(4)[
  == Tryby adresowania (operandy)
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

  #addr-row("Natychmiastowy (Imm)", "$Imm", [`Imm`])
  #addr-row("Rejestrowy (Reg)", "%Ra", [`%Ra`])
  #addr-row("Bezpośredni (Mem)", "Imm", [`M[Imm]`])
  #addr-row("Pośredni (Mem)", "(%Rb)", [`M[%Rb]`])
  #addr-row("Z przesunięciem", "D(%Rb)", [`M[%Rb + D]`])
  #addr-row("Skalowany (Ind/scaled)", "D(%Rb, %Ri, S)", [`M[%Rb+%Ri*S+D]`])
  #addr-row("Skalowany (baseless)", "(, %Ri, S)", [`M[%Ri * S]`])

  #v(2pt)
  #align(center)[
    #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
      *Legenda:* `Imm`/`D` to stała liczbowa, `%Ra`/`%Rb` to rejestr bazowy, \
      `%Ri` to rejestr indeksowy, a `S` to skala (tylko: 1, 2, 4 lub 8).
    ]
  ]

  #colbreak()
  == Podstawowe instrukcje i arytmetyka (AT&T)
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

    raw("mov S, D"), $D arrow.l S$, [Kopiuje wartość z S do D.],
    raw("lea S, D"),
    $D arrow.l "addr"(S)$,
    [Oblicza adres S (bez czytania pamięci).],
    raw("add S, D"), $D arrow.l D + S$, [Dodawanie (ustawia flagi).],
    raw("sub S, D"), $D arrow.l D - S$, [Odejmowanie (ustawia flagi).],
    raw("imul S, D"), $D arrow.l D * S$, [Mnożenie liczb ze znakiem.],
    raw("sal / shl k, D"),
    $D limits(<<)= k$,
    [Przesunięcie w lewo (mnożenie przez $2^k$).],
    raw("sar k, D"),
    $D limits(>>)= k$,
    [Arytmetyczne w prawo (dzielenie). *Kopiuje znak*.],
    raw("shr k, D"), $D limits(>>)= k$, [Logiczne w prawo. Dopełnia zerami.],
    raw("and / or S, D"),
    $D arrow.l D "& / |" S$,
    [Operacje bitowe (ustawiają flagi).],
    raw("xor S, D"),
    $D arrow.l D "^" S$,
    [Często używane jako `xor %rax, %rax` do zerowania.],
  )
  #v(2pt)
  #align(center)[
    #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
      *Uwaga o sufiksach:* Instrukcje przyjmują sufiks określający rozmiar danych: \
      `b` ($8$-bit), `w` ($16$-bit), `l` ($32$-bit), `q` ($64$-bit). \
      Np. `movl` kopiuje $32$ bity (i automatycznie zeruje górną połowę 64-bitowego rejestru!).
    ]
  ]
]

// #from(5)[
//   #colbreak()
//   == Flagi stanu i Sterowanie (Control)
//   #reg-desc(`ZF`, [Zero. Wynik to 0 (np. argumenty są równe).])
//   #reg-desc(`SF`, [Sign. Wynik jest ujemny (MSB = 1).])
//   #reg-desc(`CF`, [Carry. Przepełnienie dla liczb *bez znaku* (unsigned).])
//   #reg-desc(`OF`, [Overflow. Przepełnienie dla liczb *ze znakiem* (signed).])
//
//   #table(
//     columns: (30%, 30%, 1fr),
//     stroke: none,
//     row-gutter: 0.5em,
//     align: horizon,
//     table.hline(stroke: rgb("333333")),
//     raw("cmp S1, S2"),
//     $"S2" - "S1"$,
//     [Ustawia flagi jak odejmowanie, nie zapisuje wyniku.],
//     raw("test S1, S2"),
//     $"S2 & S1"$,
//     [Ustawia flagi jak *AND* (np. test czy rejestr jest zerem).],
//     raw("jX dest"),
//     $"if"(X) "%rip" arrow.l "dest"$,
//     [Skok warunkowy (X = warunek).],
//     raw("setX D"),
//     $"if"(X) D arrow.l 1$,
//     [Ustawia bajt (np. `%al`) na 0 lub 1 na podstawie flag.],
//     raw("cmovX S, D"),
//     $"if"(X) D arrow.l S$,
//     [Warunkowe kopiowanie (optymalizacja zamiast skoku).],
//   )
//
//   === Sufiksy warunkowe (dla `jX`, `setX`, `cmovX`)
//   #table(
//     columns: (20%, 25%, 1fr),
//     stroke: none,
//     row-gutter: 0.4em,
//     align: horizon,
//     table.header(
//       text(fill: rgb("8b949e"))[*Sufiks*],
//       text(fill: rgb("8b949e"))[*Synonim*],
//       text(fill: rgb("8b949e"))[*Znaczenie*],
//     ),
//     table.hline(stroke: rgb("333333")),
//     raw("e") / raw("z"), [], [Equal / Zero (równe / wynik to $0$)],
//     raw("ne") / raw("nz"), [], [Not Equal / Not Zero (nierówne)],
//     raw("s"), [], [Sign (wynik ujemny, `SF=1`)],
//     table.hline(stroke: rgb("222222")),
//     table.cell(
//       colspan: 3,
//       fill: rgb("1a1a1a"),
//       align: center,
//     )[*Liczby ze znakiem (signed)*],
//     raw("g") / raw("ge"), [], [Greater / Greater or Equal],
//     raw("l") / raw("le"), [], [Less / Less or Equal],
//     table.hline(stroke: rgb("222222")),
//     table.cell(
//       colspan: 3,
//       fill: rgb("1a1a1a"),
//       align: center,
//     )[*Liczby bez znaku (unsigned)*],
//     raw("a") / raw("ae"), raw("nc"), [Above / Above or Equal (No Carry)],
//     raw("b") / raw("be"), raw("c"), [Below / Below or Equal (Carry)],
//   )
// ]
//
// #from(6)[
//   == Konwencja wywoływań (System V AMD64 ABI)
//   #align(center)[
//     #box(fill: rgb("1a1a1a"), inset: 6pt, stroke: (top: 2pt + rgb("333333")))[
//       #show regex("%"): set text(fill: white)
//       #show math.equation: set text(fill: rgb("e4e4e4"))
//       #text(fill: rgb("D73A49"))[
//         `%rdi` $arrow.r$ `%rsi` $arrow.r$ `%rdx` $arrow.r$ `%rcx` $arrow.r$ `%r8` $arrow.r$ `%r9`
//       ]
//     ] \
//     #text(
//       fill: rgb("8b949e"),
//       size: 0.75em,
//       style: "italic",
//     )[Argumenty 7+: Na stosie od końca. Wynik: Zawsze w `%rax`.]
//   ]
//
//   #table(
//     columns: (1fr, 1fr),
//     stroke: none,
//     column-gutter: 10pt,
//     table.cell(
//       fill: rgb("1a1a1a"),
//       stroke: (top: 2pt + rgb("D73A49")),
//       inset: 8pt,
//     )[
//       *Caller-saved* (Można niszczyć) \
//       #v(4pt)
//       #hregs(
//         rgb("D73A49"),
//       )[`%rax`, `%rdi`, `%rsi`, `%rdx`, `%rcx`, `%r8`-`%r11`]
//     ],
//     table.cell(
//       fill: rgb("1a1a1a"),
//       stroke: (top: 2pt + rgb("28A745")),
//       inset: 8pt,
//     )[
//       *Callee-saved* (Musi przywrócić) \
//       #v(4pt)
//       #hregs(rgb("28A745"))[`%rbx`, `%rbp`, `%r12`-`%r15`]
//     ],
//   )
//
//   === Instrukcje stosu i procedur
//   #table(
//     columns: (30%, 30%, 1fr),
//     stroke: none,
//     row-gutter: 0.5em,
//     align: horizon,
//     table.hline(stroke: rgb("333333")),
//     raw("push S"), $"%rsp" -= 8 \ M["%rsp"] arrow.l S$, [Odkłada na stos.],
//     raw("pop D"),
//     $D arrow.l M["%rsp"] \ "%rsp" += 8$,
//     [Zdejmuje ze stosu do D.],
//     raw("call dest"),
//     $"push" "%rip" \ "%rip" arrow.l "dest"$,
//     [Skok do funkcji (zapisuje adres powrotu).],
//     raw("ret"), $"pop" "%rip"$, [Powrót z funkcji.],
//     raw("leave"),
//     $"%rsp" arrow.l "%rbp" \ "pop" "%rbp"$,
//     [Sprząta ramkę stosu.],
//   )
// ]
//
// #from(7)[
//   == Struktury, Wyrównanie i Bezpieczeństwo
//   + *Wyrównanie pola ($K$):* Zmienna $K$-bajtowa pod adresem $\pmod K = 0$.
//   + *Rozmiar całkowity:* Całkowity `sizeof` struktury musi być podzielny przez największe wyrównanie w strukturze ($K_max$).
//
//   #table(
//     columns: (25%, 75%),
//     stroke: none,
//     row-gutter: 0.5em,
//     align: horizon,
//     table.hline(stroke: rgb("333333")),
//     [*Buffer overflow*],
//     [Zapis poza limit bufora. Nadpisuje sąsiadującą pamięć (np. adres powrotu).],
//     [*Stack canaries*],
//     [Losowa wartość ułożona przed adresem powrotu. Weryfikowana przed `ret`.],
//     [*ROP (Gadżety)*],
//     [Łączenie legalnych instrukcji kończących się `ret` w celu ominięcia zabezpieczeń (np. Nonexec code segments).],
//   )
// ]
//
// == Rejestry x86\_64
// #reg-pair("rax", "rbx")
// #reg-pair("rcx", "rdx")
// #reg-pair("rsi", "rdi")
// #reg-pair("rbp", "rsp", clr2: rgb("D73A49"))
// #reg-pair("r8", "r9")
// #v(2pt)
// #align(center)[
//   #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
//     *Uwaga:* Rejestry od %r10 do %r15 używają schematu: \
//     #raw("%r10"), #raw("%r10d"), #raw("%r10w"), #raw("%r10b").
//   ]
// ]
//
// === Rejestry ogólnego przeznaczenia
// #reg-desc(
//   `%rax`,
//   [Akumulator. Główny rejestr arytmetyczny. Przechowuje *wartość zwracaną* z funkcji.],
// )
// #reg-desc(`%rbx`, [Rejestr bazowy. Callee-saved.])
// #reg-desc(`%rcx`, [Licznik w pętlach i przesunięciach bitowych. *4. argument*.])
// #reg-desc(
//   `%rdx`,
//   [Rejestr danych. Używany w mnożeniu/dzieleniu. *3. argument*.],
// )
//
// === Indeksy i wskaźniki
// #reg-desc(`%rdi`, [Indeks docelowy (DI). *1. argument*.])
// #reg-desc(`%rsi`, [Indeks źródłowy (SI). *2. argument*.])
// #reg-desc(
//   `%rsp`,
//   [Wskaźnik stosu (SP). Wskazuje wierzchołek ramki. Modfikowany przez `push`/`pop`/`call`/`ret`.],
// )
// #reg-desc(`%rbp`, [Wskaźnik bazy (BP). Początek ramki stosu. Callee-saved.])
//
// === Nowe i specjalne rejestry
// #reg-desc(`%r8-9`, [Kolejno: *5. i 6. argument*. Caller-saved.])
// #reg-desc(`%r10 oraz %r11`, [Rejestry tymczasowe. Caller-saved.])
// #reg-desc(`%r12 do %r15`, [Ogólnego przeznaczenia. Wszystkie *callee-saved*.])
// #reg-desc(
//   `%rip`,
//   [Wskaźnik instrukcji (IP). Następna instrukcja. Modyfikowany przez skoki i wywolania.],
// )
// #reg-desc(`%rflags`, [Rejestr flag statusu. Zmieniany przez `cmp`, `test`.])
//
// === Rejestry wektorowe (zmiennoprzecinkowe)
// #reg-desc(
//   `%xmm0 do %xmm15`,
//   [128-bitowe rejestry. `%xmm0` to *wartość zwracana* (float/double). `%xmm0-%xmm7` to pierwsze *8 argumentów*. Wszystkie są *caller-saved*.],
// )
// #reg-desc(
//   `%ymm0 do %ymm15`,
//   [256-bitowe rozszerzenie rejestrów XMM. Dzielą z nimi najmłodsze 128 bitów.],
// )
//
// #colbreak()
// == Flagi stanu (Rejestr `%rflags`)
// #reg-desc(`ZF`, [Zero. Wynik to 0 (np. argumenty są równe).])
// #reg-desc(`SF`, [Sign. Wynik jest ujemny (MSB = 1).])
// #reg-desc(`CF`, [Carry. Przepełnienie dla liczb *bez znaku* (unsigned).])
// #reg-desc(`OF`, [Overflow. Przepełnienie dla liczb *ze znakiem* (signed).])
//
// == Tryby adresowania (operandy)
// #v(0.5em)
// #grid(
//   columns: (35%, 25%, 1fr),
//   gutter: 10pt,
//   text(fill: rgb("8b949e"))[*Tryb*],
//   text(fill: rgb("8b949e"))[*Format*],
//   text(fill: rgb("8b949e"))[*Obliczanie adresu*],
// )
// #line(length: 100%, stroke: rgb("333333"))
// #v(0.5em)
//
// #addr-row("Natychmiastowy (Immediate)", "$Imm", [`Imm`])
// #addr-row("Rejestrowy (Register)", "%Ra", [`%Ra`])
// #addr-row("Bezpośredni (Direct)", "Imm", [`M[Imm]`])
// #addr-row("Pośredni (Indirect)", "(%Rb)", [`M[%Rb]`])
// #addr-row(
//   "Z przesunięciem (Indirect displacement)",
//   "D(%Rb)",
//   [`M[%Rb + D]`],
// )
// #addr-row(
//   "Skalowany (Indirect scaled-index)",
//   "D(%Rb, %Ri, S)",
//   [`M[%Rb+%Ri*S+D]`],
// )
// #addr-row(
//   "Skalowany (baseless)",
//   "(, %Ri, S)",
//   [`M[%Ri * S]`],
// )
//
// #v(2pt)
// #align(center)[
//   #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
//     *Legenda:* `Imm` / `D` to stała liczbowa, `%Ra` / `%Rb` to rejestr bazowy, \
//     `%Ri` to rejestr indeksowy, a `S` to skala (tylko wartości: 1, 2, 4 lub 8).
//   ]
// ]
//
// == Konwencja wywoływań (System V AMD64 ABI)
// #align(center)[*Przekazywanie argumentów*]
// #align(center)[
//   #box(fill: rgb("1a1a1a"), inset: 6pt, stroke: (top: 2pt + rgb("333333")))[
//     #show regex("%"): set text(fill: white)
//     #show math.equation: set text(fill: rgb("e4e4e4"))
//     #text(fill: rgb("D73A49"))[
//       `%rdi` $arrow.r$ `%rsi` $arrow.r$ `%rdx` $arrow.r$ `%rcx` $arrow.r$ `%r8` $arrow.r$ `%r9`
//     ]
//   ]
// ]
// #align(center)[
//   #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
//     / Argumenty 7+: Na stosie od końca.
//     / Wynik: Zawsze w #[
//         #show regex("%"): set text(fill: white)
//         #text(fill: rgb("D73A49"))[`%rax`].
//       ]
//   ]
// ]
//
// #align(center)[*Ochrona rejestrów (ABI)*]
// #v(4pt)
// #table(
//   columns: (1fr, 1fr),
//   stroke: none,
//   column-gutter: 10pt,
//
//   table.cell(
//     fill: rgb("1a1a1a"),
//     stroke: (top: 2pt + rgb("D73A49")),
//     inset: 8pt,
//   )[
//     *Caller-saved* \
//     #text(fill: rgb("8b949e"), size: 8.5pt)[(Można niszczyć)] \
//     #v(4pt)
//     #hregs(rgb("D73A49"))[`%rax`, `%rdi`, `%rsi`, `%rdx`, `%rcx`, `%r8`-`%r11`]
//   ],
//
//   table.cell(
//     fill: rgb("1a1a1a"),
//     stroke: (top: 2pt + rgb("28A745")),
//     inset: 8pt,
//   )[
//     *Callee-saved* \
//     #text(fill: rgb("8b949e"), size: 8.5pt)[(Musi przywrócić)] \
//     #v(4pt)
//     #hregs(rgb("28A745"))[`%rbx`, `%rbp`, `%r12`-`%r15`]
//   ],
// )
//
// #align(center)[*Ramka Stosu*]
// #grid(
//   columns: (1fr, 1fr),
//   gutter: 10pt,
//   box(fill: rgb("1a1a1a"), stroke: (top: 2pt + rgb("333333")), inset: 8pt)[
//     *Start* (alokacja)
//     ```asm
//     push %rbp
//     mov  %rsp, %rbp
//     sub  $32, %rsp
//     ```
//   ],
//   box(fill: rgb("1a1a1a"), stroke: (top: 2pt + rgb("333333")), inset: 8pt)[
//     *Koniec* (sprzątanie)
//     ```asm
//     leave
//     ret
//     /* równowaznie:
//     * mov %rbp, %rsp
//     * pop %rbp
//     * ret */
//     ```
//   ],
// )
//
// #colbreak()
// == Struktury i wyrównanie
// + *Wyrównanie pola ($K$):* Zmienna $K$-bajtowa pod adresem $\pmod K = 0$.
// + *Rozmiar całkowity:* Całkowity `sizeof` struktury musi być podzielny przez największe wyrównanie w strukturze ($K_max$).
// ```c
// struct {
//   char  c;  // 1 bajt (offset 0)
//             // [3 bajty wewn. paddingu]
//   int   i;  // 4 bajty (offset 4)
//   short s;  // 2 bajty (offset 8)
//             // [2 bajty zewn. paddingu]
// } // K_max = 4. Rozmiar: 1+3+4+2+2 = 12 bajtów.
// ```
//
// == Najważniejsze instrukcje (AT&T)
// #table(
//   columns: (30%, 30%, 1fr),
//   stroke: none,
//   row-gutter: 0.5em,
//   align: horizon,
//   table.header(
//     text(fill: rgb("8b949e"))[*Opcode*],
//     text(fill: rgb("8b949e"))[*Efekt*],
//     text(fill: rgb("8b949e"))[*Opis*],
//   ),
//   table.hline(stroke: rgb("333333")),
//
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Przesyłanie danych*],
//   raw("mov S, D"), $D arrow.l S$, [Kopiuje wartość z S do D.],
//   raw("push S"),
//   $"%rsp" -= 8 \ M["%rsp"] arrow.l S$, [Odkłada na stos.],
//   raw("pop D"), $D arrow.l M["%rsp"] \ "%rsp" += 8$, [Zdejmuje ze stosu do D.],
//   raw("leave"), $"%rsp" arrow.l "%rbp" \ "pop" "%rbp"$, [Sprząta ramkę stosu.],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Adresowanie i arytmetyka*],
//   raw("lea S, D"),
//   $D arrow.l "addr"(S)$,
//   [Oblicza adres S (bez czytania pamięci).],
//   raw("add S, D"), $D arrow.l D + S$, [Dodawanie (ustawia flagi).],
//   raw("sub S, D"), $D arrow.l D - S$, [Odejmowanie (ustawia flagi).],
//   raw("imul S, D"), $D arrow.l D * S$, [Mnożenie liczb ze znakiem.],
//   raw("inc / dec D"),
//   $D arrow.l D plus.minus 1$,
//   [Inkrementacja / dekrementacja.],
//   raw("neg D"), $D arrow.l -D$, [Negacja arytmetyczna (jak w U2).],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Dzielenie (zawsze w parze)*],
//   raw("cqto"),
//   $"%rdx:%rax" arrow.l "sgn_ext"("%rax")$,
//   [*Uwaga:* Rozszerza %rax do $128$-bit przed `idivq`.],
//   raw("idiv S"),
//   $"%rax" arrow.l "wynik" \ "%rdx" arrow.l "reszta"$,
//   [Dzielenie `%rdx:%rax` przez S. Wynik w `%rax`, reszta w `%rdx`.],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Logiczne i bitowe*],
//   raw("and / or S, D"),
//   $D arrow.l D "& / |" S$,
//   [Operacje bitowe (ustawiają flagi).],
//   raw("xor S, D"),
//   $D arrow.l D "^" S$,
//   [Często używane jako `xor %rax, %rax` do zerowania.],
//   raw("not D"), $D arrow.l ~D$, [Negacja bitowa (odwrócenie bitów).],
//   raw("sal / shl k, D"),
//   $D limits(<<)= k$,
//   [Przesunięcie w lewo (mnożenie przez $2^k$).],
//   raw("sar k, D"),
//   $D limits(>>)= k$,
//   [Arytmetyczne w prawo (dzielenie). *Kopiuje znak*.],
//   raw("shr k, D"), $D limits(>>)= k$, [Logiczne w prawo. Dopełnia zerami.],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Porównania i skoki*],
//   raw("cmp S1, S2"),
//   $"S2" - "S1"$,
//   [Ustawia flagi jak odejmowanie, nie zapisuje wyniku.],
//   raw("test S1, S2"),
//   $"S2 & S1"$,
//   [Ustawia flagi jak *AND* (np. test czy rejestr jest zerem).],
//   raw("jX dest"),
//   $"if"(X) "%rip" arrow.l "dest"$,
//   [Skok warunkowy (X = warunek).],
//   raw("setX D"),
//   $"if"(X) D arrow.l 1$,
//   [Ustawia bajt (np. `%al`) na 0 lub 1 na podstawie flag.],
//   raw("cmovX S, D"),
//   $"if"(X) D arrow.l S$,
//   [Warunkowe kopiowanie (optymalizacja zamiast skoku).],
//   raw("call / ret"), [], [Skok do funkcji / Powrót (obsługa stosu i `%rip`).],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Operacje wektorowe*],
//   raw("movaps / movups S, D"),
//   $D arrow.l S$,
//   [Kopiuje 128-bitów. `aps` (aligned) – wymaga wyrównania w pamięci, `ups` nie.],
//   raw("movsd / movss S, D"),
//   $D arrow.l S$,
//   [Kopiuje pojedynczą wartość skalarną (`double`/(s)`float`).],
//   raw("add/sub/mul/div pd/ps"),
//   $D arrow.l D "op" S$,
//   [Arytmetyka wektorowa. Wykonuje operację na wielu parach równocześnie.],
//   raw("add/sub/mul/div sd/ss"),
//   $D arrow.l D "op" S$,
//   [Arytmetyka skalarna. Modyfikuje tylko najmłodszą wartość w rejestrze.],
//   raw("vxorps S1, S2, D"),
//   $D arrow.l "S2 ^ S1"$,
//   [Wektorowy *XOR*.],
//   raw("v... (np. vmulss)"),
//   $D arrow.l "S2 op S1"$,
//   [Przedrostek `v` wprowadza 3 argumenty (źródło 1, źródło 2, cel). Nie niszczy danych wejściowych.],
//   raw("vfmadd231ss S1, S2, D"),
//   $D arrow.l "S2" * "S1" + D$,
//   [*Fused Multiply-Add*. Mnoży i dodaje. Cyfry `231` określają, że mnożymy dwa źródła, a wynik dodajemy do `D`.],
// )
//
// #v(2pt)
// #align(center)[
//   #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
//     *Uwaga o sufiksach:* Instrukcje mogą przyjmować sufiks określający rozmiar danych: \
//     #raw("b") (byte, $8$-bit), #raw("w") (word, $16$-bit), #raw("l") (long, $32$-bit), #raw("q") (quadword, $64$-bit). \
//     Np. `movq` kopiuje $64$ bity, a `movl` kopiuje $32$ bity (i zeruje górną połowę rejestru!).
//   ]
// ]
//
// #colbreak()
// == Sufiksy warunkowe (dla `jX`, `setX`, `cmovX`)
// #table(
//   columns: (20%, 25%, 1fr),
//   stroke: none,
//   row-gutter: 0.4em,
//   align: horizon,
//   table.header(
//     text(fill: rgb("8b949e"))[*Sufiks*],
//     text(fill: rgb("8b949e"))[*Synonim*],
//     text(fill: rgb("8b949e"))[*Znaczenie / Warunek*],
//   ),
//   table.hline(stroke: rgb("333333")),
//
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Równość i znak (`ZF`, `SF`)*],
//   raw("e"), raw("z"), [Equal / Zero (równe / wynik to $0$)],
//   raw("ne"), raw("nz"), [Not Equal / Not Zero (nierówne)],
//   raw("s"), [], [Sign (wynik ujemny, `SF=1`)],
//   raw("ns"), [], [Not Sign (wynik dodatni lub $0$, `SF=0`)],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Liczby ze znakiem (signed)*],
//   raw("g"), [], [Greater],
//   raw("ge"), [], [Greater or Equal],
//   raw("l"), [], [Less],
//   raw("le"), [], [Less or Equal],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 3,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Liczby bez znaku (unsigned)*],
//   raw("a"), [], [Above (powyżej: `>`)],
//   raw("ae"), raw("nc"), [Above or Equal / No Carry (większe równe: `>=`)],
//   raw("b"), raw("c"), [Below / Carry (poniżej: `<`)],
//   raw("be"), [], [Below or Equal (mniejsze równe: `<=`)],
// )
//
// == Optymalizacje i atrybuty
// #table(
//   columns: (25%, 75%),
//   stroke: none,
//   row-gutter: 0.5em,
//   align: horizon,
//
//   table.hline(stroke: rgb("333333")),
//   table.cell(
//     colspan: 2,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Podstawowe techniki*],
//   [*Strength red.*],
//   [Zamiana drogich operacji na tańsze (np. `mul` $arrow.r$ `lea` / `shl`).],
//   [*Loop unroll.*],
//   [Rozwinięcie pętli (np. skok co 4. iterację). Mniej skoków = mniejszy narzut.],
//   [*Code motion*],
//   [Wyrzucenie obliczeń niezmienników (np. stałych w pętli) przed pętlę.],
//   [*Common subexpr. elim.*],
//   [Obliczenie wspólnego fragmentu tylko raz.],
//   [*Const folding*],
//   [Obliczanie stałych wyrażeń (np. `2+2`) w czasie kompilacji.],
//   [*Branch predict*],
//   [Sprzętowe przewidywanie skoków. By unikać kar, mozna użyc `cmovX`.],
//   [*Inlining*],
//   [Wklejenie ciała funkcji w miejsce wywołania. Eliminuje narzut `call`/`ret`.],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 2,
//     fill: rgb("1a1a1a"),
//     align: center,
//   )[*Analiza pamięci i atrybuty GCC*],
//   [*Aliasing*],
//   [Problem nakładania się wskaźników. Keyword `restrict`, pomaga w optymalizacji.],
//   [*pure / const*],
//   [Funkcja bez skutków ubocznych (`const` dodatkowo nie czyta zmiennych globalnych).],
// )
//
// == Bezpieczeństwo kodu i exploity
// #table(
//   columns: (25%, 75%),
//   stroke: none,
//   row-gutter: 0.5em,
//   align: horizon,
//
//   table.hline(stroke: rgb("333333")),
//   table.cell(
//     colspan: 2,
//     fill: rgb("251414"),
//     align: center,
//   )[*Zagrożenia i błędy*],
//   [*Buffer overflow*],
//   [Zapis poza limit bufora. Nadpisuje sąsiadującą pamięć.],
//   [*Seg fault*],
//   [Próba dostępu bez uprawnień (np. odczyt `NULL`, modyfikacja read-only).],
//   [*Stack smashing*],
//   [Atak nadpisujący *adres powrotu* na stosie, by przejąć kontrolę po `ret`.],
//   [*ROP (Gadżety)*],
//   [Łączenie legalnych instrukcji kończących się `ret` w celu ominięcia zabezpieczeń.],
//
//   table.hline(stroke: rgb("222222")),
//   table.cell(
//     colspan: 2,
//     fill: rgb("142517"),
//     align: center,
//   )[*Mechanizmy obronne*],
//   [*Stack canaries*],
//   [Losowa wartość ułożona przed adresem powrotu. Weryfikowana przed `ret`.],
//   [*Nonexec code segments*],
//   [Stos dostaje sprzętowy zakaz wykonywania kodu (tylko R/W).],
//   [*Rand. stack offsets*],
//   [Losowanie adresów stosu przy każdym starcie.],
// )

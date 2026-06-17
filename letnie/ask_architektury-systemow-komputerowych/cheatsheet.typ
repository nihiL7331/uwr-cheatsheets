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

#show raw: set text(font: "BigBlueTerm437 Nerd Font Mono", fallback: false)
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

#show math.equation: set text(
  font: "New Computer Modern Math",
  fallback: false,
  size: 1.15em,
)

#let LECTURE-NUM-FROM = int(sys.inputs.at("od", default: "1"))
#let LECTURE-NUM-TO = int(sys.inputs.at("do", default: "15"))
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
    [*#name*], synt, calc,
  )
  v(0.4em)
}
#let hregs(clr, body) = [
  #show regex("[%,\-]"): set text(fill: white)
  #text(fill: clr)[#body]
]

#let flow(clr, ..steps) = align(center)[
  #box(
    fill: rgb("1a1a1a"),
    inset: 6pt,
    stroke: (top: 2pt + rgb("333333")),
    radius: 2pt,
  )[
    #show math.equation: set text(fill: rgb("e4e4e4"))
    #(
      steps
        .pos()
        .map(s => text(fill: clr, weight: "bold")[#s])
        .join([ $arrow.r$ ])
    )
  ]
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
    [`s = x ^ y` \ `c = x & y`],
    [Dodaje dwa bity. `s` to suma, `c` to bit przeniesienia (carry).],
    [*Pełny sumator (FA)*],
    [`s = x ^ y ^ ci` \ `co=x&y|ci&(x^y)`],
    [Jak półsumator, ale przyjmuje też przeniesienie wejściowe `ci`.],
    [*Sumator n-bitowy*],
    [$n times$ FA],
    [Kaskadowo wyjście $C_(i)$ trafia na wejście kolejnego FA. Ostatnie `co` to *Carry Out* całości.],

    table.hline(stroke: rgb("222222")),
    table.cell(
      colspan: 3,
      fill: rgb("1a1a1a"),
      align: center,
    )[*Układy kombinacyjne*],
    [*Dekoder*],
    [$n arrow.r 2^n$],
    [Wejście koduje liczbę $k$. Na wyjściu zapalony jest bit $k$.],
    [*Multiplekser*],
    [$2^n + n arrow.r 1$],
    [$2^n$ bitów danych + $n$ bitów sterujących $S$. Na wyjściu zapalony $S$-ty bit danych.],
    [*ALU*],
    [$A, B, f arrow.r C$],
    [Dekoder na bitach $f$ wybiera operację np. $A+B$, multipleksowanie wyników bramkami AND/OR.],

    table.hline(stroke: rgb("222222")),
    table.cell(
      colspan: 3,
      fill: rgb("1a1a1a"),
      align: center,
    )[*Układy sekwencyjne (pamięć)*],
    [*Przerzutnik S-R*],
    [`S` - set, `R` - reset],
    [Przechowuje 1 bit ($Q$). `S=1` ustawia $Q=1$, `R=1` zeruje, `S=R=0` trzyma stan. Dwa sprzężone `NOR`-y.],
    [*Sterowany poziomem*],
    [aktywny gdy `CLK` $= 1$],
    [Wejścia `S`/`R` zAND-owane z zegarem.],
    [*Sterowany zboczem*],
    [zbocze $1 arrow.r 0$],
    [Dwa przerzutniki poziomowe w kaskadzie. Stan przepisuje się w *momencie* zmiany zegara.],
  )
]

#from(2)[
  == Typy danych
  #v(-2pt)
  #table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    stroke: none,
    align: center,
    row-gutter: 0.2em,
    table.header(
      [*Typ*],
      `char`,
      `short`,
      `unsigned`,
      `int`,
      `long`,
      `float`,
      `double`,
      `void*`,
    ),
    table.hline(stroke: rgb("333333")),
    text(fill: rgb("8b949e"))[*x86-64*], [1], [2], [4], [4], [8], [4], [8], [8],
  )

  == Rozszerzanie, obcinanie i przesunięcia
  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    `x << k`, [$x dot 2^k$ (sgn./uns.)],
    `u >> k`, [$floor(u \/ 2^k)$ - logiczne (zera)],
    `x >> k`, [arytmetyczne (kopia MSB), zaokr. do $-oo$],
    [$x \/ 2^k$ do $0$], `(x + (1<<k)-1) >> k`,
    [Strength reduction], [`x*24` $arrow.r$ `(x<<5)-(x<<3)`],
  )

  #colbreak()

  == Operacje i endianness
  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Negacja U2*], [`-x = ~x+1`; `-TMin=TMin`, `-0=0`],
    [*Wykr. nadmiaru* (`s=x+y`)], `((s^x)&(s^y))>>(w-1)`,
    [*Maska / abs*], `m=x>>31; abs=(x^m)-m`,
    [*`c ? a : b`*], `b ^ (-c & (a ^ b))`,
  )
  *Promocja w C:* `unsigned` i `int` w jednym wyrażeniu/porównaniu (`< > ==`) $arrow.r$ `int` promowany do `unsigned` (bity bez zmian, $-1 arrow.r$ UMax).
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
    [`float`], [32], [1], [8], [23],
    [`double`], [64], [1], [11], [52],
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
    [$E = "exp" - "Bias"$. $M = 1."frac"$. Najgęściej ułożone wokół 0.],

    [*Zdenormaliz.*],
    [`== 0...0`],
    [$E = 1 - "Bias"$. $M = 0."frac"$. Reprezentują $plus.minus 0.0$ ($"frac"=0$) i liczby bardzo bliskie zera.],

    [*Specjalne*],
    [`== 1...1`],
    [`frac == 0` $arrow.r$ $plus.minus oo$ (nadmiar, dzielenie przez 0). \
      `frac != 0` $arrow.r$ `NaN` (np. $sqrt(-1)$, $oo - oo$).],
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
    )[`G` - ostatni zachowany, `R` - pierwszy usunięty, `S` - OR reszty]
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
  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Brak łączności*], [$(a+b)+c != a+(b+c)$ - zaokrąglenia],
    [*Brak rozdzielności*], [$a(b+c) != a b + a c$],
    [`int` $arrow.r$ `float`], [możliwa utrata precyzji (zaokrągla)],
    [`int` $arrow.r$ `double`], [bezstratne ($52 > 32$ bity)],
    [`float/double` $arrow.r$ `int`],
    [obcina do 0; poza zakresem lub `NaN` $arrow.r$ `TMin` (`0x80000000`)],
  )
]

#from(4)[
  #colbreak()
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
      `%r10`, `%r10d`, `%r10w`, `%r10b`.
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

#from(7)[
  === Rejestry wektorowe (zmiennoprzecinkowe)
  #reg-desc(
    `%xmm0-%xmm15`,
    [128-bitowe. `%xmm0` to wartość zwracana (`float`/`double`). Pierwsze 8 to argumenty. Caller-saved.],
  )
  #reg-desc(
    `%ymm0-%ymm15`,
    [256-bitowe rozszerzenie XMM. Dzielą z nimi najmłodsze 128 bitów.],
  )
]

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

  #addr-row("Natychmiastowy (Imm)", `$Imm`, [`Imm`])
  #addr-row("Rejestrowy (Reg)", `%Ra`, [`%Ra`])
  #addr-row("Bezpośredni (Mem)", `Imm`, [`M[Imm]`])
  #addr-row("Pośredni (Mem)", `(%Rb)`, [`M[%Rb]`])
  #addr-row("Z przesunięciem", `D(%Rb)`, [`M[%Rb + D]`])
  #addr-row("Skalowany (Ind/scaled)", `D(%Rb, %Ri, S)`, [`M[%Rb+%Ri*S+D]`])
  #addr-row("Skalowany (baseless)", `(, %Ri, S)`, [`M[%Ri * S]`])

  #v(2pt)
  #align(center)[
    #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
      *Legenda:* `Imm`/`D` to stała liczbowa, `%Ra`/`%Rb` to rejestr bazowy, \
      `%Ri` to rejestr indeksowy, a `S` to skala (tylko: 1, 2, 4 lub 8).
    ]
  ]
]

#from(5)[
  #colbreak()
  == Flagi stanu i sterowanie
  #reg-desc(`ZF`, [Zero. Wynik to 0 (np. argumenty są równe).])
  #reg-desc(`SF`, [Sign. Wynik jest ujemny (MSB = 1).])
  #reg-desc(`CF`, [Carry. Przepełnienie dla liczb *bez znaku* (unsigned).])
  #reg-desc(`OF`, [Overflow. Przepełnienie dla liczb *ze znakiem* (signed).])

  === Sufiksy warunkowe (dla `jX`, `setX`, `cmovX`)
  #table(
    columns: (20%, auto),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.header(
      text(fill: rgb("8b949e"))[*Sufiks*],
      text(fill: rgb("8b949e"))[*Znaczenie*],
    ),
    table.hline(stroke: rgb("333333")),
    `e / z`, [Equal / Zero (równe / wynik to $0$)],
    `ne / nz`, [Not Equal / Not Zero (nierówne)],
    `s`, [Sign (wynik ujemny, `SF=1`)],
    table.hline(stroke: rgb("222222")),
    table.cell(
      colspan: 2,
      fill: rgb("1a1a1a"),
      align: center,
    )[*Liczby ze znakiem (signed)*],
    `g / ge`, [Greater / Greater or Equal],
    `l / le`, [Less / Less or Equal],
    table.hline(stroke: rgb("222222")),
    table.cell(
      colspan: 2,
      fill: rgb("1a1a1a"),
      align: center,
    )[*Liczby bez znaku (unsigned)*],
    `a / ae`, [Above / Above or Equal (No Carry)],
    `b / be`, [Below / Below or Equal (Carry)],
  )

  === Translacja struktur kontrolnych (C $arrow.r$ ASM)
  - *if-else:* `jX` (skok) lub `cmovX` (liczy obie ścieżki, bez kary za predykcję). `cmovX` odpada przy drogich gałęziach, wyłuskaniach (`*p`) i efektach ubocznych (`x++`).
  - *`switch`:* tablica skoków $arrow.r$ czas $O(1)$. Skok pośredni: `jmp *.L4(,%rdi,8)`. Brak `break` $=>$ *fall-through*.
  - *Pętla `for`:* zawsze redukowana do `while`: `init; while(cond) { body; update; }`

  #v(2pt)
  *Wzorce asemblerowe dla pętli:*
  #table(
    columns: (1fr, 1fr, 1fr),
    stroke: none,
    row-gutter: 0.2em,
    table.header(
      text(fill: rgb("8b949e"))[*`do-while`*],
      text(fill: rgb("8b949e"))[*`while` (Jump-to-mid)*],
      text(fill: rgb("8b949e"))[*`while` (Guarded)*],
    ),
    table.hline(stroke: rgb("333333")),
    [`loop:` \ `  Body` \ `  if(T) goto loop`],
    [`  goto test` \ `loop:` \ `  Body` \ `test:` \ `  if(T) goto loop`],
    [`  if(!T) goto done` \ `loop:` \ `  Body` \ `  if(T) goto loop` \ `done:`],
  )
]

#from(6)[
  == Procedury i stos
  Stos rośnie *w dół* (niższe adresy); `%rsp` wskazuje *wierzchołek* (najniższy zajęty adres). `push` zmniejsza `%rsp` o 8, `pop` zwiększa o 8.
  - `call dest`: odkłada adres powrotu na stos i skacze do `dest`.
  - `ret`: zdejmuje adres powrotu ze stosu i skacze pod niego.

  == Konwencja Wywoływań (System V ABI)
  #align(center)[
    #box(
      fill: rgb("1a1a1a"),
      inset: 6pt,
      stroke: (top: 2pt + rgb("333333")),
      radius: 2pt,
    )[
      #show regex("%"): set text(fill: white)
      #show math.equation: set text(fill: rgb("e4e4e4"))
      #text(fill: rgb("D73A49"))[
        `%rdi` $arrow.r$ `%rsi` $arrow.r$ `%rdx` $arrow.r$ `%rcx` $arrow.r$ `%r8` $arrow.r$ `%r9`
      ]
    ] \
    #text(
      fill: rgb("8b949e"),
      size: 0.75em,
      style: "italic",
    )[Argumenty 7+: Na stosie od końca. Wynik w `%rax`.]
  ]

  === Rejestry caller-saved vs callee-saved
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
      #text(fill: rgb("8b949e"), size: 6.5pt)[(Wołający musi zapisać)] \
      #text(
        size: 7pt,
      )[Mogą zostać nadpisane w funkcji. By je zachować, caller kładzie je na stos przed `call`.] \
      #v(2pt)
      #hregs(
        rgb("D73A49"),
      )[`%rax`, `%rdi`, `%rsi`, `%rdx`, `%rcx`, `%r8`-`%r11`]
    ],
    table.cell(
      fill: rgb("1a1a1a"),
      stroke: (top: 2pt + rgb("28A745")),
      inset: 8pt,
    )[
      *Callee-saved* \
      #text(fill: rgb("8b949e"), size: 6.5pt)[(Wołany musi przywrócić)] \
      #text(
        size: 7pt,
      )[Muszą zachować stan. Callee musi zapisać je na stos i odtworzyć przed `ret`.] \
      #v(4pt)
      #hregs(rgb("28A745"))[`%rbx`, `%rbp`, `%r12`-`%r15`]
    ],
  )

  === Ramka stosu
  Każde wywołanie funkcji ma własną ramkę (stąd *rekurencja* działa naturalnie). \
  *Ramka potrzebna, gdy:* brak rejestrów na zmienne (spilling), lokalna tablica/struktura, lub pobrano adres zmiennej (`&`).

  #grid(
    columns: (1fr, 1fr),
    gutter: 10pt,
    box(fill: rgb("1a1a1a"), stroke: (top: 2pt + rgb("333333")), inset: 8pt)[
      *Prolog*
      ```asm
      pushq %rbp        ; zapisz stary base ptr
      movq  %rsp, %rbp  ; nowy base ptr = rsp
      subq  $32, %rsp   ; alokacja 32 bajtów
      ```
    ],
    box(fill: rgb("1a1a1a"), stroke: (top: 2pt + rgb("333333")), inset: 8pt)[
      *Epilog*
      ```asm
      addq  $32, %rsp   ; zwolnij alokację
      popq  %rbp        ; przywróć base ptr
      ret               ; skok powrotny
      ```
    ],
  )
  *`leave`:* zastępuje `movq %rbp, %rsp` + `popq %rbp` jedną instrukcją.
]

#from(7)[
  == Architektura CPU

  === Fazy przetwarzania instrukcji
  #flow(rgb("2188FF"), [Fetch], [Decode], [Execute], [Memory], [Write])

  === Pipelining i hazardy
  Nakładanie faz zwiększa throughput, ale rodzi konflikty (hazardy):
  #table(
    columns: (25%, 75%),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Danych*],
    [Odczyt po zapisie - wynik jeszcze nie jest w rejestrze, a kolejna instrukcja już go potrzebuje. \
      *Rozwiązanie:* forwarding/bypassing (wynik z ALU prosto na wejście) lub stall/bubble.],
    [*Sterowania*],
    [Skok wymusza odgadnięcie następnego adresu. \
      *Rozwiązanie:* branch prediction. Pomyłka $arrow.r$ czyszczenie potoku (misprediction penalty).],
  )

  === Out-of-Order
  Nowoczesne procesory nie wykonują instrukcji sekwencyjnie:
  - *Superskalarność:* wiele instrukcji na cykl (wiele jednostek wykonawczych).
  - *Register renaming:* mapowanie rejestrów logicznych (`%rax`) na wiele fizycznych - eliminuje fałszywe zależności.
  - *Reorder buffer:* instrukcje liczone asynchronicznie, ale zatwierdzane w kolejności programu (spójność).

  === Miary wydajności
  #table(
    columns: (25%, 75%),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Latency bound*],
    [Limit wynikający z łańcucha zależności danych. Zależy od opóźnienia jednostki. Np. wynik z poprzedniej iteracji jest potrzebny w obecnej.],
    [*Throughput bound*],
    [Limit wynikający z przepustowości sprzętu.],
  )

  === Fazy przetwarzania
  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [Dispatch],
    [Dekodowanie i alokacja w stacji rezerwacyjnej. CPU może zlecić ograniczoną liczbę instrukcji na cykl.],
    [Execute],
    [Wykonywanie właściwe. Zależne instrukcje mogą rozpocząć `e` w cyklu udostępnienia wyniku (`w`) przez instrukcję poprzedzającą.],
    [Write-back],
    [Udostępnianie wyniku na magistrali. W tym samym cyklu zależne instrukcje zaczynają `e`.],
    [Retire],
    [Zatwierdzenie stanu architektury. Musi zachodzić ściśle in-order.],
  )
]

#from(8)[
  == Tablice i struktury
  === Reprezentacja tablic w pamięci
  #table(
    columns: (auto, auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.header(
      text(fill: rgb("8b949e"))[*Typ*],
      text(fill: rgb("8b949e"))[*Deklaracja*],
      text(fill: rgb("8b949e"))[*Adres*],
    ),
    table.hline(stroke: rgb("333333")),
    [Jednowymiarowa], `T A[L]`, [$&A[i] = x_A + i times "sizeof"(T)$],
    [Wielowymiarowa],
    `T A[R][C]`,
    [$&A[i][j] = x_A + (i times C + j) times "sizeof"(T)$],
    [Wielopoziomowa],
    `T *A[L]`,
    [$M[x_A + i times 8] + j times "sizeof"(T)$ \ (dwa odczyty z pamięci)],
  )

  === Wyrównanie danych i padding
  - *Zasada ogólna:* obiekt rozmiaru $K$ leży pod adresem podzielnym przez $K$.
  - *Struktury:* każde pole wyrównane do własnego $K$; rozmiar całości podzielny przez największe wyrównanie (padding na końcu).
  - *Optymalizacja:* pola od największego do najmniejszego $arrow.r$ minimalny padding.
]

#from(9)[
  == Układ pamięci

  === Mapa pamięci procesu
  #table(
    columns: (25%, 75%),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Stack* #text(fill: rgb("D73A49"))[$arrow.b$]],
    [Rośnie w dół. Zmienne lokalne, adresy powrotu (limit ~8MB).],
    [*Shared libs*],
    [Współdzielone biblioteki (np. `libc.so`).],
    [*Sterta* #text(fill: rgb("28A745"))[$arrow.t$]],
    [Rośnie w górę. Dynamiczna alokacja (`malloc`, `new`).],
    [*Data*],
    [Zmienne globalne i statyczne (zainicjowane i niezainicjowane).],
    [*Text*],
    [Read-only. Binarny kod wykonywalny programu.],
    table.hline(stroke: rgb("222222")),
  )
  #align(center)[
    #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
      Góra tabeli = wysokie adresy, dół = niskie adresy.
    ]
  ]

  === Zagrożenia i mechanizmy obronne
  #table(
    columns: (25%, 75%),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Buffer overflow*],
    [Brak sprawdzania granic tablic. Nadpisuje stos (stary `%rbp`, *adres powrotu*) $arrow.r$ przejęcie sterowania.],
    [*ROP (Gadżety)*],
    [Return-Oriented Programming. Sklejanie legalnych skrawków kodu zakończonych `ret` - omija zakaz wykonywania (NX).],
    [*Stack canaries*],
    [Losowa wartość tuż przed adresem powrotu. Przed `ret` weryfikacja (`xor` + `je`); uszkodzona $arrow.r$ `abort()`.],
    [*NX / ASLR*],
    [*NX:* zakaz wykonywania kodu ze stosu i sterty. \
      *ASLR:* losowanie bazowych adresów obszarów przy każdym starcie.],
  )

  === Unie
  Wszystkie pola współdzielą *ten sam adres* (offset 0); rozmiar = *największe pole*. Służą do manipulacji bitowych z ominięciem systemu typów (np. bity `float` jako `int`).
]

#from(9)[
  #colbreak()
  == Optymalizacje i ich ograniczenia
  Kompilator nie zoptymalizuje kodu, jeśli mogłoby to zmienić zachowanie programu (choćby dla specyficznych argumentów).

  === Optymalizacyjne blokady
  #table(
    columns: (25%, 75%),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Aliasing pamięci*],
    [`*p` i `*q` mogą wskazywać na to samo $arrow.r$ wymuszony odczyt/zapis do RAM zamiast rejestru. Pomaga słowo kluczowe `restrict`.],
    [*Wywołania funkcji*],
    [Funkcja w pętli może mieć ukryte efekty uboczne - nie zostanie wyrzucona poza pętlę. *Rozwiązanie:* inlining lub makra.],
    [*Arytmetyka `float`*],
    [Brak łączności: $(a+b)+c != a+(b+c)$. Kompilator *nigdy* nie zmieni kolejności działań (troska o precyzję).],
  )

  === Podstawowe techniki optymalizacji
  #table(
    columns: (30%, 1fr),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Code motion*],
    [Wyrzucenie niezmienników (np. `x * y`) poza pętlę.],
    [*Strength reduction*],
    [Kosztowne $arrow.r$ tańsze (np. `x * 64` $arrow.r$ `x << 6`, iteracja wskaźnikiem zamiast mnożenia indeksu).],
    [*Share subexpr.*],
    [Jednokrotne obliczanie powtarzających się podwyrażeń.],
    [*Loop unrolling*],
    [Rozwinięcie pętli (np. krok co 2). Mniejszy narzut pętli, więcej równoległości dla CPU.],
  )
]

#from(10)[
  #colbreak()
  == Linkowanie i konsolidacja

  === Fazy budowania programu
  #align(center)[
    #box(
      fill: rgb("1a1a1a"),
      inset: 6pt,
      stroke: (top: 2pt + rgb("333333")),
      radius: 2pt,
    )[
      #show math.equation: set text(fill: rgb("e4e4e4"))
      #text(fill: rgb("28A745"), weight: "bold")[cpp] (Preprocesor) $arrow.r$
      #text(fill: rgb("28A745"), weight: "bold")[cc1] (Kompilator) $arrow.r$
      #text(fill: rgb("28A745"), weight: "bold")[as] (Asembler) $arrow.r$
      #text(fill: rgb("D73A49"), weight: "bold")[ld] (Linker)
    ]
  ]

  === Formaty plików obiektowych (ELF)
  - *Relokowalne (`.o`):* kod i dane gotowe do połączenia z innymi `.o`.
  - *Wykonywalne (`a.out`):* sklejone, gotowe do załadowania i uruchomienia.
  - *Współdzielone (`.so`):* linkowane dynamicznie przy ładowaniu lub w trakcie działania.

  #table(
    columns: (28%, 72%),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    `.text`, [Skompilowany kod maszynowy.],
    `.rodata`,
    [Dane tylko do odczytu (np. `"Witaj"` w `printf`, tablice `switch`).],
    `.data`,
    [Zainicjowane zmienne globalne i statyczne (np. `int x = 5;`).],
    `.bss`,
    [Niezainicjowane globalne/statyczne - nie zajmują miejsca w pliku.],
    `.symtab`,
    [Tablica symboli (funkcje i zmienne globalne).],
    `.rel.text / .data`,
    [Wpisy relokacji: gdzie i jak linker ma wstawić ostateczne adresy.],
  )

  === Symbol resolution
  Linker rozróżnia 3 typy symboli:
  - *Globalne:* zdefiniowane tu, używane tam,
  - *Zewnętrzne:* `extern` - używane tu, zdefiniowane gdzie indziej,
  - *Lokalne:* z C-owym słowem `static`. \
  #text(
    fill: rgb("8b949e"),
    size: 0.8em,
  )[*Uwaga:* Zmienne lokalne na stosie *NIE* są w ogóle widoczne dla linkera]

  #align(center)[
    #box(
      fill: rgb("251414"),
      inset: 8pt,
      stroke: (left: 3pt + rgb("D73A49")),
      width: 100%,
      align(left)[
        *Silne (Strong):* Funkcje i zainicjowane zmienne globalne (np. `int foo = 5;`). \
        *Słabe (Weak):* Niezainicjowane zmienne globalne (np. `int foo;`).
      ],
    )
  ]

  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Reguła 1*],
    [Wiele silnych $arrow.r$ *błąd linkowania* (Multiple definition).],
    [*Reguła 2*],
    [1 silny + $n$ słabych $arrow.r$ wygrywa *silny*.],
    [*Reguła 3*],
    [Wiele słabych $arrow.r$ linker wybiera *dowolny* (`gcc -fno-common` zakazuje).],
  )

  === Relokacja
  Linker skleja sekcje `.text`/`.data` z plików `.o` w jeden blok, nadaje finalne adresy (run-time) i poprawia wszystkie odniesienia w kodzie wg wpisów z `.rel`.

  === Biblioteki
  #table(
    columns: (1fr, 1fr),
    stroke: none,
    column-gutter: 10pt,
    align: top,
    table.cell(
      fill: rgb("1a1a1a"),
      stroke: (top: 2pt + rgb("2188FF")),
      inset: 8pt,
    )[
      *Statyczne (`.a`)* \
      Zbiór plików `.o`. Linker kopiuje *tylko używane moduły*. \
      Wady: każda aplikacja ma własną kopię w RAM, zmiana wymusza relink. \
      *Flagi `gcc`:* `.a` podaje się na końcu komendy.
    ],
    table.cell(
      fill: rgb("1a1a1a"),
      stroke: (top: 2pt + rgb("28A745")),
      inset: 8pt,
    )[
      *Dynamiczne (`.so`)* \
      Kod ładowany do pamięci raz; adresy dostarczane w trakcie działania (przez GOT). \
      Zalety: znacznie mniejsze binarki, łatwe aktualizacje.
    ],
  )

  === Identyfikacja relokacji w kodzie
  Linker musi załatać adresy (wstawić relokacje) w każdym miejscu, gdzie kod:
  - wywołuje funkcję zdefiniowaną w innym pliku/module (np. `printf()`),
  - odwołuje się do zmiennej globalnej (nawet zadeklarowanej w tym samym pliku),
  - odwołuje się do statycznej zmiennej lokalnej (`static int counter;`),
  - używa literału znakowego (np. `"%d "`), który trafia do sekcji `.rodata`.
]

#from(11)[
  #colbreak()
  == Dynamiczna alokacja

  === Rodzaje fragmentacji
  #table(
    columns: (25%, 75%),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Wewnętrzna*],
    [Przydzielony blok jest *większy* niż zażądane dane.],
    [*Zewnętrzna*],
    [Wolnego miejsca jest dość w sumie, ale jest *rozrzucone*.],
  )

  === Budowa bloku
  #align(center)[
    #box(
      fill: rgb("1a1a1a"),
      inset: 8pt,
      stroke: 1pt + rgb("333333"),
      radius: 2pt,
    )[
      #grid(
        columns: (1fr, 1.5fr, 1fr),
        gutter: 4pt,
        align: center,
        box(
          fill: rgb("3b82f644"),
          stroke: (left: 2pt + rgb("3b82f6")),
          inset: 4pt,
          width: 100%,
          [*Header* \ Rozmiar + $a$],
        ),
        box(
          fill: rgb("22c55e44"),
          stroke: (left: 2pt + rgb("22c55e")),
          inset: 4pt,
          width: 100%,
          [*Dane* \ + Padding],
        ),
        box(
          fill: rgb("ef444444"),
          stroke: (left: 2pt + rgb("ef4444")),
          inset: 4pt,
          width: 100%,
          [*Footer* \ (Boundary tag)],
        ),
      )
    ]
  ]

  === Polityki przydziału i łączenia
  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.4em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*First fit*],
    [Pierwszy pasujący od początku. Szybki, fragmentuje początek sterty.],
    [*Next fit*],
    [Od miejsca ostatniego przydziału. Szybszy, gorsza fragmentacja.],
    [*Best fit*],
    [Blok najbliższy żądanemu rozmiarowi. Najlepsza pamięć, najwolniejszy.],
    [*Coalescing*],
    [Łączenie sąsiednich wolnych bloków przy `free()`. Footery $arrow.r$ sprawdzenie poprzednika w $O(1)$.],
  )

  == Hierarchia pamięci i lokalność

  === SRAM vs DRAM
  #table(
    columns: (1fr, 1fr),
    stroke: none,
    column-gutter: 10pt,
    align: top,
    table.cell(
      fill: rgb("1a1a1a"),
      stroke: (top: 2pt + rgb("2188FF")),
      inset: 8pt,
    )[
      *SRAM* \
      Bardzo szybka, droga. Trzyma stan dopóki jest zasilanie (bez odświeżania).
    ],
    table.cell(
      fill: rgb("1a1a1a"),
      stroke: (top: 2pt + rgb("28A745")),
      inset: 8pt,
    )[
      *DRAM* \
      Wolniejsza, tania, pojemna. Wymaga ciągłego odświeżania.
    ],
  )

  === Lokalność
  - *Czasowa:* użyte dane zaraz będą użyte ponownie (np. licznik pętli).
  - *Przestrzenna:* po adresie $x$ zaraz przyjdą $x+1, x+2$ (np. iteracja po tablicy).

  === Rodzaje chybień
  #table(
    columns: (25%, 75%),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Cold (compulsory)*],
    [Blok pobierany z RAM *po raz pierwszy*.],
    [*Capacity*],
    [Working set programu *większy* niż pojemność cache.],
    [*Conflict*],
    [Różne bloki mapują się na *ten sam set* i nawzajem się wypierają, mimo wolnego miejsca gdzie indziej.],
  )
]

#from(12)[
  #colbreak()
  == Pamięć podręczna

  === Parametry i pojemność
  $S = 2^s$ (liczba zbiorów), $E$ (liczba linii w zbiorze), $B = 2^b$ (bajtów na blok danych) \
  Całkowity rozmiar pamięci podręcznej (bez tagów): $C = S times E times B$

  === Podział adresu sprzętowego
  #align(center)[
    #box(
      fill: rgb("1a1a1a"),
      inset: 8pt,
      stroke: 1pt + rgb("333333"),
      radius: 2pt,
    )[
      #grid(
        columns: (1.5fr, 1fr, 1fr),
        gutter: 4pt,
        align: center,
        box(
          fill: rgb("D73A4944"),
          stroke: (left: 2pt + rgb("D73A49")),
          inset: 4pt,
          width: 100%,
          [*Tag* \ $t$ bitów],
        ),
        box(
          fill: rgb("2188FF44"),
          stroke: (left: 2pt + rgb("2188FF")),
          inset: 4pt,
          width: 100%,
          [*Indeks* \ $s$ bitów],
        ),
        box(
          fill: rgb("28A74544"),
          stroke: (left: 2pt + rgb("28A745")),
          inset: 4pt,
          width: 100%,
          [*Offset* \ $b$ bitów],
        ),
      )
    ]
  ]
  - *Tag:* Identyfikator bloku. Sprawdzany w $O(1)$ dla linii w danym zbiorze.
  - *Indeks:* Wskazuje sprzętowo na zbiór.
  - *Offset:* Konkretny bajt wewnątrz bloku danych.
  - *Valid bit:* Czy linia ma poprawne dane (1), czy śmieci (0).

  === Asocjatywność
  #table(
    columns: (auto, 1fr),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    [*Direct-mapped*],
    [$E=1$. Adres pasuje do *dokładnie jednej* linii. Szybkie, ale adresy o tym samym indeksie się wypierają.],
    [*E-way assoc.*],
    [$E>1$. Blok ma zbiór, ale w nim *dowolną* linię. Wymaga strategii wymiany (np. LRU).],
    [*Fully assoc.*],
    [$S=1$. Linia może trafić *gdziekolwiek*. Bardzo drogie sprzętowo.],
  )

  === Polityki zapisu
  #table(
    columns: (1fr, 1fr),
    stroke: none,
    column-gutter: 10pt,
    align: top,
    table.cell(
      fill: rgb("1a1a1a"),
      stroke: (top: 2pt + rgb("2188FF")),
      inset: 8pt,
    )[
      *Write-hit* \
      - *Write-through:* równoczesny zapis do cache i RAM. \
      - *Write-back:* zapis tylko do cache + *dirty bit*. RAM aktualizowany przy wyrzuceniu linii.
    ],
    table.cell(
      fill: rgb("1a1a1a"),
      stroke: (top: 2pt + rgb("28A745")),
      inset: 8pt,
    )[
      *Write-miss* \
      - *Write-allocate:* wciąga blok z RAM do cache, potem nadpisuje. Para z write-back. \
      - *No-write-allocate:* zapis prosto do RAM, z pominięciem cache. Para z write-through.
    ],
  )
]

#from(13)[
  == Pamięć wirtualna

  === Translacja adresów (VA $arrow.r$ PA)
  #align(center)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 10pt,
      box(fill: rgb("1a1a1a"), inset: 8pt, stroke: (top: 2pt + rgb("2188FF")))[
        *Virtual Address* \
        `VPN` | `VPO`
      ],
      box(fill: rgb("1a1a1a"), inset: 8pt, stroke: (top: 2pt + rgb("28A745")))[
        *Physical Address* \
        `PPN` | `PPO`
      ],
    )
  ]
  - *VPO = PPO:* Offset *nigdy się nie zmienia* przy translacji.
  - Sprzętowy układ MMU zamienia `VPN` na `PPN` używając *tablicy stron*.

  === Tablice stron i TLB
  - *Page fault:* dostęp do strony spoza RAM $arrow.r$ wyjątek; OS wstrzymuje proces i wczytuje stronę z dysku.
  - *TLB:* mały sprzętowy cache translacji (`VPN` $arrow.r$ `PPN`) wewnątrz CPU - eliminuje odczyt tablicy stron z pamięci przy każdym żądaniu.
    - *Struktura TLB:* Jeżeli TLB jest pamięcią *w pełni asocjacyjną*, to `VPN` w całości stanowi tag TLB. W przeciwnym wypadku, `VPN` dzieli się na tag oraz dodatkowo na indeks, który określa konkretny zbiór wewnątrz TLB.

  === VIPT (Virtually Indexed, Physically Tagged)
  Gdy L1 jest małe, indeks (`CI`) mieści się w `VPO`, a `VPO = PPO`:
  #flow(
    rgb("2188FF"),
    [`VPO` $arrow.r$ indeks L1],
    [równolegle: `VPN` $arrow.r$ TLB],
    [tag `CT` weryfikuje wiersz],
  )
  Lookup zbioru w L1 startuje *równolegle* z translacją w TLB, co skraca czas dostępu.
]

#from(15)[
  == Wyjątkowe przepływy (ECF) i procesy
  Zjawiska na poziomie sprzętu/OS zakłócające sekwencyjny przepływ sterowania.

  === Klasy wyjątków
  #table(
    columns: (22%, 18%, 25%, 1fr),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.header(
      text(fill: rgb("8b949e"))[*Klasa*],
      text(fill: rgb("8b949e"))[*Typ*],
      text(fill: rgb("8b949e"))[*Powrót do*],
      text(fill: rgb("8b949e"))[*Przykład*],
    ),
    table.hline(stroke: rgb("333333")),
    [*Interrupt*],
    [async],
    [następnej instrukcji],
    [Timer, I/O, klawiatura],
    [*Trap*],
    [sync],
    [następnej instrukcji],
    [Celowe wywołanie: `syscall`, breakpoint],
    [*Fault*],
    [sync],
    [*bieżącej* instrukcji],
    [Page fault (brak strony), segfault],
    [*Abort*],
    [sync],
    [nie wraca],
    [Krytyczny błąd sprzętowy pamięci],
  )

  === Wywołania systemowe
  #align(center)[
    #box(
      fill: rgb("1a1a1a"),
      inset: 6pt,
      stroke: (top: 2pt + rgb("D73A49")),
      radius: 2pt,
    )[
      #show regex("%"): set text(fill: white)
      #show math.equation: set text(fill: rgb("e4e4e4"))
      #text(fill: rgb("D73A49"))[
        `%rdi` $arrow.r$ `%rsi` $arrow.r$ `%rdx` $arrow.r$ `%r10` $arrow.r$ `%r8` $arrow.r$ `%r9`
      ]
    ] \
    #text(
      fill: rgb("8b949e"),
      size: 0.75em,
      style: "italic",
    )[*Uwaga:* W `syscall` 4. argument to `%r10`]
  ]
  - *ID:* w `%rax` przed skokiem (np. `0`=read, `1`=write, `57`=fork).
  - *Wynik:* w `%rax` (wartości od -4095 do -1 to błąd `errno`).
]

#from(4)[
  #colbreak()
  #colbreak()
  == Katalog instrukcji (AT&T)
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

    `mov S, D`, $D arrow.l S$, [Kopiuje wartość z S do D.],
    `lea S, D`,
    $D arrow.l "addr"(S)$,
    [Oblicza adres S (bez czytania pamięci).],
    `add S, D`, $D arrow.l D + S$, [Dodawanie (ustawia flagi).],
    `sub S, D`, $D arrow.l D - S$, [Odejmowanie (ustawia flagi).],
    `imul S, D`, $D arrow.l D * S$, [Mnożenie liczb ze znakiem.],
    `sal / shl k, D`,
    $D limits(<<)= k$,
    [Przesunięcie w lewo (mnożenie przez $2^k$).],
    `sar k, D`,
    $D limits(>>)= k$,
    [Arytmetyczne w prawo (dzielenie). *Kopiuje znak*.],
    `shr k, D`, $D limits(>>)= k$, [Logiczne w prawo. Dopełnia zerami.],
    `and / or S, D`,
    $D arrow.l D "& / |" S$,
    [Operacje bitowe (ustawiają flagi).],
    `xor S, D`,
    $D arrow.l D "^" S$,
    [Często jako `xor %rax, %rax` do zerowania.],
  )

  #from(5)[
    === Porównania i sterowanie
    #table(
      columns: (30%, 30%, 1fr),
      stroke: none,
      row-gutter: 0.5em,
      align: horizon,
      table.hline(stroke: rgb("333333")),
      `cmp S1, S2`,
      $"S2" - "S1"$,
      [Ustawia flagi jak odejmowanie, nie zapisuje wyniku.],
      `test S1, S2`,
      $"S2 & S1"$,
      [Ustawia flagi jak *AND*.],
      `jX dest`,
      $"if"(X) "%rip" arrow.l "dest"$,
      [Skok warunkowy (X = warunek).],
      `setX D`,
      $"if"(X) D arrow.l 1$,
      [Ustawia najmłodszy bajt na 0 lub 1 wg flag.],
      `cmovX S, D`,
      $"if"(X) D arrow.l S$,
      [Warunkowe kopiowanie (zamiast skoku).],
    )
  ]

  #from(6)[
    === Stos i zarządzanie procedurami
    #table(
      columns: (30%, 30%, 1fr),
      stroke: none,
      row-gutter: 0.5em,
      align: horizon,
      table.hline(stroke: rgb("333333")),
      `push S`,
      $"%rsp" -= 8 \ M["%rsp"] arrow.l S$,
      [Odkłada na stos (zmniejsza `%rsp`).],
      `pop D`,
      $D arrow.l M["%rsp"] \ "%rsp" += 8$,
      [Zdejmuje ze stosu do D (zwiększa `%rsp`).],
      `call dest`,
      $"push" "%rip" \ "%rip" arrow.l "dest"$,
      [Skok do funkcji (zapisuje adres powrotu na stosie).],
      `ret`,
      $"pop" "%rip"$,
      [Zdejmuje adres powrotu ze stosu i skacze pod niego.],
      `leave`,
      $"%rsp" arrow.l "%rbp" \ "pop" "%rbp"$,
      [Sprząta ramkę stosu (odwrotność prologu).],
    )
  ]
]

#from(7)[
  #colbreak()
  === Operacje wektorowe
  Rozszerzenie AVX. Przedrostek `v` (nie niszczy źródeł).
  #table(
    columns: (30%, 30%, 1fr),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    `vmovaps / ups S, D`,
    $D arrow.l S$,
    [Kopiuje wektor. `a` (aligned - szybkie, adres podzielny przez wyrównanie), `u` (unaligned).],
    `vaddps / pd S1, S2, D`,
    $D arrow.l "S2" + "S1"$,
    [Dodawanie wielokrotne (packed). `ps` (single-float), `pd` (double).],
    `vmulps / pd S1, S2, D`,
    $D arrow.l "S2" * "S1"$,
    [Mnożenie wektorowe.],
    `vfmadd231ps S1, S2, D`,
    $D arrow.l "S2" * "S1" + D$,
    [*Fused Multiply-Add*. Mnoży i dodaje do `D` w jednym kroku.],
  )
]

#from(8)[
  === Operacje zmiennoprzecinkowe
  #table(
    columns: (30%, 30%, 1fr),
    stroke: none,
    row-gutter: 0.5em,
    align: horizon,
    table.hline(stroke: rgb("333333")),
    `movsd / movss S, D`,
    $D arrow.l S$,
    [Kopiuje skalar (`double` / `float`) między rejestrami XMM lub pamięcią.],
    `movapd / movaps S, D`,
    $D arrow.l S$,
    [Kopiuje wyrównany wektor zmiennoprzecinkowy.],
    `addsd / subsd S, D`,
    $D arrow.l D "op" S$,
    [Skalarne dodawanie / odejmowanie podwójnej precyzji.],
    `xorpd / xorps S, D`,
    $D arrow.l D \^ S$,
    [Bitowy XOR na XMM. Jako `xorpd %xmm0, %xmm0` zeruje rejestr.],
    `ucomisd S1, S2`,
    $"S2" - "S1"$,
    [Porównuje `double` i ustawia flagi `ZF, PF, CF` w `%rflags`.],
  )
]

#from(4)[
  #v(2pt)
  #align(center)[
    #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
      *Uwaga o sufiksach:* Instrukcje przyjmują sufiks określający rozmiar danych: \
      `b` ($8$-bit), `w` ($16$-bit), `l` ($32$-bit), `q` ($64$-bit). \
      Np. `movl` kopiuje $32$ bity (i automatycznie zeruje górną połowę 64-bitowego rejestru!).
    ]
  ]
]

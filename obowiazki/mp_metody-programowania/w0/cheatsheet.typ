#set page(
  paper: "us-letter",
  fill: rgb("121212"),
  margin: 0.25in,
  footer: align(right)[
    #text(fill: rgb("333333"), size: 8pt)[
      Michał Kosior | gh: \@crqch
    ]
  ],
)

#set text(
  font: "FreeSans",
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

#show raw: set text(font: "BigBlueTermPlus Nerd Font Mono")
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

#show link: underline
#show link: set text(rgb("2188FF"))

#show math.equation: set text(size: 1.15em)


#let addr-row(name, synt, calc) = {
  grid(
    columns: (35%, 25%, 1fr),
    gutter: 10pt,
    align: (left, left, left),
    [*#name*], raw(synt), calc,
  )
  v(0.4em)
}

= Metody Programownia: Reference
*Data:* #datetime.today().display() \

== 0. Setup środowiska developerskiego
Do programowania w OCaml najpierw potrzebujemy ustawić nasze środowisko developerskie. Poniżej najważniejsze kroki do wykonania.

#link("https://opam.ocaml.org/doc/Install.html")[ Instalacja OPAM, wg systemu operacyjnego. ]

Zaktualizowanie OPAM
```sh
opam update
```

Zainicjalizowanie menedżera zasobów OPAM
```sh
opam init --bare -a -y
```

Dodanie instalacji (switcha) OCamla z odpowiednimi zależnościami i wersją kompilatora
```sh
opam switch create cs3110-2026sp ocaml-base-compiler.5.3.0
```

Teraz wyloguj się z systemu operacyjnego, lub zrestartuj komputer.

Po wpisaniu `opam switch list` powinieneś otrzymać dokładnie takie wyjście:

```
~ ❱ opam switch list
#  switch         compiler                                           description
→  cs3110-2026sp  ocaml-base-compiler.5.3.0,ocaml-options-vanilla.1  ocaml-base-compiler = 5.3.0
```

#align(center)[
  #text(fill: rgb("8b949e"), size: 0.75em, style: "italic")[
    *Uwaga:* Jeśli zobaczysz ostrzeżenie
    ```
    [WARNING] The environment is not in sync with the current switch.
              You should run: eval (opam env)
    ```
    , musisz ręcznie skonfigurować swój interfejs powłoki (ang. _text interface shell_).
  ]
]

Zainstalowanie zależności potrzebnych do wykładu

```sh
opam install -y utop odoc ounit2 qcheck bisect_ppx menhir ocaml-lsp-server ocamlformat
```

To nie są wszystkie zależności. Niektóre, jak `csv` mogą pojawić się na pracowni. Instalujemy je wtedy podobnie, np.
```sh
opam install -y csv
```


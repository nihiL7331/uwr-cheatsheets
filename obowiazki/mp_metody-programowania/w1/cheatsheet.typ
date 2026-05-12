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

== 1. Typy danych w OCamlu

=== Podstawowe typy danych

#box[

  #grid(
    columns: (1fr, 1fr),
    gutter: 10pt,

    box[
      Liczby całkowite
      ```ml
      _ : int = 3
      ```
    ],

    box[
      Liczby zmiennoprzecinkowe
      ```ml
      _ : float = 3.14
      ```
    ],

    box[
      Wartości algebry Boole'a
      ```ml
      _ : bool = true
      ```
    ],

    box[
      Znaki wypisywane
      ```ml
      _ : char = 'a'
      ```
    ],

    grid.cell(colspan: 2)[
      #box[
        Ciągi znaków wypisywalnych
        ```ml
        _ : string = "Hello World"
        ```
      ]
    ],
  )
]

=== Wbudowane struktury danych


==== Krotki
*Deklaracja typu:* iloczyn kartezjański typów na odpowiednich pozycjach

*Konstruktor:* poszczególne składowe oddzielone przecinkiem

*Destruktor:* tak jak konstruktor

Przykłady:
```ml
_ : int * int = (4,2)
_ : int * string = 4,"dwa"
_ : int * string * float = 4,"dwa",3.14
_ : (int * int) * int = (1,2),3

(* destruktor *)

match (4,2) with (fst, snd) -> ...
```

==== Tablice
_(nie są używane na przedmiocie)_

*Deklaracja typu:* typ elementów po czym następuje `array`

*Konstruktor:* elementy oddzielone średnikiem (;), obłożone pałką (|), obłożone nawiasami kwadratowymi ([])

*Destruktor:* pozyskiwanie konkretnego, i-tego elementu przez `.(i)` na końcu

Przykłady:
```ml
_ : int array = [| 4; 2; 1 |]
_ : int = [| 4; 2; 1 |].(2) (* -> 1 *)
```

==== Listy
*Deklaracja typu:* typ elementów po czym następuje `list`

*Konstruktory:*
- wykorzystanie operatora cons typu ```ml 'a -> 'a list -> 'a list```, który dokłada element z lewej strony na początek listy. Złożoność: O(1).
- elementy oddzielone średnikiem (;), obłożone nawiasami kwadratowymi ([])

*Destruktor:* wykorzystywanie operatora `cons` czyli ```ml ::```.

Przykłady:
```ml
_ : int list = [ 4; 2; 1 ]
_ : int list = 4 :: 2 :: 1 :: []
_ : int = match [ 4; 2; 1 ] with four :: rest -> four
```

=== Funkcje

Funkcja jest podstawowym typem wartości w OCamlu. Typ określamy jako ```ml 'a -> 'b```. Funkcje można składać, wykorzystując popularny lukier syntaktyczny przez wymianę argumentów po spacji, np. ```ml fun a b -> a + b```, to tak naprawdę ```ml fun a -> fun b -> a + b```.

*Deklaracja typu:* typ argumentu -> typ wyjścia

*Konstruktor:* lambda, składnia: `fun <argument> -> <wyrażenie>`

*Destruktor:* wywołanie funkcji na argumencie typu ```ml 'a```.

Przykłady:
```ml
(* typ funkcji: int -> int *)
(fun a -> a * a) 2
|_ (2 * 2)
|_ 4

(* typ funkcji: int -> int -> int *)
(fun a b -> a + b) 2 5
|_ (fun a -> fun b -> a + b) 2 5
  |_ (fun b -> 2 + b) 5
  |_ (2 + 5)
  |_ 7
```

Funkcje można definiować za pomocą skróconej składni ```ml let```:

```ml let add a b = a + b``` zamiast ```ml let add = fun a b -> a + b```.

== 2. Wiązanie zmiennych

Wiązanie odbywa za pomocą słowa kluczowego ```ml let```.

np.
```ml let a = 5```

Aby zawęzić zakres danej zmiennej, możemy użyć słowa kluczowego ```ml in```, w ten sposób:

```ml
let a = 5 in a + 10 (* wyewaluuje się do 15 *)

let b = c + 10 (* BŁĄD! Niezwiązana zmienna 'c'! *)
```

Możemy zagnieżdżać wiązania:

```ml
let a = 2 in
  let b = 40 in
    let c = a + b in
      c

(* całe to wyrażenie wyewaluuje się do 42 *)
```

oraz wiązać wiele zmiennych jednocześnie

```ml
let a = 2 and b = 40 in
  a + b

let a = 2 and b = a + 38 in (* BŁĄÐ!: Niezwiązana zmienna 'a'!*)
  a + b

(* Wyjaśnienie: wyrażenie a + 38 nadal jest w tym samym zakresie (scope) co samo let, więc żadne 'a' nie zostało jeszcze związane. *)
```

Jak wspomnieliśmy wyżej, istnieje lukier syntaktyczny na definiowanie funkcji.

Zamiast ```ml let add = fun a b -> a + b``` możemy zapisać ```ml let add a b = a + b```. Zauważmy, że związanie ```ml let add a = fun b -> a + b``` również odnosi się do tej samej funkcji.

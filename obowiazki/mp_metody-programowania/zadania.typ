#align(center + horizon)[
  #text(size: 18pt)[*Metody Programowania*]

  _Zadania do treningu_

  #v(40pt)

  Data aktualizacji: #datetime.today().display()
]

#set page(
  header: box(inset: 10pt, stroke: (bottom: 0.5pt + black), width: 100%)[
    #columns(2)[
      #text(size: 8pt)[*Metody Programowania* \ Zadania do treningu]
      #colbreak()
      #align(end)[#text(size: 8pt)[*Data kompilacji:* #datetime.today().display()]]
    ]
  ],
  numbering: "1",
)


#outline(title: [
  Tablica zawartości
  #v(10pt)
])
#show raw: set text(font: "CMU Typewriter Text", fallback: false)

#set heading(numbering: "I.1")

#show heading: it => {
  let size = 1em

  if it.numbering == none {
    return text(size: size + 0.2em, weight: "bold")[#it.body]
  }

  let heading_number = counter(heading).display()

  if (it.depth == 1) {
    block(
      inset: (x: 12pt, y: 10pt),
      width: 100%,
      radius: 2pt,
      fill: luma(240),
    )[
      *#heading_number*.
      #text(size: size, font: "CMU Classical Serif")[
        #it.body
      ]
    ]
  } else {
    text(size: size, weight: "regular")[
      #heading_number _ #it.body _
    ]
  }
}

#pagebreak()

= Przedmowa

Materiału do przedmiotu _Metod Programowania_ nie da się nauczyć w tydzień.
Nawet dwa tygodnie nie wystarczą. Najambitniejsi być może zdołają to uczynić w
2 tygodnie i 42 sekundy. Przedmiot ten wymaga systematycznej pracy,
programowania w OCamlu na co dzień, realizowania zadań z list i pracowni,
zadawania pytań. Zainteresowanie tematem języków programowania może usprawnić
systematyczną pracę, pozwolić głębiej zrozumieć problemy zadawane na zajęciach.

Innymi słowy – jeżeli za  $< "tydzień"$ masz egzamin i nie wiesz o czym jest
ten przedmiot, to lepiej zmienić studia lub przygotowywać się do powtarzania
MP. *Natomiast*, jeżeli skrupulatnie się uczyłeś, chodziłeś na wykłady i na
nich uważałeś, próbowałeś podchodzić do większości zadań z list – nie masz
raczej czego się bać. Ten zestaw pytań to będzie dla Ciebie jedynie powtórka z
materiału całego wykładu, usystematyzowanie wiedzy, ćwiczenia mentalne. Na
spokojnie można to przejrzeć dzień przed egzaminem, spróbować porozwiązywać
parę zadań samodzielnie, a resztę dnia odpoczywać.

Jeśli jednak masz problemy z $>$ połową zadań, to na naukę zapewne za późno,
ale warto próbować. Powodzenia!

#v(20pt)

== Format zawartości

Każde zadanie jest wydrukowane na osobnej kartce, dając miejsce na samodzielne
rozwiązanie/nie spojlerując odpowiedzi. Na stronach kolejnych są wszelkie
wskazówki do zadania, które mogą lekko pomóc w jego rozwiązaniu. Wreszcie –
rozwiązanie z wyjaśnieniem.

Ponownie, na naukę widząc ten materiał parę dni przed sesją, pewnie już za
późno. Tutaj zakładam że większość rzeczy jest znane, tłumacząc tylko rzeczy
mniej widoczne dla niewprawionego oka.

#pagebreak()

= Wiązanie zmiennych

W poniższych wyrażeniach podkreśl wolne wystąpienia zmiennych. Dla każdego związanego wystąpienia zmiennej, narysuj strzałkę od tego wystąpienia do wystąpienia wiążącego je.

#box(width: 100%)[
  #show raw.where(): set text(1em / 0.8)
  #show raw.where(block: true): it => {
    set par(leading: 2em) // Zmień tę wartość (np. 0.8em, 1.2em), aby dostosować odstęp
    it
  }
  #grid(
    columns: (1fr, 1fr),
    stroke: 0.5pt + luma(50%),
    inset: 10pt,
    align: center + horizon,
    gutter: 15pt,

    ```ml
    let f x =
      let x = x
      and y = x * y in
      f x y z
    ```,
    ```ml
    fun f x y ->
      let z = x + y in
      let x = y + x in
      fun y -> g x y z
    ```,

    ```ml
    let rec f x =
      let rec g z y = j y (f z)
      and j y z = g z (f y)
      in
      if g y > f x then
        g x
      else
        g y
    ```,
    ```ml
    let fun x = x * x in
    (fun x -> x * 5) y
      |> (fun x -> y)
      |> x
    ```,

    ```ml
    let zagadka b c f =
      match b with
      | [] -> []
      | a :: b ->
        zagadka b (f a c) f
    ```,
    ```ml
    let z = function
      | [] -> 0
      | _ :: d -> 1 + (z d)
    and f = z
    and g xs ys =
      (f xs) * (f ys)
    ```,
  )
]

#pagebreak()

= Typowanie wyrażeń

Dla poniższych wyrażeń w języku OCaml podaj ich (najogólniejszy) typ, lub napisz `BRAK TYPU`, gdy wyrażenie nie posiada typu (nie typuje się)

#table(
  columns: (20pt, 1fr, 1fr),
  stroke: 0.5pt,
  [Lp], [Wyrażenie], [Typ],

  [1.],
  ```ml
  fun x -> x
  ```,
  [],

  [2.],
  ```ml
  fun x -> x *. 2
  ```,
  [],

  [3.],
  ```ml
  fun x y -> !x > (y+2,10)
  ```,
  [],

  [4.],
  ```ml
  let rec add a b =
    if b = 0 then a
    else add (a + 1) (b-1)
  ```,
  [],

  [5.],
  ```ml
  fun f x -> f (f x)
  ```,
  [],

  [6.],
  ```ml
  fun f -> (fun x -> f x x)(fun y -> f y y)
  ```,
  [],

  [7.],
  ```ml
  fun f x -> f (f x) > x
  ```,
  [],

  [8.],
  ```ml
  fun a b c f d g e -> f b d c (g a)
  ```,
  [],

  [9.],
  ```ml
  List.fold_right
  ```,
  [],

  [10.],
  ```ml
  List.map
  ```,
  [],

  [11.],
  ```ml
  List.iter2
  ```,
  [],

  [12.],
  ```ml
  fun f x y -> f
  ```,
  [],
)

#pagebreak()

= Rekurencja ogonowa

Określ czy definicje poniższych funkcji rekurencyjnych są ogonowe. Jeżeli tak, wpisz w komórce obok `TAK`, jeżeli nie – przepisz je na ogonowe, lub uzasadnij, dlaczego to niemożliwe.

#table(
  columns: (20pt, 1fr, 1fr),
  stroke: 0.5pt,
  inset: (5pt, 20pt, 20pt, 5pt),
  align: horizon,

  table.cell(inset: 4pt)[Lp], table.cell(inset: 4pt)[Definicja funkcji], table.cell(inset: 4pt)[Odpowiedź],

  [1.],
  ```ml
  let rec f a =
    if a < 0 then -1
    else if a = 0 then a
    else a + f (a-1)
  ```,
  [],

  [2.],
  ```ml
  let rec comp f fil a =
    if fil a
      then a
      else comp f fil (f a)
  ```,
  [],

  [3.],
  ```ml
  let rec f g xs =
    match xs with
      | [] -> g 0
      | x :: xs -> (g x) :: (f g xs)
  ```,
  [],

  [4.],
  ```ml
  let rec app xs ys =
    match xs with
      | [] -> ys
      | x :: xs -> x :: (app xs ys)
  ```,
  [],

  [5.],
  ```ml
  let rec comp f fil a =
    if fil a
    then a
    else 1 + comp f fil (f a)
  ```,
  [],

  [6.],
  ```ml
  let rec f g xs acc =
    match xs with
      | [] -> acc
      | x :: xs -> f g xs (g acc x)
  ```,
  [],
)

#pagebreak()

= Identyfikacja funkcji

W każdym rzędzie podana jest funkcja w postaci typu, definicji i jej działania. Wypełnij brakujące informacje.

Pierwszy wpis (dla `square`) jest podany jako przykład.

#table(
  columns: (20pt, 0.6fr, 1fr, 1fr),
  stroke: 0.5pt,
  inset: (5pt, 20pt, 20pt, 5pt),
  align: horizon,

  table.cell(inset: 4pt)[Lp],
  table.cell(inset: 4pt)[Typ funkcji],
  table.cell(inset: 4pt)[Definicja funkcji],
  table.cell(inset: 4pt)[Opis funkcji],

  [1.],
  [`int -> int`],
  [```ml fun a -> a * a```],
  [Podnosi argument $a$ do kwadratu.],

  [2.],
  [`int -> 'a -> 'a list -> 'a list`],
  [],
  [Wstawia $n$ elementów $a$ na początek listy $x s$.],

  [3.],
  [],
  [
    ```ml
    fun a b c ->
      if a > 0 then b a
      else c a
    ```
  ],
  [],

  [4.],
  table.cell(inset: 4pt)[```
  (ident * expr) list -> ident -> expr
  -> (ident * expr) list

  ```],
  [#v(120pt)],
  [Aktualizuje (jeżeli para z pierwszą współrzędną równą `ident` jest już w liście, to ją najpierw usuwa) listę par wprowadzając nową parę `(ident, expr)`.],

  [5.],
  [],
  [#v(80pt)],
  [Zamienia listę elementów typu $tau "opt"$ na listę elementów typu $tau$, pozbywając się pustych elementów.],
)

#pagebreak()

= Funkcje na listach

Zaimplementuj i otypuj poniższe funkcje biblioteczne. *Nie* możesz korzystać z funkcji bibliotecznych innych niż zaimplementowane.

#underline("Podkreśl") nazwy funkcji które są rekurencyjne ogonowo.

#table(
  columns: (20pt, 0.6fr, 1fr, 1fr),
  stroke: 0.5pt,
  inset: (5pt, 20pt, 20pt, 5pt),
  align: horizon,

  table.cell(inset: 4pt)[Lp],
  table.cell(inset: 4pt)[Nazwa funkcji],
  table.cell(inset: 4pt)[Typ funkcji],
  table.cell(inset: 4pt)[Definicja funkcji],

  [1.],
  [`List.fold_left`],
  [],
  [#v(100pt)],

  [2.],
  [`List.fold_right`],
  [],
  [#v(100pt)],

  [3.],
  [`List.map`],
  [],
  [#v(100pt)],

  [4.],
  [`List.filter`],
  [],
  [#v(100pt)],
)

Zaimplementuj funkcje opisane słownie poniżej, korzystając wyłącznie z powyżej wymienionych funkcji. (Jeżeli nie zaimplementowałeś danej funkcji, ale wiesz co ona robi, nadal możesz z niej skorzystać – poprawność przekazywania argumentów nie będzie wtedy brana pod uwagę)

W szczególności nie możesz definiować kolejnych funkcji rekurencyjnych.

#table(
  columns: (20pt, 0.6fr, 1fr),
  stroke: 0.5pt,
  inset: (5pt, 20pt, 20pt, 5pt),
  align: horizon,

  table.cell(inset: 4pt)[Lp],
  table.cell(inset: 4pt)[Opis słowny],
  table.cell(inset: 4pt)[Definicja funkcji],

  [1.],
  table.cell(inset: 4pt)[Funkcja przyjmująca listę liczb całkowitych, licząca ich sumę.],
  [],

  [2.],
  table.cell(inset: 4pt)[Funkcja przyjmująca listę list liczb całkowitych, licząca maksimum sum podlist.],
  [#v(100pt)],

  [3.],
  table.cell(
    inset: 4pt,
  )[Funkcja przyjmująca listę list zwracająca `true` wtw. gdy długości tych podlist są w kolejności rosnącej.
    (np. `[(4);(5);(100)]`, gdzie `(x)` oznacza listę o długości $x$ zwróci `true`, a `[(3);(5);(4)]` zwróci `false`)],
  [#v(80pt)],

  [4.],
  table.cell(
    inset: 4pt,
  )[Funkcja przyjmująca listę par typu `(('a -> 'b) * 'a list)`, zwracająca listę list w których każdy element został zaaplikowany do odpowiedniej funkcji w pierwszej współrzędnej pary. (np. wynikiem `[((fun x -> x * x), 2;3;4)]` będzie `[[4;9;16]]`)],
  [#v(100pt)],
)

#pagebreak()

#let te(body) = highlight(fill: red.transparentize(80%))[
  #text(fill: fuchsia)[#body]
]

= Gramatyki

== Zadanie 1.

Dla poniżej zapisanych gramatyk określ czy są one jednoznaczne. Jeżeli nie, napisz kontrprzykład w ramce.

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S}, \
        & T = {a}, \
        & P = { \
        & quad S -> a S, \
        & quad S -> epsilon S, \
        & quad S -> a \
      }
    $]
    #box(width: 100%, height: 140pt, stroke: 0.5pt + black)
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S}, \
        & T = {(, )}, \
        & P = { \
        & quad S -> S S, \
        & quad S -> (S), \
        & quad S -> epsilon \
      }
    $]
    #box(width: 100%, height: 140pt, stroke: 0.5pt + black)
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S, D}, \
        & T = {1,2,3,+,-}, \
        & P = { \
        & quad D -> 1, D -> 2, D -> 3 \
        & quad S -> D, \
        & quad S -> S + S, \
        & quad S -> S - S, \
        & quad S -> epsilon \
      }
    $]
    #box(width: 100%, height: 140pt, stroke: 0.5pt + black)
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S, V}, \
        & T = {top, bot, =>, not, "a", "b", ..., "z"}, \
        & P = { \
        & quad V -> bot, V -> top, \
        & quad V -> "a", V -> "b", ..., V -> "z" \
        & quad S -> S => S, \
        & quad S -> not S, \
        & quad S -> epsilon \
      }
    $]
    #box(width: 100%, height: 140pt, stroke: 0.5pt + black)
  ]

#pagebreak()

== Zadanie 2.

Dla niejednoznacznych gramatyk z zadania wyżej zapisz gramatyki równoważne, które są jednoznaczne. Tam gdzie gramatyka już była jednoznaczna, zostaw pole puste.


+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S}, \
        & T = {a}, \
        & P = { \
        & quad S -> a S, \
        & quad S -> epsilon S, \
        & quad S -> a \
      }
    $]
    #box(width: 100%, height: 140pt, stroke: 0.5pt + black)
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S}, \
        & T = {(, )}, \
        & P = { \
        & quad S -> S S, \
        & quad S -> (S), \
        & quad S -> epsilon \
      }
    $]
    #box(width: 100%, height: 140pt, stroke: 0.5pt + black)
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S, D}, \
        & T = {1,2,3,+,-}, \
        & P = { \
        & quad D -> 1, D -> 2, D -> 3 \
        & quad S -> D, \
        & quad S -> S + S, \
        & quad S -> S - S, \
        & quad S -> epsilon \
      }
    $]
    #box(width: 100%, height: 140pt, stroke: 0.5pt + black)
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S, V}, \
        & T = {top, bot, =>, not, "a", "b", ..., "z"}, \
        & P = { \
        & quad V -> bot, V -> top, \
        & quad V -> "a", V -> "b", ..., V -> "z" \
        & quad S -> S => S, \
        & quad S -> not S, \
        & quad S -> epsilon \
      }
    $]
    #box(width: 100%, height: 140pt, stroke: 0.5pt + black)
  ]


#pagebreak()

= Abstrakcyjne typy danych

== Rozwinięcie typów języka

=== Język arytmetycznych wyrażeń

Rozważamy język wyrażeń arytmetycznych na liczbach całkowitych z dodawaniem, odejmowaniem, dzieleniem, mnożeniem. Rozwiń następujące typy:

#grid(
  columns: 1,
  row-gutter: 4pt,

  ```ml
  type binop =
  ```,
  box(width: 100%, height: 60pt, stroke: 0.5pt),
  ```ml
  type expr =
  ```,
  box(width: 100%, height: 100pt, stroke: 0.5pt),
)

#pagebreak()

=== Język `calc_let`

Rozważamy język gdzie wartości mogą wartościami algebry Boole'a, liczbami całkowitymi, parami i listami wartości.
Napisz typ dla `value`:

#grid(
  columns: 1,
  row-gutter: 4pt,

  ```ml
  type value =
  ```,
  box(width: 100%, height: 60pt, stroke: 0.5pt),
)

Dla liczb całkowitych deifniujemy operację dodawania, odejmowania, mnożenia, dzielenia. Dla takich samych typów definiujemy relacje $<, >, >=, <=, =$.
Poza tym definiujemy następujące wyrażenia:
- związanie wyrażenia do zmiennej w wyrażeniu: `let x = e1 in e2`,
- operator `cons` do dostawienia wartości na początku listy,
- `fst` i `snd` dla list.

#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  [
    Dany jest następujący typ składni abstrakcyjnej:
    ```ml
    type bop = Mult | Div | Add | Sub

    type var = string

    type expr =
      | Var   of var
      | Int   of int
      | Binop of bop * expr * expr
      | Let   of var * expr * expr
      | Pair  of expr * expr
      | Fst   of expr
      | Snd   of  expr
    ```
  ],
  [
    Dane są następujące tokeny:
    ```
    IDENT
    MULT DIV ADD SUB EQ
    LPAR RPAR COMMA
    FST SND
    LET IN
    EOF
    ```
  ],
)


Uzupełnij brakującą definicję gramatyki w menhir:

```ml
main:
  | e = expr; EOF { e }
  ;

expr:
  | LET;


  | e = opexpr { e }
  ;

opexpr:
  | i = INT { Int i }





  | LPAR; e = expr; RPAR { e }
  | LPAR; e1 = expr; COMMA; e2 = expr; RPAR { Pair(e1, e2) }


  | SND; e = expr; { Snd(e) }
  | x = IDENT { Var x }
  ;
```



#pagebreak()

== Monady

#box(fill: lime.transparentize(90%), inset: 10pt)[
  *Informacja*

  Monady w tak bezpośredni sposób jak poniżej się nie pojawiły na wykładzie lub ćwiczeniach, ale takie pytanie ma szansę się pojawić na egzaminie.

  Czym jest monada? Najprościej wyjaśnić monadę jako sposób pisania kodu w którym mamy jakiś abstrakcyjny typ `'a monada`, funkcję `return` która zamienia typ `'a` na `'a monada`, która podnosi wartość do kontekstu monady, oraz funkcję `bind` typu `'a monada -> ('a -> 'b monada) -> 'b monada`, która wyciąga wartość z kontekstu monady i aplikuje ją na funkcję.

  #underline[#link("https://pl.wikipedia.org/wiki/Monada_(programowanie)")[Wikipedia]]
]

Rozważmy monadę typu `option`, zdefiniowaną następująco:

```ml
type 'a option =
  | Some of 'a
  | None
```

Napisz funkcje `return` i `bind`.


#grid(
  columns: (auto, 1fr),
  column-gutter: 4pt,
  align: horizon,
  ```ml
  let return v =
  ```,
  box(width: 10em, height: 20pt, stroke: 0.5pt),
)

#grid(
  columns: 1,
  row-gutter: 4pt,

  ```ml
  let bind m f =
  ```,
  box(width: 100%, height: 60pt, stroke: 0.5pt),
)

#pagebreak()



#pagebreak()

= Indukcja strukturalna

== Formułowanie zasady indukcji

Rozważmy następujący typ danych reprezentujący wyrażenia złożone z zer, operacji następnika i dodawań.

```ml
type expr =
  | Zero
  | Succ of expr
  | Add of expr * expr
```

Sformułuj zasadę indukcji dla tego typu danych.



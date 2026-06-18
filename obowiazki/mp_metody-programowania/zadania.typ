#import "@preview/pinit:0.2.2": *
#import "@preview/syntree:0.3.1": syntree

#show link: underline
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

#let card(body) = block(fill: lime.transparentize(90%), inset: 10pt)[
  #body
]


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

#card[
  *Wskazówki do analizy zasięgu zmiennych:*

  - *Symultaniczne wiązanie (`and`):* W konstrukcji `let x = e1 and y = e2 in e3`, wyrażenia `e1` i `e2` są ewaluowane w tym samym, *zewnętrznym* środowisku (nie widzą siebie nawzajem). Zmienne `x` i `y` są widoczne dopiero w ciele `e3`.
  - *Przesłanianie (shadowing):* Najbardziej wewnętrzne wiązanie danej nazwy zawsze wygrywa. Pamiętaj, że nowe wiązania wprowadzają nie tylko konstrukcje `let`, ale też argumenty funkcji (`fun x -> ...`) oraz dopasowania do wzorca (np. `| a :: b -> ...`).
  - *Zasięg a rekurencja:* Jeśli konstrukcja to zwykłe `let` (bez `rec`), nazwa definiowanej funkcji/zmiennej nie jest widoczna w jej własnym ciele. Wszelkie odwołania do niej będą szukać definicji w środowisku zewnętrznym.
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

#card[
  *Wskazówki do typowania w OCamlu*


  + *Brak niejawnego rzutowania typów:* OCaml jest niezwykle rygorystyczny i nigdy nie zamienia automatycznie typu `int` na `float`.
  + *Problem nieskończonego typu (Occurs check):* Zmienna typowa nie może zawierać samej siebie. Jeśli przy rozwiązywaniu równań wyjdzie, że np. funkcja wymaga, aby typ $tau$ był jednocześnie typem $tau -> alpha$ (co zdarza się np. przy aplikowaniu zmiennej do samej siebie, jak w `x x`), oznacza to, że w standardowym OCamlu takie wyrażenie po prostu *nie typuje się*.
  + *Nieużywane argumenty:* Jeśli funkcja przyjmuje argument, ale w ogóle go nie wykorzystuje w swoim ciele, jego typ nie jest niczym ograniczony. Taki argument przyjmuje najbardziej ogólną postać – osobną zmienną typową (np. `'a`, `'b`, itd.).
  + *Wymuszanie struktury przez operatory:* Operatory narzucają konkretne wymagania na swoje argumenty. Operator `!` natychmiast wymusza, by jego argument był referencją (`'a ref`). Z kolei operatory porównania (np. `>`, `=`) wymagają, aby typy po obu ich stronach były *identyczne*. Jeśli z jednej strony znajduje się krotka o konkretnych typach, to wyrażenie z drugiej strony musi odpowiadać tej samej krotce.
  + *Efekty uboczne a typ zwracany:* Pamiętaj o różnicy między funkcjami transformującymi (rodzina `map`, `fold`), a iterującymi (rodzina `iter`). Funkcje zdefiniowane wyłącznie dla wywołania efektów ubocznych (jak wypisywanie na ekran) zwracają na końcu typ pusty, czyli `unit`.
  + Jak zapamiętać `List.fold_left` i `List.fold_right`? Skojarz `left` i `right` z tym, po której stronie stoi akumulator w funkcji transformującej oraz kolejnych argumentach:
    - `List.fold_left:`

      Akumulator stoi po lewej stronie w lambdzie i argumentach po niej

      `('acc -> 'a -> 'acc) -> 'acc -> 'a list -> 'acc`
    - `List.fold_right:`

      Akumulator stoi po prawej stronie w lambdzie i argumentach po niej

      `('a -> 'acc -> 'acc) -> 'a list -> 'acc -> 'acc`
]

#pagebreak()

*Rozwiązania*

#table(
  columns: (20pt, 1fr, 1fr),
  stroke: 0.5pt,
  [Lp], [Wyrażenie], [Typ],

  [1.],
  ```ml
  fun x -> x
  ```,
  [`'a -> 'a`],

  [2.],
  ```ml
  fun x -> x *. 2
  ```,
  [`BŁĄD TYPU` – $2$ nie jest typu `float`],

  [3.],
  ```ml
  fun x y -> !x > (y+2,10)
  ```,
  [`(int * int) ref -> int -> bool`],

  [4.],
  ```ml
  let rec add a b =
    if b = 0 then a
    else add (a + 1) (b-1)
  ```,
  [`int -> int -> int`],

  [5.],
  ```ml
  fun f x -> f (f x)
  ```,
  [`('a -> 'a) -> 'a -> 'a`],

  [6.],
  ```ml
  fun f -> (fun x -> f x x)(fun y -> f y y)
  ```,
  [`BRAK TYPU` – `'a` występuje w `'a -> 'b`],

  [7.],
  ```ml
  fun f x -> f (f x) > x
  ```,
  [`('a -> 'a) -> 'a -> bool`],

  [8.],
  ```ml
  fun a b c f d g e -> f b d c (g a)
  ```,
  [`'a -> 'b -> 'c -> ('b -> 'd -> 'c -> 'g -> 'f) -> 'd -> ('a -> 'g) -> 'e -> 'f`],

  [9.],
  ```ml
  List.fold_right
  ```,
  [`('a -> 'acc -> 'acc) -> 'a list -> 'acc -> 'acc`],

  [10.],
  ```ml
  List.map
  ```,
  [`('a -> 'b) -> 'a list -> 'b list`],

  [11.],
  ```ml
  List.iter2
  ```,
  [`('a -> 'b -> unit) -> 'a list -> 'b list -> unit`],

  [12.],
  ```ml
  fun f x y -> f
  ```,
  [`'a -> 'b -> 'c -> 'a`],
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
      | [] -> [g 0]
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


#card[
  *Wskazówki do rekurencji ogonowej*

  Funkcję nazywamy *rekurencyjnie ogonową*, *ogonową*, *tail call* wtedy, gdy wywołanie rekurencyjne jest zwracane bezpośrednio jako wynik, nie robi nic z wynikiem wywołania rekurencyjnego. To pozwala na sporą optymalizację kompilatora, gdyż nie musi wtedy zapisywać i zwiększać stosu wywołań.

  Funkcję nieogonową zazwyczaj da się przekształcić na ogonową przez dodanie akumulatora który gromadzi aktualny stan wykonania. Należy jednak mieć na uwadze, że akumulator jest wtedy komputowany w odwrotnej kolejności – od pierwszego wywołania do ostatniego, w przeciwieństwie do stosu wywołań i obliczeń na wyniku wywołania funkcji rekurencyjnej.
]

#pagebreak()

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
  [
    ```ml
    let f a =
      let rec aux a acc =
        if a < 0 then acc - 1 (* acc będzie zawsze 0 *)
        else if a = 0 then a + acc
        else aux (a-1) (acc + a)
      in aux a 0
    ```
  ],

  [2.],
  ```ml
  let rec comp f fil a =
    if fil a
      then a
      else comp f fil (f a)
  ```,
  [`TAK`],

  [3.],
  ```ml
  let rec f g xs =
    match xs with
      | [] -> [g 0]
      | x :: xs -> (g x) :: (f g xs)
  ```,
  [
    Ta funkcja nie jest ogonowa. W klasycznym, czysto funkcyjnym ujęciu nie da się jej przekształcić w funkcję ogonową bez ponoszenia dodatkowych kosztów wydajnościowych. `@`, `List.fold_right` same nie są ogonowe (wg. domyślnej implementacji OCaml'a). Najczęstszą metodą stosowaną w takich sytuacjach, jeśli naprawdę potrzebujemy ogonowej funkcji ze względu na olbrzymią długość przekazywanej listy jest tzw. `two-pass`. Najpierw odwracamy listę, a później traktujemy ją w standardowy sposób, tak jak `List.fold_left`. Jest też inny sposób, wykorzystujący #link("https://pl.wikipedia.org/wiki/Kontynuacja_(informatyka)")[kontynuacje], ale to jest daleko poza zakresem tego przedmiotu.
    ```ml
    let f g xs =
      let xs = List.rev xs in
      let rec aux xs acc =
      (
        match xs with
          | [] -> acc
          | x :: xs -> aux xs ((g x) :: acc)
      )
      in aux xs [g 0]
    ```
    #linebreak()
  ],

  [4.],
  ```ml
  let rec app xs ys =
    match xs with
      | [] -> ys
      | x :: xs -> x :: (app xs ys)
  ```,
  [
    Z tych samych względów co wyżej, musimy użyć najpierw `List.rev`
    ```ml
    let app xs ys =
      let xs = List.rev xs in
      let rec aux xs ys =
      (
        match xs with
          | [] -> ys
          | x :: xs -> aux xs ( x :: ys )
      )
      in
      aux xs ys
    ```
  ],

  [5.],
  ```ml
  let rec comp f fil a =
    if fil a
    then a
    else 1 + comp f fil (f a)
  ```,
  [
    ```ml
    let comp f fil a =
      let rec aux a acc =
        if fil a
        then acc + a
        else aux (f a) (1 + acc)
      in aux a 0
    ```
  ],

  [6.],
  ```ml
  let rec f g xs acc =
    match xs with
      | [] -> acc
      | x :: xs -> f g xs (g acc x)
  ```,
  [Tak. To jest `List.fold_left`, tylko z inną kolejnością argumentów.],
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

*Rozwiązania*

#let mo(body) = table.cell(body, fill: lime.transparentize(85%))

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
  mo[```ml
  let rec conss n x xs =
    if n = 0 then xs
    else conss (n-1) x (x :: xs)

  ```],
  [Wstawia $n$ elementów $a$ na początek listy $x s$.],

  [3.],
  table.cell(inset: 4pt, fill: lime.transparentize(85%))[```
  int ->
  (int -> 'a) ->
  (int -> 'a) ->
  'a
  ```],
  [
    ```ml
    fun a b c ->
      if a > 0 then b a
      else c a
    ```
  ],
  mo[$"fun" "a b c" = cases(
    "b a"", jeśli" a > 0,
    "c a"", w.p.p"
  )$],

  [4.],
  table.cell(inset: 4pt)[```
  (ident * expr) list -> ident -> expr
  -> (ident * expr) list
  ```],
  mo[ Zakładamy, że klucz w pierwszej współrzędnej pary może wystąpić tylko raz w liście.

    ```ml
    let update xs k v =
      let rec aux xs k v =
        (
        match xs with
        | [] -> []
        | (k',v') :: xs ->
          if k' = k then (k,v) :: xs
          else (k',v') :: aux xs k v
        )
      in aux xs k v
    ```],
  [Aktualizuje (jeżeli para z pierwszą współrzędną równą `ident` jest już w liście, to ją najpierw usuwa) listę par wprowadzając nową parę `(ident, expr)`.],

  [5.],
  mo[`'a option list -> 'a list`],
  mo[```ml
  let rec unwind xs =
    match xs with
    | [] -> []
    | Some x :: xs -> x :: unwind xs
    | None :: xs -> unwind xs
  ```],
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

// Aby się mieściło na jednej stronie
#place(dy: -14pt)[*Rozwiązania*]

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
  underline[`List.fold_left`],
  [`('acc -> 'a -> 'acc) -> 'acc -> 'a list -> 'acc`],
  [```ml
  let rec fold_left f acc xs =
    match xs with
    | [] -> acc
    | x :: xs -> fold_left f (f acc x) xs
  ```],

  [2.],
  [`List.fold_right`],
  [`('a -> 'acc -> 'acc) -> 'a list -> 'acc -> 'acc`],
  [```ml
  let rec fold_right f xs acc =
    match xs with
    | [] -> acc
    | x :: xs -> f x (fold_right f xs acc)
  ```],

  [3.],
  [`List.map`],
  [`('a -> 'b) -> 'a list -> 'b list`],
  [```ml
  let rec map f xs =
    match xs with
    | [] -> []
    | x :: xs -> (f x) :: map f xs
  ```],

  [4.],
  [`List.filter`],
  [`('a -> bool) -> 'a list -> 'a list`],
  [```ml
  let rec filter f xs =
    match xs with
    | [] -> []
    | x :: xs -> if f x then x :: filter f xs else filter f xs
  ```],
)

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
  [```ml
  let sum xs =
    fold_left (fun acc x -> x + acc) 0 xs
  ```],

  [2.],
  table.cell(inset: 4pt)[Funkcja przyjmująca listę list liczb całkowitych, licząca maksimum sum podlist.],
  [```ml
  let max xss =
    fold_left
      (fun acc xs ->
        let sum = (fold_left
          (fun acc x -> acc + x) 0 xs
        ) in if sum > acc then sum else acc) 0 xss
  ```],

  [3.],
  table.cell(
    inset: 4pt,
  )[Funkcja przyjmująca listę list zwracająca `true` wtw. gdy długości tych podlist są w kolejności rosnącej.
    (np. `[(4);(5);(100)]`, gdzie `(x)` oznacza listę o długości $x$ zwróci `true`, a `[(3);(5);(4)]` zwróci `false`)],
  [```ml
  let incr_lengths xss =
    let lengths =
      map (fun xs ->
        fold_left (fun acc x -> acc + 1) 0 xs) xss in
          ( fold_left (fun acc x ->
            if acc = -2 then -2
            else if x > acc
            then x else -2)
          (-1) lengths ) <> -2
  ```],

  [4.],
  table.cell(
    inset: 4pt,
  )[Funkcja przyjmująca listę par typu `(('a -> 'b) * 'a list)`, zwracająca listę list w których każdy element został zaaplikowany do odpowiedniej funkcji w pierwszej współrzędnej pary. (np. wynikiem `[((fun x -> x * x), 2;3;4)]` będzie `[[4;9;16]]`)],
  [```ml
  let map_map xss =
    map (fun (f, xs) ->
      map f xs
    ) xss
  ```],
)


#pagebreak()

#let te(body) = highlight(fill: red.transparentize(80%))[
  #text(fill: fuchsia)[#body]
]

= Gramatyki

Dla poniżej zapisanych gramatyk określ czy są one jednoznaczne. Jeżeli nie, napisz kontrprzykład w pierwszej ramce.
Tam gdzie wpiszesz kontrprzykład, zapisz zbiór produkcji aby gramatyka była równoważna. *Nie możesz* edytować zbiorów nieterminali, terminali, nieterminalu startowego.

#let boxes(perc: 40%) = [
  #box(width: 100%, height: perc, stroke: 0.5pt + black)
  #box(width: 100%, height: 30%, inset: 10pt, stroke: 0.5pt + black)[
    $P = { \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
      \
    }$
  ]
]


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
    #boxes(perc: 30%)
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
    #boxes()
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S, D}, \
        & T = {1,2,3,+,-}, \
        & P = { \
        & quad D -> 1, D -> 2, D -> 3, \
        & quad S -> D, \
        & quad S -> S + S, \
        & quad S -> S - S \
      }
    $]
    #boxes()
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S, V}, \
        & T = {top, bot, =>, not, "a", "b", ..., "z"}, \
        & P = { \
        & quad V -> bot, V -> top, \
        & quad V -> "a", V -> "b", ..., V -> "z", \
        & quad S -> V, \
        & quad S -> S => S, \
        & quad S -> not S \
      }
    $]
    #boxes()
  ]


#pagebreak()

#card[
  *Wskazówki*

  - Staraj się znaleźć produkcje które generują ten sam nieterminal w izolacji, np dla
    #align(left)[$P = { \
      quad V -> epsilon \
      quad S -> V \
      quad S -> epsilon \
    }$]

    banalnym źródłem niejednoznaczności będzie wyprowadzenie $epsilon$ na dwa sposoby:
    + $S => V => epsilon$,
    + $S => epsilon$

  - Aby zbudować jednoznaczną gramatykę, najpierw uporządkuj produkcje dla tego samego nieterminala po ilości rekurencji.

    Np. dla
    $
        & P = { \
        & quad S -> S => S, \
        & quad S -> not S \
        & quad S -> V \
      }
    $

    oddziel od siebie $S -> S => S$ oraz $S -> not S$.

    Następnie, posortuj te grupy rosnąco (po ilości rekurencyjnych wystąpień):

    $
        & P = { \
        & quad S -> not S \
        & quad S -> S => S, \
        & quad S -> V \
      }
    $

    + Dla każdej grupy musisz rozdzielić jaki nieterminal ją generuje.
      $
          & P = { \
          & quad V -> not S \
          & quad S -> S => S, \
          & quad S -> V \
        }
      $
    + Po zmianie nieterminala-źródła, zmień wszystkie jego wystąpienia w środku produkcji na ten nieterminal na który zmieniłeś.
      $
          & P = { \
          & quad V -> not V \
          & quad S -> S => S, \
          & quad S -> V \
        }
      $
      #colbreak()
    + (niemal) Każda produkcja która odwołuje się do siebie rekurencyjnie więcej niż raz ($n$ razy), jest źródłem niejednoznaczności. W tych miejscach wymień $n-1$ nieterminali na takie o wyższym priorytecie (wyższy priorytet === bliżej terminalów).
      $
          & P = { \
          & quad V -> not V \
          & quad S -> V => S, \
          & quad S -> V \
        }
      $

      _Najbardziej prawidłowo jest to robić według kierunku wiązania jakiegoś operatora, np. implikacja wiąże w prawo – po prawej stronie zostawiam więc rekurencyjne zawołanie do produkcji. Dla operatorów wiążących w lewo, np. dodawanie – zostawia się rekurencyjne wołanie po lewej stronie._

    + Gotowe – ciesz się swoją jednoznacznie zdefiniowaną gramatyką! Jeżeli nadal nie jest jednoznaczna, trzeba pewnie powtórzyć procedurę, lub ją lekko zmodyfikować, w najgorszym przypadku dokładając kolejne stopnie priorytetów pomiędzy terminalami a nieterminalem startowym.

    Pamiętaj, że (poza szczególnymi case'ami takimi jak `( expr )`) zawołania innych produkcji powinny być o priorytecie *wyższym* niż źródłowa.
]

#pagebreak()

*Odpowiedzi*

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
    #box(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
      #grid(
        columns: (1fr, 1fr),
        align: center,
        syntree[
          [S [
          [
          $epsilon$
          ]
          [ S [
          a
          ] ]
          ]]
        ],
        syntree[
          [S [
          a
          ]]
        ],
      )
    ]
    #box(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
      $
        P = { \
              & quad S -> a S, \
              & quad S -> epsilon \
            }
      $
    ]
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
    #box(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
      #grid(
        columns: (1fr, 1fr),
        align: center,
        syntree[
          [S [
          $epsilon$
          ]
          ]
        ],
        syntree[
          [S [
          [S [
          $epsilon$
          ]]
          [S [
          $epsilon$
          ]]
          ]]
        ],
      )
    ]
    #box(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
      $
        P = { \
              & quad S -> (S) S, \
              & quad S -> epsilon \
            }
      $
    ]
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S, D}, \
        & T = {1,2,3,+,-}, \
        & P = { \
        & quad D -> 1, D -> 2, D -> 3, \
        & quad S -> D, \
        & quad S -> S + S, \
        & quad S -> S - S \
      }
    $]
    #box(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
      #grid(
        columns: (1fr, 1fr),
        align: center,
        syntree[
          [S [S [S [D 2]]
          \+
          [ S [D 3] ]]
          \+
          [ S [D [1] ]
          ]
          ]
        ],
        syntree[
          [S [
          S [[S [D 2]]
          \+
          [ S [D [3] ]] ]]
          \+
          [ S [D 1] ]
          ]
        ],
      )
    ]
    #box(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
      $
        P = { \
              & quad D -> 1, D -> 2, D -> 3, \
              & quad S -> D, \
              & quad S -> S + D, \
              & quad S -> S - D \
            }
      $
    ]
  ]

+ #box(width: 100%)[
    #align(left)[$
      G & = (N, T, P, S), quad "gdzie:" \
        & N = {S, V}, \
        & T = {top, bot, =>, not, "a", "b", ..., "z"}, \
        & P = { \
        & quad V -> bot, V -> top, \
        & quad V -> "a", V -> "b", ..., V -> "z", \
        & quad S -> V, \
        & quad S -> S => S, \
        & quad S -> not S \
      }
    $]
    #box(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
      #grid(
        columns: (1fr, 1fr),
        align: center,
        syntree[
          [S
          [S [ V [a] ]]
          $=>$
          [S
          [S [V [b]]]
          $=>$
          [S [V [c]]]
          ]
          ]
        ],
        syntree[
          [S
          [S
          [S [V [a]]]
          $=>$
          [S [V [b]]]
          ]
          $=>$
          [S [V [c]]]

          ]
        ],
      )
    ]
    #box(width: 100%, inset: 10pt, stroke: 0.5pt + black)[
      $
        P = { \
              & quad V -> not V \
              & quad V -> bot, V -> top, \
              & quad V -> "a", V -> "b", ..., V -> "z", \
              & quad S -> V, \
              & quad S -> V => S, \
            }
      $
    ]
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

#card[
  *Informacja*

  Monady w tak bezpośredni sposób jak poniżej nie pojawiły się na wykładzie ani ćwiczeniach, ale takie pytanie ma szansę pojawić się na egzaminie.

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

=== Zadanie A.

Rozważmy następujący typ danych reprezentujący wyrażenia złożone z zer, operacji następnika i dodawań.

```ml
type expr =
  | Zero
  | Succ of expr
  | Add of expr * expr
```

Sformułuj zasadę indukcji dla tego typu danych.

#pagebreak()

*Rozwiązanie*

```ml
type expr =
  | Zero
  | Succ of expr
  | Add of expr * expr
```

Niech $P$ będzie predykatem dotyczącym wartości typu `expr`.
Jeżeli zachodzą następujące warunki:
- $P("Zero")$,
- dla każdego $e$ typu `expr` jeśli $P(e)$ to $P("Succ"(e))$,
- dla każdego $e_1, e_2$ typu `expr` jeśli $P(e_1)$ oraz $P(e_2)$, to $P("Add"(e_1, e_2))$,
to dla każdego $e: #`expr`)$ zachodzi predykat $P(e)$.

#line(length: 100%)

*Skrócony zapis:*

Niech $P : #`expr` -> #`bool`$:
- $P("Zero")$,
- $forall e : #`expr`. P(e) => P("Succ"(e))$,
- $forall e_1,e_2 : #`expr`. P(e_1) and P(e_2) => P("Add"(e_1,e_2))$,
, wtedy $forall e: #`expr`. P(e)$

#pagebreak()

=== Zadanie B.

Definiujemy następujący typ dla drzew:

```ml
type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree
```

Sformułuj zasadę indukcji dla tego typu danych.

#box(width: 100%, height: 100pt, stroke: 0.5pt)

Dla tego typu danych definiujemy dwa warianty funkcji `flatten`, spłaszczającej drzewo do listy w kolejności (wynikiem będzie posortowana lista):

```ml
let rec flatten1 t = match t with
  | Leaf -> []
  | Node(t1, x, t2) -> flatten1 t1 @ x :: flatten1 t2
```

```ml
let flatten2 t =
  let rec flatten2_aux t xs = match t with
    | Node(t1, x, t2) -> flatten2_aux t1 (x :: flatten2_aux t2 xs)
    | Leaf -> xs
  in flatten2_aux t []
```

Udowodnij indukcyjnie, że dla każdego drzewa `t: 'a tree` zachodzi własnosć $"flatten1" t equiv "flatten2" t$.
Aby to zrobić, najpierw sformułuj i udowodnij lemat na temat funkcji `flatten1` i `flatten2_aux`.

#box(width: 100%, height: 280pt, stroke: 0.5pt)
#box(width: 100%, height: 600pt, stroke: 0.5pt)

#pagebreak()

*Rozwiązanie*

*Zasada indukcji*

#box(width: 100%, stroke: 0.5pt, inset: 10pt)[
  Niech $P: #`'a tree -> bool`$, t.ż.:
  - $P("Leaf")$,
  - $forall t_1, t_2: #`'a tree`. P(t_1) and P(t_2) => (forall x: #`'a` P("Node"(t_1, x, t_2))$)
  , wtedy $forall t: #`'a tree`. P(t)$.
]

*Lemat pomocniczy*


#box(width: 100%, stroke: 0.5pt, inset: 10pt)[
  *Lemma*: $forall x s: #`'a list`, t: #`'a tree`. #`flatten1 t @ xs` equiv #`flatten2_aux t xs`$

  *Proof*


  + `Leaf`

    Weźmy dowolny `xs : 'a list`.

    $#`flatten1 Leaf @ xs` attach(equiv, t: #`DEF`) #`[] @ xs` attach(equiv, t: #`APP`) #`xs` attach(equiv, t: #`DEF`) #`flatten2_aux Leaf xs`$

  + `Node(t1, x, t2)`

    Weźmy dowolny `xs : 'a list`.

    Weźmy dowolny $x: #`'a`$.

    $#`flatten1 Node(t1, x, t2) @ xs` attach(equiv, t: #`DEF`)
    #`flatten1 t1 @ x :: flatten1 t2 @ xs` attach(equiv, t: #`ASSOC`)
    #`flatten1 t1 @ x :: (flatten1 t2 @ xs)` attach(equiv, t: #`IND`)
    #`flatten1 t1 @ x :: (flatten2_aux t2 xs)` attach(equiv, t: #`ASSOC`)
    #`flatten1 t1 @ (x :: (flatten2_aux t2 xs))` attach(equiv, t: #`IND`)
    #`flatten2_aux t1 x :: (flatten2_aux t2 xs)` attach(equiv, t: #`ASSOC`)
    #`flatten2_aux t1 (x :: flatten2_aux t2 xs)` attach(equiv, t: #`DEF`)
    #`flatten2_aux Node(t1, x, t2) xs`$

  Z zasady indukcji $#`flatten1 t @ xs` equiv #`flatten2_aux t xs`$ dla każdego `xs: 'a list`, `t: 'a tree`.
]

*Dowód twierdzenia*


```ml
let rec flatten1 t = match t with
  | Leaf -> []
  | Node(t1, x, t2) -> flatten1 t1 @ x :: flatten1 t2
```

```ml
let flatten2 t =
  let rec flatten2_aux t xs = match t with
    | Node(t1, x, t2) -> flatten2_aux t1 (x :: flatten2_aux t2 xs)
    | Leaf -> xs
  in flatten2_aux t []
```

#box(width: 100%, stroke: 0.5pt, inset: 10pt)[
  *Teza*: $forall t: #`'a tree`. #`flatten1 t` equiv #`flatten2 t`$.

  Weźmy dowolne $t: #`'a tree`$.

  $#`flatten1 t` attach(equiv, t: #`DEF`) #`flatten1 t @ []` attach(equiv, t: #`LEM`) #`flatten2_aux t []` attach(equiv, t: #`DEF`) #`flatten2 t`$
]

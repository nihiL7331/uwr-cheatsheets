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

#show raw: set text(font: "CMU Typewriter Text", fallback: false)
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
#let LECTURE-NUM-TO = int(sys.inputs.at("do", default: "2"))
#let from(n, body) = if LECTURE-NUM-TO >= n and n >= LECTURE-NUM-FROM { body }

= Metody Programownia: Reference
*Data:* #datetime.today().display() \
*Zakres:* #LECTURE-NUM-FROM - #LECTURE-NUM-TO

#from(1)[
  == Setup środowiska developerskiego
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


  == Typy danych w OCamlu

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


  == Wiązanie zmiennych

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


  == Funkcje i warunki

  === Funkcje rekurencyjne

  Funkcje mogą być rekurencyjne. Aby skorzystać z identyfikatora funkcji, należy zastąpić ```ml let``` parą słów ```ml let rec```:

  ```ml
  let rec fib x =
    fib (x - 1) + fib (x - 2)
  ```

  Aby funkcja ta uległa kiedyś terminacji, musimy dodać przypadek bazowy funkcji. Użyjemy do tego instrukcji warunkowej `if`. Działa ona jak w każdym innym języku programowania.

  ```ml
  let rec fib x =
    if x = 0 || x = 1 then
      1
    else
      fib (x - 1) + fib (x - 2)
  ```

  Funkcje mogą być wzajemne rekurencyjne. Wtedy należy dwa związania rekurencyjne ```ml let rec``` połączyć w jedno słowem kluczowym ```ml and```:

  ```ml
  let rec fun_a a =
    if a = 0 then 42
    else fun_b (a/2)

  and
  fun_b b =
    if b = 0 then 13
    else fun_a (b/2)
  ```

  === Funkcje z akumulatorem

  Akumulatorem nazywamy argument który jest stanem funkcji przekazywanym w głąb rekurencyjnych wywołań funkcji. Na początku jest inicjalizowany elementem neutralnym danej operacji, np. $1$ dla mnożenia, $0$ dla dodawania.

  ```ml
  let rec factorial x acc =
    if x = 0 then acc
    else factorial (x-1) (x*acc)

  let fac_10 = factorial 10 1
  ```

  Funkcje mogą być rekurencyjne *ogonowo*, tzn. wywołują inną funkcję (lub siebie samą) wyłącznie ze zmodyfikowanymi argumentami, bez wykorzystywania wartości otrzymanej przez wywoływaną funkcję. Funkcje rekurencyjne ogonowo są o wiele bardziej wydajne od tych nie ogonowych, ponieważ OCaml jest w stanie zwolnić stos wywołań funkcji podmieniając obecnie wykonywaną funkcję na tą, do której ciała wskakuje.

  ```ml
  (* Funkcja nie ogonowa *)
  let rec factorial x =
    if x = 0 then 1
    (* tutaj wynik factorial jest jeszcze mnożony przez x *)
    else x * factorial (x-1)
  ```

  Funkcją rekurencyjnie ogonową jest funkcja z akumulatorem przykład wyżej.

  === Pattern Matching

  Pozwala na dopasowywanie wzorców do danego wyrażenia i warunkową ewaluację wyrażeń. Kolejne wzorce wypisujemy po znaku pałki (|). Wzorce te są porównywane do wyrażenia od góry do dołu.

  ```ml
  let is_zero x =
    match x with
    | 0 -> true
    | _ -> false
  ```

  `_` służy jako wildcard, dopasowywuje każdy przypadek który został.

  Czasami kolejność ułożenia wzorców może mieć znaczenie, jeśli któryś jest słabszy niż inny. Szczególnie funkcja poniżej zawsze będzie zwracać `false`, ponieważ do `_` matchuje się każde wyrażenie.

  ```ml
  let is_zero x =
    match x with
    | _ -> false
    | 0 -> true
  ```

  Matching można rozumieć jako taki `switch` z `C`, lub `match` z `Pythona`, albo też jako bardzo rozbudowany `if`.

  Matching poza kontrolą warunkową programu pozwala nam dekonstruować struktury danych.

  ```ml
  let hd xs =
    match xs with
    | x :: xs -> x
  ```

  OCaml poinformuje nas, że `match` w powyższym kodzie nie jest wyczerpujący. Tak faktycznie jest, ponieważ typem `::` jest `'a -> 'a list -> 'a list`, więc wymaga on `'a`. Jeśli lista jest pusta (`[]`), to OCaml nie znajdzie żadnego elementu który mógłby scons-ować, by otrzymać listę pustą, zatem musimy ten przypadek również rozpatrzeć:

  ```ml
  let hd xs =
    match xs with
    | x :: xs -> x
    | [] -> failwith "wywołano hd na pustej liście"
  ```

  `failwith` wyrzuca wyjątek, korzystamy z niego szczególnie jeśli jakiś przypadek jest nieosiągalny, lub nie jesteśmy w stanie spełnić oczekiwań użytkownika, tak jak u góry biorąc głowę z pustej listy. Wkrótce poznamy typ `'a option` i drugi przypadek będzie obsłużony w inny sposób.

  Nic nie stoi na przeszkodzie, aby matchować na bardziej złożonych wyrażeniach. Np. jeśli dany element jest równy jakiemuś wyrażeniu.

  Poniższa funkcja sprawdza, czy przekazana lista składa się wyłącznie z powtarzającej sekwencji `1;2;3`.

  ```ml
  let rec is_123 xs =
    match xs with
    | 1 :: 2 :: 3 :: rest -> is_123 rest
    | [] -> true
    | _ -> false
  ```
]

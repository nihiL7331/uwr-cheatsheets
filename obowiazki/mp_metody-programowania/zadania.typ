#align(center + horizon)[
  #text(size: 18pt)[*Metody Programowania*]

  _Przykładowe zadanie egzaminacyjne_

  #v(40pt)

  Data aktualizacji: #datetime.today().display()
]

#set page(
  header: box(inset: 10pt, stroke: (bottom: 0.5pt + black), width: 100%)[
    #columns(2)[
      #text(size: 8pt)[*Metody Programowania* \ Przykładowe zadania egzaminacyjne]
      #colbreak()
      #align(end)[#text(size: 8pt)[*Data kompilacji:* #datetime.today().display()]]
    ]
  ],
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



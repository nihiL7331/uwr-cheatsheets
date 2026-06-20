#set page(
  paper: "us-letter",
  margin: 0.25in,
  footer: align(right)[
    #text(fill: luma(65%), size: 8pt)[
      `Michał Kosior | gh: @crqch`
    ]
  ],
  numbering: "1",
)


#show raw: set text(font: "CMU Typewriter Text", fallback: false)

#set heading(numbering: "I.1")

#show: rest => columns(2, rest)

#show heading: it => {
  let size = 0.8em

  if it.numbering == none {
    return text(size: size + 0.2em, weight: "bold")[#it.body]
  }

  let heading_number = counter(heading).display()

  if (it.depth == 1) {
    block(
      inset: (x: 12pt, y: 10pt),
      width: 100%,
      radius: 2pt,
      fill: blue.transparentize(80%),
    )[
      #text(size: size, font: "CMU Classical Serif")[
        #it.body
      ]
    ]
  } else {
    block(
      inset: (x: 12pt, y: 4pt),
      width: 100%,
      radius: 2pt,
      fill: blue.transparentize(90%),
    )[
      #text(size: size, font: "CMU Classical Serif")[
        #it.body
      ]
    ]
  }
}

#let LECTURE-NUM-FROM = int(sys.inputs.at("od", default: "1"))
#let LECTURE-NUM-TO = int(sys.inputs.at("do", default: "15"))
#let from(n, body) = if LECTURE-NUM-TO >= n and n >= LECTURE-NUM-FROM { body }

= Algebra: Reference

*Data:* #datetime.today().display() \

#from(1)[
  = Przestrzenie liniowe

  Zbiór $VV$ jest _przestrzenią liniową_ nad ciałem $FF$, jesli:
  - określone jest dodawanie:
    - przemienne ($forall_( arrow(a),arrow(b) in VV ). arrow(a) + arrow(b) = arrow(b) + arrow(a)$)

    - łączne ($forall_(arrow(a),arrow(b),arrow(b) in VV). (arrow(a) + arrow(b)) + arrow(c) = arrow(a) + (arrow(b) + arrow(c))$)
  - istnieje wektor zerowy $arrow(0)$
  - dla każdego elementu $arrow(v) in VV$ istnieje element przeciwny $-arrow(v)$:
    $
      (-arrow(v)) + arrow(v) = arrow(0)
    $
  - zdefiniowane jest lewostronne mnożenie elementów $VV$ przez skalary z $FF$:
    - rozdzielność mnożenia względem dodawania:
      $
        forall_(alpha,beta in FF) forall_(arrow(v) in VV). (alpha + beta) dot arrow(v) = alpha arrow(v) + beta arrow(v)
      $
    - rozdzielność dodawania względem mnożenia:
      $
        forall_(arrow(u), arrow(v) in VV) forall_(alpha in FF). alpha dot (arrow(u) + arrow(v)) = alpha dot arrow(u) + beta dot arrow(v)
      $
    - mnożenie jest łączne:
      $
        alpha dot (beta dot arrow(v)) = (alpha beta) dot arrow(v)
      $
    - mnożenie przez "jedynkę" z ciała zachowuje wektor:
      $
        1 dot arrow(v) = arrow(v)
      $

  == Podprzestrzeń liniowa

  Dla przestrzeni liniowej $VV$ jej podzbiór $WW subset.eq VV$ jest _podprzestrzenią liniową_, gdy jest niepusty i jest przestrzenią liniową.

  Lemat: Podzbiór $WW subset.eq VV$ jest przestrzenią liniową wtedy i tylko wtedy gdy jest niepusty i zamknięty na działanie dodawania wektorów i mnożenia przez skalary.

  = Kombinacja liniowa

  Dla wektorów $arrow(v_1), arrow(v_2), ..., arrow(v_k)$ ich _kombinacja liniowa_ to dowolny wektor postaci
  $
    sum_(i=1)^k alpha_i arrow(v_i)
  $

  #block[
    == Otoczka liniowa

    Dla zbioru $U subset.eq VV$, gdzie $VV$ – przestrzeń liniowa nad $FF$
    $
      "LIN"(U) = { sum_(i=1)^k alpha_i arrow(v_i) | k in NN, alpha_1, ..., alpha_k in FF, arrow(v_1), ..., arrow(v_k) in U }
    $
  ]

  = Liniowa niezależność wektorów

  Układ wektorów $U$ jest _liniowo niezależny_, gdy dla dowolnego $k >= 1$, dowolnych różnych $arrow(v_1), arrow(v_2), ..., arrow(v_k) in U$ oraz ciągu współczynników $alpha_1, alpha_2, ..., alpha_k in FF$
  $
    sum_(i=1)^k alpha_i dot arrow(v_i) = arrow(0)
  $

  implikuje
  $
    alpha_1 = alpha_2 = ... alpha_k = 0
  $
]

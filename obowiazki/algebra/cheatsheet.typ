#let scheme = sys.inputs.at("scheme", default: "light")
#set math.mat(delim: "[")

#let bg-color = if scheme == "dark" { rgb("1e1e1e") } else { white }
#let fg-color = if scheme == "dark" { rgb("e0e0e0") } else { black }
#let footer-color = if scheme == "dark" { rgb("808080") } else { luma(65%) }

#let heading-bg-1 = if scheme == "dark" { rgb("1c2d5a") } else { blue.transparentize(80%) }
#let heading-bg-2 = if scheme == "dark" { rgb("162447") } else { blue.transparentize(90%) }
#let heading-text-color = if scheme == "dark" { rgb("e0ebff") } else { black }

#set page(
  paper: "us-letter",
  margin: 0.25in,
  fill: bg-color,
  footer: align(right)[
    #text(fill: footer-color, size: 8pt)[
      `Michał Kosior | gh: @crqch`
    ]
  ],
  numbering: "1",
)

#set text(fill: fg-color)


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
      fill: heading-bg-1,
    )[
      #text(size: size, font: "CMU Classical Serif", fill: heading-text-color)[
        #it.body
      ]
    ]
  } else {
    block(
      inset: (x: 12pt, y: 4pt),
      width: 100%,
      radius: 2pt,
      fill: heading-bg-2,
    )[
      #text(size: size, font: "CMU Classical Serif", fill: heading-text-color)[
        #it.body
      ]
    ]
  }
}

#let LECTURE-NUM-FROM = int(sys.inputs.at("od", default: "1"))
#let LECTURE-NUM-TO = int(sys.inputs.at("do", default: "15"))
#let from(n, body) = if LECTURE-NUM-TO >= n and n >= LECTURE-NUM-FROM { body }

= Algebra: spakowany materiał z wykładu

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

  Dla przestrzeni liniowej $VV$ jej podzbiór $WW subset.eq VV$ jest _podprzestrzenią liniową_, gdy jest niepusty i jest przestrzenią liniową. Oznaczamy to $WW <= VV$.

  Lemat: Podzbiór $WW subset.eq VV$ jest przestrzenią liniową wtedy i tylko wtedy gdy jest niepusty i zamknięty na działanie dodawania wektorów i mnożenia przez skalary.

  == Operacje na przestrzeniach liniowych

  - Dla $WW, WW' <= VV$ definiujemy ich _sumę_ jako
    $
      WW + WW' = { arrow(w) + arrow(w') : arrow(w) in WW, arrow(w') in WW' }
    $

  - Dla dowolnego zbioru podprzestrzeni liniowych ${WW_i}_(i in I)$, gdzie $WW_i <= V$ dla każdego $i in I$, przecięcie jest zdefiniowane naturalnie jako $inter_(i in I) WW_i$.

  - Dla dowolnego zbioru przestrzeni liniowych ${VV_i}_(i in I)$, nad tym samym ciałem produkt kartezjański $product_(i in I) VV_i$ zdefiniowany jest naturalnie. Działania zdefiniowane są po współrzędnych.

  - Suma, przecięcie oraz iloczyn kartezjański przestrzeni liniowych jest przestrzenią liniową.
  - Suma przestrzeni liniowych $WW + WW'$ jest najmniejszą przestrzenią liniową zawierającą jednocze�ie $WW$ i $WW'$.
  - Przekrój przestrzeni liniowych $inter_i WW_i$ jest największą przestrzenią liniową zawartą jednocze�ie we wszystkich podprzestrzeniach $WW_i$.

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

#from(2)[
  = Metoda eliminacji Gaussa

  Układ wektorów $[arrow(v_1), arrow(v_2), ..., arrow(v_k)]$ jesteśmy w stanie zapisać w postaci macierzy:
  $
    mat(
      arrow(v_1);
      arrow(v_2);
      ...;
      arrow(v_k)
    )
  $

  Na rzędach $arrow(v_1), arrow(v_2), ..., arrow(v_k)$ możemy wykonywać operację dodawania: $arrow(v_k) := arrow(v_k) + alpha arrow(v_i)$ dla $i != k$ i $alpha in FF$, co zapisujemy jako $(k) + alpha (i)$. W szczególności, $alpha < 0$, wtedy mamy odejmowanie. Możemy również zamieniać wektory ze sobą: $(i)"/"(k)$

  Wykonując te operacje na układzie wektorów nie zmienia się zależność wektorów. W ten sposób sprawdzamy, czy układ jest *liniowo niezależny*.

  Układ jest liniowo niezależny, jeżeli jest w postaci schodkowej:

  $
    mat(
      v_11, v_12, v_13, v_14, ..., v_( 1k );
      0, v_22, v_23, v_24, ..., v_( 2k );
      0, 0, v_33, v_34, ..., v_( 3k );
      0, 0, 0, v_44, ..., v_( 4k );
      0, 0, 0, v_54, ..., v_( 5k );
      dots.v, dots.v, dots.v, dots.v, dots.down, dots.v;
      0, 0, 0, 0, underbrace(..., "same zera"), v_( i k );
    )
  $

  Jeżeli jesteśmy w stanie narysować "schodki" wokół niezerowych elementów idąc tylko w prawo i w dół, oraz nie ma żadnego wektora zerowego $arrow(0)$ (cały rząd wypełniony zerami), to układ jest w postaci schodkowej, więc jest liniowo niezależny.


  = Baza przestrzeni liniowej

  $B$ jest bazą przestrzeni liniowej $VV$, gdy $"LIN"(B) = VV$ oraz $B$ jest liniowo niezależny.

  - Eliminacja Gaussa zastosowana do układu wektorów $U$ zwraca bazę $"LIN"(U)$

  - Wyrażanie wektora w bazie

    Jeśli $B = {arrow(v_1), arrow(v_2), ..., arrow(v_n)}$ jest bazą przestrzeni $VV$ i $arrow(v) in VV$, jest wektorem, to wyrażeniem wektora $arrow(v)$ w bazie $B$ nazywamy reprezentację $arrow(v)$ jako
    $
      arrow(v) = sum_(i=1)^n alpha_i arrow(v_i)
    $
  - Każdy wektor ma jednoznaczne przedstawienie w bazie.
  - Jeśli $B = {arrow(v_1), arrow(v_2), ..., arrow(v_n)}$ jest bazą przestrzeni liniowej $VV$ oraz $arrow(v) in VV$, to
    $
      (arrow(v))_B = (alpha_1, alpha_2, ..., alpha_n)
    $
    gdzie $arrow(v) = sum_(i=1)^n alpha_i arrow(v_i)$
  - Izomorfizm przestrzeni liniowych

    Dwie przestrzenie liniowe $VV, WW$ są izomorficzne nad ciałem $FF$, jeśli istnieją dwie bijekcje: $phi: VV -> WW, psi: WW -> VV$ które zachowują działania, tj. $phi(arrow(v) attach(+, b: VV) arrow(v')) = phi(arrow(v)) attach(+, b: WW) phi(arrow(v'))$ oraz $phi(alpha attach(dot, b: VV) arrow(v)) = alpha attach(dot, b: VV) phi(arrow(v))$ i analogicznie dla $psi$.

  - Każda przestrzeń (skończenie wymiarowa) ma bazę.
  - Każda baza danej przestrzeni (skończenie wymiarowej) ma taką samą moc.

  == Lemat Steinitza

  - $VV$ - przestrzeń liniowa,
  - $A subset.eq VV$ - układ liniowo niezależny,
  - $B$ - układ rozpinający $VV$ ($"LIN"(B) = VV$)

  Albo $A$ jest bazą, albo istnieje $arrow(v) in B$ taki, że $A union { arrow(v) }$ jest liniowo niezależny.

  - Jeśli $VV$ jest _przestrzenią skończenie wymiarową_ to:

    - Dowolny układ niezależny $A subset.eq VV$ można rozszerzyć do bazy.
    - Z każdego układu wektorów $A subset.eq VV$ można wybrać bazę przestrzeni $"LIN"(A)$


  = Wymiar przestrzeni liniowej

  Dla przestrzeni liniowej $VV$, _wymiar_ $VV$ to moc jej bazy. Oznaczamy to jako $dim(VV)$.

]

#let scheme = sys.inputs.at("scheme", default: "light")
#set math.mat(delim: "[")

#let bg-color = if scheme == "dark" { rgb("1e1e1e") } else { white }
#let fg-color = if scheme == "dark" { rgb("e0e0e0") } else { black }
#let footer-color = if scheme == "dark" { rgb("808080") } else { luma(65%) }

#let heading-bg-1 = if scheme == "dark" { rgb("1c2d5a") } else { blue.transparentize(80%) }
#let heading-bg-2 = if scheme == "dark" { rgb("162447") } else { blue.transparentize(90%) }
#let heading-text-color = if scheme == "dark" { rgb("e0ebff") } else { black }
#set line(stroke: 1pt + footer-color, length: 100%)

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
  #line()
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
  - Suma przestrzeni liniowych $WW + WW'$ jest najmniejszą przestrzenią liniową zawierającą jednocześnie $WW$ i $WW'$.
  - Przekrój przestrzeni liniowych $inter_i WW_i$ jest największą przestrzenią liniową zawartą jednocześnie we wszystkich podprzestrzeniach $WW_i$.

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

  #line()

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

#from(3)[

  - Dla przestrzeni _skończenie wymiarowych_ $VV_1, VV_2 <= VV$

    $
      dim(VV_1 + VV_2) = dim(VV_1) + dim(VV_2) - dim(VV_1 inter VV_2)
    $

  - Jeśli $B_1, B_2$ są bazami dla $VV_1, VV_2 <= VV$ to
    $
      VV_1 + VV_2 = "LIN"(B_1 union B_2)
    $

  #line()

  = Przekształcenia liniowe (homomorfizmy)

  Niech $VV, WW$ będą przestrzeniami liniowymi nad tym samym ciałem $FF$. Funkcja $F: VV -> WW$ jest _przekształceniem liniowym_, jeśli spełnia następujące warunki:

  - $forall_(arrow(v) in VV)forall_(alpha in FF). F(alpha arrow(v)) = alpha F(arrow(v))$
  - $forall_(arrow(v), arrow(w) in VV). F(arrow(v) + arrow(w)) = F(arrow(v)) + F(arrow(w))$


  Zbiór przekształceń liniowych jest przestrzenią liniową.
  Złożenie przekształceń liniowych jest przekształceniem liniowym.

  == Jądro i obraz przekształcenia liniowego

  Jądro przekształcenia to zbiór wektorów przekształconych na $arrow(0)$:
  $
    ker(F) = {arrow(v) : F(arrow(v)) = arrow(0)}
  $

  Obraz przekształcenia to zbiór wektrorów, które są wartościami $F$:
  $
    "Im"(F) = { arrow(u): exists arrow(v). F(arrow(v)) = arrow(u)}
  $

  - Jądro i obraz są przestrzeniami liniowymi.

  #colbreak()

  #block(breakable: false)[
    Niech $F: VV -> WW$ będzie przekształceniem liniowym, gdzie $VV, WW$: skończenie wymiarowe przestrzenie liniowe. Wtedy
    $
      dim(VV) = dim("Im"(F)) + dim(ker(F))
    $
  ]

  Rząd przekształcenia liniowego $F$ to $"rk"(F) = dim("Im"(F))$
]

#line()

#from(4)[
  = Macierze

  Macierzą $M$ rozmiaru $m times n$ nad ciałem $FF$ nazywamy funkcję $M : {1,2,...,m} times {1,2,...,n} -> FF$.

  $
    A = mat(
      a_(11), a_(12), ..., a_(1n);
      a_(21), a_(22), ..., a_(2n);
      a_(31), a_(32), ..., a_(3n);
      dots.v, dots.v, dots.down, dots.v;
      a_(m 1), a_(m 2), ..., a_(m n);
    ) = (a_(i j))_(i=1,...m \
    j=1,...n)
  $

  Indeksowanie na macierzach:
  - od 1
  - odwrotnie niż w układzie współrzędnych

  #text(size: 18pt)[
    $
      (a_(underbrace(i, "kolumna") quad underbrace(j, "rząd")))
    $
  ]

  == Operacje na macierzach

  Dodawanie jest zdefiniowane po współrzędnych. $A + B$ jest określone wtedy i tylko wtedy, gdy $A$ i $B$ są tego samego rozmiaru i wtedy

  $
    (A + B)_(i j) = (A)_(i j) + (B)_(i j)
  $

  Mnożenie przez skalar jest również określone po współrzędnych, tzn. dla macierzy $A = (a_(i j))$ nad ciałem $FF$
  $
    (alpha A)_(i j) = alpha a_(i j)
  $

  == Ważne macierze

  + Macierz zerowa, w której wszystkie elementy są zerami. Zapisujemy ją jako $bold(0)$
  + Macierz $bold(1)_(i j)$, w której $a_(i j) = 1$ i wszystkie inne elementy są zerowe
  + Macierz kwadratowa – rozmiaru $n times n$
  + Macierz przekątniowa – macierz która ma same zera poza przekątną
  + Macierz identycznościowa/jednostkowa – macierz przekątniowa, która ma same jedynki na przekątnej. Zapisujemy ją jako $"Id"_n$
    $
      "Id"_n = overbrace(
        mat(
          1, 0, ..., 0;
          0, 1, ..., 0;
          dots.v, dots.v, dots.down, dots.v;
          0, 0, ..., 1;
        ), n
      )
    $
  + Macierz górnotrójkątna – macierz kwadratowa w której wszystkie elementy $(a_(i j))_(i > j)$ są zerowe
    $
      mat(
        a_(1 1), a_(1 2), ..., a_(1 n);
        0, a_(2 2), ..., a_(2 n);
        0, 0, ..., a_(3 n);
        dots.v, dots.v, dots.down, dots.v;
        0, 0, ..., a_(n n)
      )
    $
  + Macierz dolnotrójkątna – macierz kwadratowa w której wszystkie elementy $(a_(i j))_(i < j)$ są zerowe
    $
      mat(
        a_(1 1), 0, ..., 0;
        a_(2 1), a_(2 2), ..., 0;
        a_(3 1), a_(3 2), ..., 0;
        dots.v, dots.v, dots.down, dots.v;
        a_(n 1), a_(n 2), ..., a_(n n)
      )
    $
  + Macierz trójkątna – macierz górno lub dolnotrójkątna

  == Mnożenie macierzy

  Dla macierzy $A$ rozmiaru $n x m$ i $B$ rozmiaru $m x l$ definiujemy mnożenie następująco
  $
    (A B)_(i j) = sum_(k=1)^m A_(i k) B_(k j)
  $

  - Mnożenie macierzy jest łączne

]


#line()

= Izometrie

Przekształcenie liniowe $F: VV -> VV$ na przestrzeni liniowej $VV$ z iloczynem skalarnym $chevron.l dot, dot chevron.r$ nazywamy _izometrią_, jeśli zachowuje iloczyn skalarny, tj. dla każdych dwóch wektorów $arrow(u), arrow(v) in VV$ zachodzi:
$
  chevron.l F arrow(v), F arrow(u) chevron.r = chevron.l arrow(v), arrow(u) chevron.r
$

- Przekształcenie $F$ jest izometrią wtedy i tylko wtedy, gdy zachowuje długość, tj. dla każdego $arrow(v) in VV$ mamy $||F(arrow(v))|| = ||arrow(v)||$

- Przekształcenie $F$ jest izometrią wtedy i tylko wtedy, gdy zachowuje iloczyn skalarny elementów z bazy.

== Macierze ortogonalne

Macierz kwadratową nazywamy _ortogonalną_, jeśli jej kolumny są parami ortogonalne oraz są długości $1$ (w standardowym iloczynie skalarnym).

$M$ jest ortogonalna wtedy i tylko wtedy, gdy $M^(-1) = M^T$

- Macierze ortogonalne są zamknięte na mnożenie, transponowanie i na branie macierzy odwrotnej.

#line()

= Grupy

Zbiór $(G, dot)$, gdzie $dot: G times G -> G$ jest grupą, jeśli:
- *łączność*  działanie $dot$ jest łączne ($a dot (b dot c) = (a dot b) dot c$),
- *element neutralny*  istnieje element neutralny $e$, taki że dla każdego $g in G$ mamy $e g = g e = g$,
- *element odwrotny*  dla każdego elementu $g in G$ istnieje element $g^(-1)$ tż. $g g^(-1) = g^(-1) g = e$

Jeżeli działanie $dot$ jest przemienne, to mówimy że grupa jest _abelowa_ (przemienna).

== Obserwacje

- Element odwrotny w grupe $G$ jest jedyny.
- Element prawostronnie odwrotny jest też lewostronnie odwrotny.
- Identyczność jest jedyna.
- Równość $a x = b$ oraz $x a = b$ mają dokładnie jedno rozwiązanie.

== Półgrupa (monoid)

"Grupa" w której nie zakładamy istnienia elementu odwrotnego.

== Homomorfizm, izomorfizm

Operację $phi: G -> H$ nazywamy _homomorfizmem grup_, jeśli zachowuje działanie grupowe, tj. $phi(a b) = phi(a) phi(b)$.

$phi$ jest izomorfizmem, jeśli istnieje $phi^(-1)$ które jest przekształceniem odwrotnym i homomorfizmem ($phi, phi^(-1)$ sa bijekcjami).

- Homomorfizm przeprowadza element neutralny (odwrotny) w element neutralny (odwrotny).

== Rząd elementu

Potęgą elementu $a$ nazywamy dowolny element postaci $a^n$, gdzie $n in ZZ$. Dla $n = 0$ oznacza on $e$, dla $n > 1$: $a^n = underbrace(a dot a dot dot dot a, n "razy")$, dla $n < 0$: $a^n = (a^(-1))^(-n)$.

Rząd elementu to najmniejsza dodatnia potęga $n$ taka, że $a^n = e$. Rząd elementu jest _nieskończony_ (nieokreślony), jeśli nie ma takiego skończonego $n$.

Rząd grupy to ilość jej elementów.

- Rząd $a$ i $a^(-1)$ jest taki sam.

== Podgrupy

$H$ jest podgrupą $G$, co zapisujemy $H <= G$, jeśli $H subset.eq G$ oraz $H$ jest grupą.

=== Generowanie

Dla grupy $G$ oraz zbioru $A subset.eq G$ podgrupa generowana przez $A$, oznaczana jako $<A>$, to najmniejsza podgrupa $G$ zawierająca $A$. W takim wypadku mówimy, że $A$ to _zbiór generatorów_ tej podgrupy.

=== Postać zredukowana

Niech $a_1,...,a_k in G$. O iloczynie $a_1^(l_1)a_2^(l_2)dot dot dot a_k^(l_k)$ mówimy, że jest w _postaci zredukowanej_, jeśli $a_i in.not {a_(i+1)^(-1), a_(i+1)}$ dla każdego możliwego $i$ oraz $l_i != 0$ dla każdego $i$.

== Grupa cykliczna

Grupa $G$ jest _grupą cykliczną_, gdy $G = <{a}>$ dla pewnego $a in G$, tzn. jest generowana przez jeden element.

- Każda grupa cykliczna jest przemienna.
- Podgrupa grupy cyklicznej jest cykliczna.

== Grupa wolna

Niech $Gamma^(-1) = {a^(-1) : a in Gamma}$ będzie rozłączne z $Gamma$.

Grupa $G$ o zbiorze generatorów $Gamma$ jest _wolna_ (wolnie generowana przez $Gamma$) jeśli dla dowolnego słowa $w in (Gamma union Gamma^(-1))*$ w postaci zredukowanej zachodzi
$
  w attach(=, b: G) e => w = epsilon
$

= Grupy permutacji

Grupa permutacji $S_n$ to zbiór wszystkich bijekcji ze zbioru ${1,2,...,n}$ w siebie; operacją jest składanie funkcji, tj.
$
  (sigma' dot sigma)(i) = sigma' (sigma (i))
$

Permutację zapisujemy jako dwuwierszową tabelkę:

#[

  #set math.mat(delim: "(")

  $
    mat(
      1, 2, 3, ..., n;
      sigma(1), sigma(2), sigma(3), ..., sigma(n);
    )
  $

]

== Cykle

Cykl $sigma$ to taka permutacja, że istnieją elementy $a_1,...,a_n$, że $sigma(a_i) = sigma(a_(i+1))$ (gdzie $sigma(a_n) = a_1)$, a na innych elementach jest identycznością. Cykl taki zapisujemy, jako $(a_1, a_2, ..., a_n)$.

Elementy ${a_1,...,a)n}$ to _dziedzina cyklu_ lub _nośnik cyklu_.

- _Długość cyklu_ ${a_1, a_2, ..., a_n}$ to $n$.

- Cykle są rozłączne, gdy ich nośniki nie mają wspólnego elementu.


Rząd cyklu długości $n$ wynosi $n$.

Dla cyklów rozłącznych $c_1,c_2,...,c_k$ rząd permutacji $c_1 dot c_2 dot dot dot c_k$ to nww rzędów poszczególnych cykli $c_1,c_2,...,c_k$.

== Parzystość permutacji

Cykl jest *parzysty* kiedy jego długość jest *nieparzysta*.

Cykl nieparzysty jest permutacją nieparzystą.

Parzystość permutacji to parzystość ilości cykli nieparzystych w rozkładzie na cykle rozłączne.

Na przykład:

$
  sigma = overbrace(underbrace((1,4,6), "długość nieparzysta
  cykl parzysty")underbrace((2,3), "długość parzysta
  cykl nieparzysty"), "permutacja nieparzysta
  1 cykl nieparzysty")
$


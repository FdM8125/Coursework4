#import "@preview/cetz:0.5.0"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/theofig:0.2.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/chronos:0.3.0"

#set text(lang: "ru", font: "Times New Roman", 14pt)
//#set math.equation(numbering: "(1)")
#set ref(supplement: none)


#let make_tittle_page(
  ministry: "МИНОБРНАУКИ РОССИИ\n",
  mbou: "Федеральное государственное бюджетное образовательное\n учреждение высшего образования\n",
  university: "«Ярославский государственный университет им. П.Г.Демидова»\n",
  department: "Кафедра компьютерной безопасности и\n  математических методов обработки информации\n",
  course_work: strong[Курсовая работа] + "\n",
  theme: strong[Методы комбинаторной теории групп в современной криптографии] + "\n",
  city: "Ярославль 2026\n",
) = {
  set align(center)
  set page(paper: "a4", margin: (top: 20mm, bottom: 20mm, right: 20mm, left: 30mm))
  set par(leading: 1.5mm, first-line-indent: 1.25cm)
  ministry
  linebreak()
  mbou
  linebreak()
  university
  linebreak()
  department
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  course_work
  linebreak()
  theme
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  align(right)[
    Научный руководитель \
    профессор, д.-р. физ.-мат. наук \
    \_\_\_\_\_\_\_\_\_\_\_ В. Г. Дурнев \
    «\_\_\_» \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ 2026 г. \
    \
    Студент группы КБ-41СО \
    \_\_\_\_\_\_\_\_\_Т. А. Хаирнуров \
    «\_\_\_» \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ 2026 г. \
  ]
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  linebreak()
  city
}

#let make_table_of_contents() = {
  {
    set align(center)
    set text(14pt, weight: "bold")
    [Содержание]
  }
  set align(left)
  outline(
    title: [],
    indent: auto,
  )
  pagebreak()
}

#let faktor(a, b) = {
  box(inset: (bottom: 2pt))[#a]
  box(inset: (bottom: 0pt))[$slash.big$]
  box(inset: (bottom: -3pt))[#b]
}

#make_tittle_page()

#set page(numbering: "1")
#set par(justify: true)

#make_table_of_contents()

= Введение
\
В начале 2000-х годов активно начала развиваться некоммутативная криптография. Её основная идея --- перенести криптографические конструкции в некоммутативные группы, где вместо проблемы дискретного логарифмирования центральное место занимают проблема поиска сопряжённого элемента (Conjugacy Search Problem, CSP) и проблема разложения (Decomposition Search Problem). Эти задачи, как правило, не имеют эффективных решений в общем случае и поэтому представляют интерес с криптографической точки зрения.

Одним из первых протоколов некоммутативного обмена ключами стал протокол Стикеля. Он представляет собой прямую аналогию классического протокола Диффи-Хеллмана, адаптированную к некоммутативным структурам. Несмотря на то, что оригинальная реализация протокола на матричных группах подвергалась линейно-алгебраическим атакам, он остается ценным исследовательским инструментом, который позволяет наглядно продемонстрировать:
- переход от абелевых к некоммутативным структурам;
- влияние выбора платформы на безопасность;

В настоящей курсовой работе будет реализована версия протокола Стикеля на полугруппе матриц над кольцом циклических многочленов $faktor(ZZ_(n)[x], (x^(N + 1) - 1))$.

#pagebreak()

#set heading(numbering: "1.")

= Предварительные сведения
\
#definition()[
  Множество $S$ с бинарной операцией $ast$ называется _полугруппой_, если:
  - $(forall a, b, c in S): (a ast b) ast c = a ast (b ast c)$
]

#definition()[
  Множество $G$ с бинарной операцией $dot$ называется _группой_, если:
  + $(forall a,b,c in G): (a dot b) dot c = a dot (b dot c)$
  + $(exists e in G)(forall a in G): a dot e = e dot a = a$
  + $(forall a in G)(exists a^(-1) in G): a dot a^(-1) = a^(-1) dot a = e$
]

Если групповая операция коммутативна, то есть $(forall a, b in G)(a dot b = b dot a)$, то группа называется _коммутативной_ или _абелевой_. Кроме того, если $abs(G) lt infinity$, то группа $G$ называется _конечной_.

#example()[
  Кольцо целых чисел $ZZ$ с операцией сложения является абелевой группой.
]

#example()[
  Множество $"GL"_(n)(F)$ невырожденных квадратных матриц размера $n times n$ над полем $F$ с операцией обычного матричного умножения является группой.
]

#definition()[
  Подмножество $H$ группы $G$ называется _подгруппой_ группы $G$ (обозначается $H lt.eq G$), если:
  + $(forall a,b in H): a dot b in H$
  + $e in H$
  + $(forall a in H): a^(-1) in H$
]

#example()[
  $ZZ subset RR$ является подгруппой относительно сложения.
]

#definition()[
  Если $N lt.eq G$ и
  $
    (forall g in G)(forall n in N): g dot n dot g^(-1) in N,
  $
  то $N$ называется _нормальной подгруппой_ группы $G$ (обозначается $N lt.tri.eq G$).
]

#definition()[
  _Порядком элемента_ $g$ группы $G$ называется наименьшее $n in NN$ со свойством $g^n = e$, если такие $n$ существуют, и бесконечность --- в противном случае. Порядок $g$ обозначается $"ord"(g)$
]

#definition()[
  Множество $Z(x) = { g in G: g x = x g }$ называется _централизатором_ элемента $x$.
]

#statement()[
  Централизатор $Z(x)$ элемента $x in G$ является подгруппой.
]
$triangle.stroked.r$
+ Пусть $a, b in Z(x): (a dot b) dot x = a dot b dot x = a dot x dot b = x dot (a dot b)$.
+ $e dot x = x dot e$.
+ Пусть $a in Z(x):$
$
  a^(-1) dot x = a^(-1) dot x dot a dot a^(-1) = a^(-1) dot a dot x dot a^(-1) = x dot a^(-1),
$
следовательно $a^(-1) in Z(x)$.
#align(right)[$triangle.filled.l$]

#definition()[
  Множество $Z(G) = { z in G: (forall g in G)(z g = g z) }$ называется _центром_ группы $G$.
]

#statement()[
  Центр $Z(G)$ группы $G$ является подгруппой.
]

#definition()[
  Отображение $phi: (G, dot) arrow.long (G', compose)$ называется _гомоморфизмом_ группы $G$ в группу $G'$, если:
  $
    phi(a dot b) = phi(a) compose phi(b),
  $
  для любых $a,b in G$. Если $phi$ биективно, то $phi$ называется _изоморфизмом_.
]

#theorem("Первая теорема об изоморфизме")[
  Пусть $f: G arrow.r.long H$ --- гомоморфизм групп. Тогда
  $
    im(f) tilde.eq faktor(G, ker(f))
  $
]<fht>

Пусть $G$ группа, $A subset.eq G$ произвольное подмножество. Через $chevron.l A chevron.r$ будем обозначать подгруппу группы $G$ порожденную $A$ (пересечение всех подгрупп $G$ содержащих $A$). Нетрудно убедиться, что
$
  chevron.l A chevron.r = {a_(i_1)^(epsilon_1) dots.h a_(i_n)^(epsilon_n) | a_(i_j) in A, epsilon_j in {1, -1}, n in NN}
$

Пусть $X$ произвольное множество. _Словом_ $w$ в алфавите $X$ будем называть конечную (возможно пустую) последовательность элементов $X$
$
  w = x_1 dots.h x_n," "x_i in X
$
Число $n$ называется _длиной_ слова $w$ (обозначается $abs(w)$). _Пустое слово_ обозначается $epsilon$ и $abs(epsilon) = 0$. Пусть $X^(-1) = {x^(-1) | x in X}$ --- алфавит "обратных" букв. Объединение $X^(plus.minus 1) = X union X^(-1)$ будем называть _групповым алфавитом_.

Выражение вида
$
  w = x_(i_1)^(epsilon_1) dots.h x_(i_n)^(epsilon_n),
$
где $x_(i_j) in X^(plus.minus 1), epsilon_j in {1, -1}$ будем называть _групповым словом_ в $X$.

Групповое слово $w$ называется _редуцированным_, если для всех $i" "y_i eq.not y_(i + 1)^(-1)$, то есть $w$ не содержит подслово вида $y y^(-1)$ для любого символа $y in X^(plus.minus 1)$. Пустое слово будем считать редуцированным.

Если $X subset.eq G$, тогда любое групповое слово $w = x_(i_1)^(epsilon_1) dots.h x_(i_n)^(epsilon_n)$ в $X$ определяет уникальный элемент в $G$, равный произведению $x_(i_1)^(epsilon_1) dots.h x_(i_n)^(epsilon_n)$ элементов $x_(i_j)^(epsilon_j) in G$. Будем считать, что пустое слово $epsilon$ определяет нейтральный элемент $e in G$.

#definition()[
  Группа $G$ называется _свободной_ группой, если существует такое порождающее множество $X subset.eq G$, что любое непустое редуцированное групповое слово в $X$ определяет нетривиальный элемент $G$
]
Тогда $X$ называется _свободным базисом_, а $G$ называется _свободной группой над $X$_ (обозначается $F(X)$).

Из этого определения следует, что любой элемент $F(X)$ может быть определен редуцированным групповым словом в $X$. Более того, разные редуцированные групповые слова в $X$ определяют разные элементы $G$.

Свободные группы обладают следующим универсальным свойством
#theorem("Универсальное свойство")[
  Пусть $G$ группа с порождающим множеством $X subset.eq G$. Тогда $G$ свободная группа над $X$ тогда и только тогда, когда справедливо универсальное свойство: \
  #align(
    center,
  )[_любое отображение $phi: X arrow.r H$ из $X$ в группу $H$ продолжается \ единственным образом до гомоморфизма_
    $
      phi^*: G arrow.long H
    $
    _так, что следующая диаграмма коммутативна_

    #diagram(
      cell-size: 12.5mm,
      node((0, 0), $X$, name: <X>),
      node((1, 0), $G$, name: <G>),
      node((1, 1), $H$, name: <H>),
      edge(<X>, <G>, $i$, "hook->"),
      edge(<X>, <H>, $phi$, "->"),
      edge(<G>, <H>, label-side: left, $phi^*$, "-->"),
    )
  ]
]

Универсальное свойство свободных групп позволяет описывать произвольные группы в терминах _образующих_ и _определяющих соотношений_.

Пусть $G$ -- группа с порождающим множеством $X$. Из универсального свойства следует, что существует гомоморфизм $psi: F(X) arrow.r G$ такой, что $psi(x) = x$ для $x in X$. Следовательно, $psi$ сюръективно, а значит по Теореме @fht
$
  G tilde.eq faktor(F(X), ker(psi))
$

В этом случае $ker(psi)$ рассматривается как множество соотношений в $G$, а групповое слово $w in ker(psi)$ называется _соотношением_ группы $G$ в образующих $X$. Если подмножество $R subset.eq ker(psi)$ порождает $ker(psi)$ как нормальную подгруппу в $F(X)$, то оно называется множеством _определяющих соотношений_ группы $G$ относительно $X$. Пара $chevron.l X | R chevron.r$ называется _заданием_ группы $G$; оно определяет $G$ однозначно с точностью до изоморфизма. Задание $chevron.l X | R chevron.r$ называется _конечным_, если оба множества $X$ и $R$ конечны. Группа называется _конечно представленной_, если она имеет хотя бы одно конечное задание. Если множество порождающих конечное (или счётное), а множество определяющих отношений рекурсивно, то говорят, что группа имеет _рекурсивное задание_. Задания обеспечивают универсальный способ описания групп. В частности, конечно представленные группы допускают конечные описания, например

$
  G = chevron.l x_1, x_2, dots.h, x_n | r_1, r_2, dots.h, r_n chevron.r
$

= Протокол Стикеля

== Проблема разложения
\
Прежде, чем перейти к протоколу Стикеля, нужно сформулировать несколько связанных алгоритмических задач (для групп).

#problem(format-caption: emph, format-body: emph, [Conjugacy search problem, CSP])[
  Дано рекурсивное задание группы $G$ и два сопряженных элемента $g, h in G$. Необходимо найти элемент $x in G$ такой, что $x^(-1) g x = h$.
]

#problem(format-caption: emph, format-body: emph, [Decomposition search problem, DSP])[
  Дано рекурсивное задание группы $G$, две рекурсивно порожденные подгруппы $A, B lt.eq G$ и два элемента $g, h in G$. Необходимо найти два элемента $x in A$ и $y in B$ такие, что
  $
    x dot g dot y = h
  $
  при условии, что хотя бы одна такая пара существует.
]<DSP>

Отметим, что некоторые $x$ и $y$, удовлетворяющие равенству $x dot g dot y = h$ существуют всегда (например, если $x = 1, y = g^(-1)h$), поэтому смысл задачи состоит в том, чтобы они удовлетворяли условиям $x in A, y in B$.

#statement()[
  Если CSP в группе $G$ разрешима, тогда и DSP разрешима для коммутирующих подгрупп $A, B lt.eq G$ (т.е. $a dot b = b dot a$ для всех $a in A, b in B$).
]
$triangle.stroked.r$ Пусть $h = x g y$, где $g, h in G, x in A, y in B$. Мы хотим найти $x$ и $y$. Выберем произвольный $a_1 in A$. Тогда
$
  [h, a_1] = [x g y, a_1] = x g y a_1 y^(-1) g^(-1) x^(-1) a_(1)^(-1) = x g a_1 g^(-1) x^(-1) a_(1)^(-1) = \
  = (a_1)^(x^(-1) g^(-1)) a_(1)^(-1) = ((a_1)^(g^(-1)))^(x^(-1)) a_(1)^(-1) = h',
$
где запись $[a, b] = a b a^(-1) b^(-1)$ --- коммутатор элементов $a$ и $b$, а $a^b = b^(-1) a b$ --- сопряжение.

Так как $a_1$ известен, то мы можем домножить результат на $a_1$ справа. Получим
$
  h'' = h' a_1 = ((a_1)^(g^(-1)))^(x^(-1))
$

Теперь нужно найти $x in A$ при известных $h'', a_1, (a_1)^(g^(-1))$, то есть мы свели проблему к поиску сопрягающего элемента. Аналогично, можно восстановить $y in B$.
#align(right)[$triangle.filled.l$]

== Протокол обмена ключами
\
Протокол обмана ключами Стикеля напоминает классический протокол Диффи-Хеллмана.

Пусть $G$ публичная неабелева конечная (полу)группа, $a, b in G$ открытые элементы такие, что $a b eq.not b a$. Протокол заключается в следующем. Пусть $N$ и $M$ порядки $a$ и $b$ соответственно.
+ Алиса выбирает 2 случайных натуральных числа $n lt N, m lt M$ и отправляет $u = a^n b^m$ Бобу.
+ Боб выбирает 2 случайных натуральных числа $r lt N, s lt M$ и отправляет $v = a^r b^s$  Алисе.
+ Алиса вычисляет $K_A = a^n v b^m = a^(n + r) b^(m + s)$.
+ Боб вычисляет $K_B = a^r u b^s = a^(r + n) b^(s + m)$.

Таким образом, Алиса и Боб получают один и тот же элемент $K = K_A = K_B$, который можно использовать как общий ключ.

#align(center)[
  #figure(
    chronos.diagram({
      import chronos: *

      _par("Алиса", shape: "actor")
      _par("Боб", shape: "actor")

      _seq("Алиса", "Боб", comment: $u = a^n b^m$, comment-align: "center")
      _seq("Боб", "Алиса", comment: $v = a^r b^s$, comment-align: "center")
      _seq("Алиса", "Алиса", comment: $K_A = a^n v b^n$, comment-align: "center", flip: true)
      _seq("Боб", "Боб", comment: $K_B = a^r u b^s$, comment-align: "center")
    }),
    caption: "Протокол Стикеля",
  )
]

\

Также, существует более общая версия этого протокола.

Пусть $w in G$ открытый элемент.
+ Алиса выбирает 2 случайных натуральных числа $n lt N, m lt M$, элемент $c_1 in Z(G)$ и отправляет Бобу $u = c_1 a^n w b^n$.
+ Боб выбирает 2 случайных натуральных числа $r lt N, s lt M$, элемент $c_2 in Z(G)$ и отправляет Алисе $v = c_2 a^r w b^s$.
+ Алиса вычисляет $K_A = c_1 a^n v b^m = c_1 c_2 a^(n+r) w b^(m + s)$.
+ Боб вычисляет $K_B = c_2 a^r u b^s = c_1 c_2 a^(n + r) w b^(m + s)$.

Таким образом, Алиса и Боб получают один и тот же элемент $K = K_A = K_B$.

Подчеркнем, что для работы протокола $G$ необязательно должно быть группой, хватит и случая, где $G$ --- полугруппа (что, на самом деле, даже лучше).

Теперь стоит обсудить общий подход (т.е. независящий от выбора $G$) анализа безопасности протокола. Первое наблюдение заключается в том, что чтобы получить общий секрет $K$, противнику (Еве) достаточно найти любые элементы $x, y in G$ такие, что $x a = a x, y b = b y, u = x w y$. Действительно, имея такие $x, y$, Ева может использовать передачу Боба $v = c_2 a^r w b^s$ чтобы вычислить
$
  x v y = x c_2 a^r w b^s y = c_2 a^r x w y b^s = c_2 a^r u b^s = K.
$

Отсюда следует, что умножение на $c_i$ не усиливает стойкость протокола. Более того, Еве даже не нужно восстанавливать экспоненты $n, m, r, s$; вместо этого она может решить систему уравнений $x a = a x, y b = b y, u = x w y$, где $a, b, w, u$ -- известны, и $x, y$ -- неизвестные элементы $G$. Решение этой системы есть ничто иное как решение Задачи @DSP.

== Платформа протокола

Традиционно, для групп, выбираемых в качестве платформы, выдвигаются следующие требования:
+ Группа должна быть хорошо изучена.
+ Проблема слов в $G$ должна иметь быстрое (линейное или квадратичное) решение детерминированным алгоритмом. Более того, должна существовать эффективно вычислимая "нормальная форма" для элементов $G$.
+ Должен существовать способ маскировки элементов $G$ так, чтобы было невозможно восстановить, скажем $x$ и $y$ из произведения $x y$ простым осмотром.
+ $G$ должна быть группой сверхполиномиального (то есть экспоненциального или "промежуточного") роста. Это означает, что количество элементов длины $n$ в $G$ должно расти быстрее любого полинома от $n$; Это необходимо для предотвращения атак полным перебором.

В качестве платформы для протоколов некоммутативной криптографии естественно рассматривать (полу)группы матриц над конечными коммутативными кольцами, потому что умножение матриц некоммутативно, но элементы матриц, взятые из коммутативного кольца, обеспечивают хороший механизм сокрытия.

Также, у матриц нет проблемы с "нормальной формой" (неформально, нормальная форма -- это способ представления элементов группы в виде простых выражений, который обеспечивает однозначность и упрощает работу с ними), поскольку (полу)группы матриц допускают иное описание, так что способ представления их элементов в виде квадратных таблиц фактически является "естественной" нормальной формой.

Причина, по которой стоит брать конечное кольцо, заключается в том, что это хорошо для диффузии. Конечные кольца $R$ являются периодическими, что означает, что для любого $u in R$ существуют различные положительные целые числа $m, k$ такие, что $u^m = u^k$. Периодичность хороша для диффузии, поскольку порождает динамическую систему, а динамические системы с большим числом состояний обычно демонстрируют очень сложное поведение (например, знаменитая "$3x + 1$" задача).

В качестве платформы для протокола Стикеля я выбрал полугруппу матриц над кольцом циклических многочленов над $ZZ_n$. Циклические многочлены --- это выражения вида $sum_(k = 0)^N a_k x^k$ с обычным сложением и умножением по правилу $x^i dot x^j = x^(i + j mod(N + 1))$, то есть это фактор-кольцо $faktor(ZZ_(n)[x], (x^(N + 1) - 1))$. Идеал порожденный  многочленом $x^(N + 1) - 1$ довольно прост, вычисления в этом фактор-кольце достаточно эффективны. Кроме того, большое ключевое пространство обеспечивается с низкими затратами; например, при $n = 100, N = 20$ существует $100^21 = 10^42$ циклических многочленов, что дает $10^168$ матриц размера $2 times 2$ над этим кольцом.

= Реализация протокола

В этом разделе описывается разработанное приложение, реализующее протокол Стикеля на полугруппе матриц над кольцом циклических многочленов $faktor(ZZ_(n)[x], (x^(N + 1) - 1))$. Код написан на языке Python и использует библиотеку Streamlit для построения веб-интерфейса. Полные исходные тексты приведены в приложении. Файлы организованы в следующей структуре:
#align(center)[
  ```txt
  project/
  ├── app.py
  ├── CyclicPolynomial.py
  ├── protocol.py
  ├── utils.py
  └── requirements.txt
  ```
]

== Архитектура разложения

Программа написана на языке Python с использованием библиотеки Streamlit для веб-интерфейса. Логика разделена на модули:
- *CyclicPolynomial.py*: определяет класс CyclicPolynomial, который представляет циклический многочлен. Хранит коэффициенты по модулю $n$, степень $N$ и реализует основные арифметические операции с приведением по модулю, а также возведение в степень.
- *utils.py*: содержит вспомогательные функции: создание единичной матрицы из полиномов, быстрое возведение матрицы в степень и проверку, является ли матрица единичной.
- *protocol.py*: реализует класс StickelProtocol, который выполняет шаги протокола (генерация секретных чисел, вычисление $u = A^n B^m$ и $v = A^r B^s$, формирование общего ключа).
- *app.py*: главный файл с интерфейсом Streamlit. Позволяет задать параметры $n$ (модуль кольца), $N$ (максимальную степень), размер матриц, плотность ненулевых коэффициентов. Запускает протокол и выводит матрицы в формате LaTeX, а также результат совпадения ключей.

Все матрицы хранятся в виде массивов NumPy с типом элемента object, что позволяет хранить в ячейках экземпляры CyclicPolynomial.

== Ключевые алгоритмы

=== Умножение циклических многочленов

Умножение выполняется по правилу $x^i x^j = x^(i + j mod (N + 1))$ с последующим приведением коэффициентов по модулю $n$. Листинг @lst:mul показывает этот метод:
#figure(
  ```python
      def _mul_poly(self, other):
        """Умножение многочленов"""
        res = CyclicPolynomial(self.N, self.modulus)
        for i in range(self.M):
            for j in range(self.M):
                k = (i + j) % self.M
                res[k] += self[i] * other[j]

        return res
  ```,
  caption: "Умножение циклических многочленов",
)<lst:mul>

=== Быстрое возведение матрицы в степень

Для вычисления $A^n$ используется бинарный алгоритм, реализованный в функции mat_pow (модуль utils.py). Листинг @lst:pow демонстрирует этот алгоритм:

#figure(
  ```py
  def mat_pow(mat, exponent):
    """Возведение матрицы (np.ndarray, dtype=object) в целую неотрицательную степень"""
    size = mat.shape[0]

    # Достаем параметры кольца из первого элемента матрицы
    sample_poly = mat[0, 0]
    N = sample_poly.N
    modulus = sample_poly.modulus

    result = get_identity_poly_matrix(size, N, modulus)
    base = mat
    e = exponent
    while e > 0:
        if e & 1:
            result = result @ base
        base = base @ base
        e >>= 1
    return result

  ```,
  caption: "Бинарное возведение матрицы в степень",
)<lst:pow>

=== Основной протокол
Класс StickelProtocol инкапсулирует логику протокола. Метод run генерирует секретные числа для Алисы и Боба, обменивается сообщениями и вычисляет ключи:

#figure(
  ```py
      def run(self):
        """Запускает полный протокол и возвращает ключи, а также промежуточные значения."""
        u, n, m = self.alice_step()
        v, r, s = self.bob_step()
        K_alice = self.alice_key(v, n, m)
        K_bob = self.bob_key(u, r, s)
        return {
            "u": u,
            "v": v,
            "n": n,
            "m": m,
            "r": r,
            "s": s,
            "K_alice": K_alice,
            "K_bob": K_bob,
            "keys_match": np.array_equal(K_alice, K_bob),
        }
  ```,
  caption: "Метод run",
)

Полный код доступен в приложении.

== Пользовательский интерфейс

Интерфейс реализован с помощью библиотеки Streamlit. После запуска команды `streamlit run app.py` пользователь видит боковую панель для ввода параметров (модуль $n$, максимальная степень $N$, размер матриц, плотность). По нажатию кнопки генерируются матрицы $A$ и $B$, причем проверяется условие $A B eq.not B A$. Затем выполняются шаги протокола и результаты отображаются в формате LaTeX.

#figure(
  image("screenshot.png", width: 80%),
  caption: "Скриншот веб-интерфейса приложения",
)

== Зависимости

Для воспроизведения окружения необходимо установить библиотеки, перечисленные в файле requirements.txt, который приведен в листинге @lst:req.

#figure(
  ```txt
  streamlit>=1.28.0
  numpy>=1.24.0
  ```,
  caption: "Файл requirements.txt",
)<lst:req>

Зависимости устанавливаются командой `pip install -r requirements.txt`.

= Заключение

В ходе выполнения данной курсовой работы были изучены основные понятия комбинаторной теории групп, необходимые для понимания некоммутативных криптографических протоколов: группы, полугруппы, подгруппы, гомоморфизмы, свободные группы, задание групп образующими и определяющими соотношениями. Особое внимание уделено алгоритмическим проблемам, лежащим в основе некоммутативной криптографии --- проблеме поиска сопряженного элемента (CSP) и проблеме разложения (DSP), к которой сводится криптоанализ протокола Стикеля.

Был подробно разобран протокол обмена ключами Стикеля, являющийся некоммутативным аналогом классического протокола Диффи-Хеллмана. Рассмотрены требования к платформе протокола и обоснован выбор полугруппы матриц над кольцом циклических многочленов $faktor(ZZ_(n)[x], (x^(N + 1) - 1))$ как компромисса между эффективностью вычислений, стойкостью к некоторым атакам и простотой реализации.

В практической части разработано приложение на языке Python с веб-интерфейсом на базе Streamlit, реализующее полный цикл протокола: генерацию публичных матриц $A$ и $B$ с заданными параметрами ($n$, $N$, размер, плотность), формирование секретных чисел Алисой и Бобом, вычисление промежуточных значений $u=A^n B^m$ и $v=A^r B^s$, а также итоговых ключей $K_A$ и $K_B$. Корректность работы протокола подтверждается совпадением полученных ключей.

Разработанное программное обеспечение может служить как демонстрационный стенд для изучения некоммутативной криптографии, так и основа для дальнейших исследований — например, для анализа стойкости протокола при различных параметрах кольца или для адаптации к другим алгебраическим структурам.

#set heading(numbering: none)

#bibliography("books.yml", title: "Список литературы", full: true, style: "gost-r-705-2008-numeric")

= Приложение A

Полный коды всех модулей приведены ниже.

Модуль CyclicPolynomial.py

```python
class CyclicPolynomial:
    """Многочлен степени <= N с умножением x^i * x^j = x^{i + j (mod (N + 1)} над ZZ_n"""

    def __init__(self, N, modulus, coeffs=None):
        """
        :param N: максимальная степень (порядок циклической группы мономов)
        :param modulus: n - модуль кольца ZZ_n
        :param coeffs: список, кортеж или словарь {степень: коэффициент}
        """
        if modulus <= 1:
            raise ValueError("Модуль должен быть больше 1")
        self.N = N
        self.modulus = modulus
        self.M = N + 1  # число мономов
        self.coeffs = [0] * self.M

        if coeffs is None:
            return

        if isinstance(coeffs, (list, tuple)):
            for i, val in enumerate(coeffs):
                if i < self.M:
                    self.coeffs[i] = val % self.modulus

        elif isinstance(coeffs, dict):
            for deg, val in coeffs.items():
                if 0 <= deg < self.M:
                    self.coeffs[deg] = val % self.modulus

        else:
            raise TypeError("coeffs должен быть списком, кортежем или словарём")

    def _mod(self, value):
        """Приводит целое число к остатку по модулю self.modulus"""
        return value % self.modulus

    def __getitem__(self, idx):
        return self.coeffs[idx]

    def __setitem__(self, idx, value):
        self.coeffs[idx] = self._mod(value)

    def __len__(self):
        return self.M

    def __add__(self, other):
        if not isinstance(other, CyclicPolynomial):
            raise TypeError("Можно складывать только с CyclicPolynomial")

        if self.N != other.N or self.modulus != other.modulus:
            raise ValueError("Степени N и модули должны совпадать")

        res = CyclicPolynomial(self.N, self.modulus)
        for i in range(self.M):
            res[i] = self[i] + other[i]

        return res

    def __sub__(self, other):
        if not isinstance(other, CyclicPolynomial):
            raise TypeError("Можно вычитать только CyclicPolynomial")

        if self.N != other.N or self.modulus != other.modulus:
            raise ValueError("Степени N и модули должны совпадать")

        res = CyclicPolynomial(self.N, self.modulus)
        for i in range(self.M):
            res[i] = self[i] - other[i]

        return res

    def _mul_poly(self, other):
        """Умножение многочленов"""
        res = CyclicPolynomial(self.N, self.modulus)
        for i in range(self.M):
            for j in range(self.M):
                k = (i + j) % self.M
                res[k] += self[i] * other[j]

        return res

    def __mul__(self, other):
        if isinstance(other, int):
            scalar = other % self.modulus
            res = CyclicPolynomial(self.N, self.modulus)
            for i in range(self.M):
                res[i] = self[i] * scalar
            return res

        if not isinstance(other, CyclicPolynomial):
            return NotImplemented

        if self.N != other.N or self.modulus != other.modulus:
            raise ValueError("Степени N и модули должны совпадать")

        return self._mul_poly(other)

    def __rmul__(self, scalar):
        # scalar * self
        return self.__mul__(scalar)

    def __pow__(self, exponent):
        if exponent < 0:
            raise ValueError("Степень должна быть неотрицательной")

        result = CyclicPolynomial(self.N, self.modulus, {0: 1})  # x^0 = 1
        base = self
        while exponent:
            if exponent & 1:
                result = result * base
            base = base * base
            exponent >>= 1

        return result

    def __eq__(self, other):
        if not isinstance(other, CyclicPolynomial):
            return False

        return (
            self.N == other.N
            and self.modulus == other.modulus
            and self.coeffs == other.coeffs
        )

    def __str__(self):
        terms = []
        for i, c in enumerate(self.coeffs):
            if c == 0:
                continue
            if i == 0:
                terms.append(f"{c}")
            elif i == 1:
                if c == 1:
                    terms.append("x")
                else:
                    terms.append(f"{c}*x")
            else:
                if c == 1:
                    terms.append(f"x^{i}")
                else:
                    terms.append(f"{c}*x^{i}")

        if not terms:
            return "0"

        return " + ".join(terms)

    def __repr__(self):
        return f"CyclicPolynomial(N={self.N}, modulus={self.modulus}), coeffs={self.coeffs}"

    def degree(self):
        """Степень многочлена"""
        for i in range(self.M - 1, -1, -1):
            if self.coeffs[i] != 0:
                return i
        return -1
```<appendix:CyclicPolynomial>

\

Модуль utils.py

```python
import numpy as np
from CyclicPolynomial import CyclicPolynomial


def get_identity_poly_matrix(size, N, modulus):
    """Создает единичную матрицу из объектов CyclicPolynomial"""
    identity = np.empty((size, size), dtype=object)
    for i in range(size):
        for j in range(size):
            if i == j:
                identity[i, j] = CyclicPolynomial(N, modulus, {0: 1})  # Полином '1'
            else:
                identity[i, j] = CyclicPolynomial(N, modulus, {})  # Полином '0'
    return identity


def mat_pow(mat, exponent):
    """Возведение матрицы (np.ndarray, dtype=object) в целую неотрицательную степень"""
    size = mat.shape[0]

    # Достаем параметры кольца из первого элемента матрицы
    sample_poly = mat[0, 0]
    N = sample_poly.N
    modulus = sample_poly.modulus

    result = get_identity_poly_matrix(size, N, modulus)
    base = mat
    e = exponent
    while e > 0:
        if e & 1:
            result = result @ base
        base = base @ base
        e >>= 1
    return result


def is_identity(mat):
    """Проверка, является ли матрица единичной"""
    size = mat.shape[0]

    sample_poly = mat[0, 0]
    N = sample_poly.N
    modulus = sample_poly.modulus

    identity = get_identity_poly_matrix(size, N, modulus)
    return np.array_equal(mat, identity)
```<appendix:utils>

\

Модуль protocol.py

```python
import numpy as np
import random
from CyclicPolynomial import CyclicPolynomial
from utils import is_identity, mat_pow


def random_polynomial(N, modulus, density=0.5):
    """
    Генерирует случайный многочлен из CyclicPolynomial.
    density: вероятность того, что коэффициент при каждой степени ненулевой.
    """
    coeffs = {}
    for deg in range(N + 1):
        if random.random() < density:
            coeffs[deg] = random.randint(0, modulus - 1)
    return CyclicPolynomial(N, modulus, coeffs)


def generate_random_matrix(size, N, modulus, density=0.5):
    """
    Генерирует квадратную матрицу случайных многочленов.
    """
    mat = np.empty((size, size), dtype=object)
    for i in range(size):
        for j in range(size):
            mat[i, j] = random_polynomial(N, modulus, density)
    return mat


def is_identity_matrix(mat):
    return is_identity(mat)


class StickelProtocol:
    """
    Реализация протокола Стикеля для матриц над кольцом циклических многочленов.
    Публичные параметры: матрицы A и B, такие, что AB != BA.
    """

    def __init__(self, A, B):
        """
        A, B: numpy массивы (dtype = object) размера d x d.
        """
        if A.shape != B.shape or A.ndim != 2 or A.shape[0] != A.shape[1]:
            raise ValueError(
                "A и B должны быть квадратными матрицами одинакового размера"
            )

        self.A = A
        self.B = B
        self.size = A.shape[0]
        self.upper_bound = 10 * 6

    def alice_step(self):
        """Алиса: выбирает n < upper_bound, m < upper_bound и вычисляет u = A^n * B^m."""
        n = random.randint(0, self.upper_bound - 1)
        m = random.randint(0, self.upper_bound - 1)
        An = mat_pow(self.A, n)
        Bm = mat_pow(self.B, m)
        u = An @ Bm
        return u, n, m

    def bob_step(self):
        """Боб: выбирает r < orderA, s < orderB и вычисляет v = A^r * B^s."""
        r = random.randint(0, self.upper_bound - 1)
        s = random.randint(0, self.upper_bound - 1)
        Ar = mat_pow(self.A, r)
        Bs = mat_pow(self.B, s)
        v = Ar @ Bs
        return v, r, s

    def alice_key(self, v, n, m):
        """Алиса вычисляет общий ключ: K_A = A^n * v * B^m"""
        An = mat_pow(self.A, n)
        Bm = mat_pow(self.B, m)
        return An @ v @ Bm

    def bob_key(self, u, r, s):
        """Боб вычисляет общий ключ: K_B = A^r * u * B^s"""
        Ar = mat_pow(self.A, r)
        Bs = mat_pow(self.B, s)
        return Ar @ u @ Bs

    def run(self):
        """Запускает полный протокол и возвращает ключи, а также промежуточные значения."""
        u, n, m = self.alice_step()
        v, r, s = self.bob_step()
        K_alice = self.alice_key(v, n, m)
        K_bob = self.bob_key(u, r, s)
        return {
            "u": u,
            "v": v,
            "n": n,
            "m": m,
            "r": r,
            "s": s,
            "K_alice": K_alice,
            "K_bob": K_bob,
            "keys_match": np.array_equal(K_alice, K_bob),
        }
```<appendix:protocol>

\

Модуль app.py

```python
import streamlit as st
import numpy as np

# Импортируем ваши классы
from CyclicPolynomial import CyclicPolynomial
from protocol import StickelProtocol, generate_random_matrix


def poly_to_latex(poly):
    """Преобразует CyclicPolynomial в строку LaTeX"""
    if not isinstance(poly, CyclicPolynomial):
        return str(poly)

    terms = []
    for i, c in enumerate(poly.coeffs):
        if c == 0:
            continue
        if i == 0:
            terms.append(f"{c}")
        elif i == 1:
            terms.append("x" if c == 1 else f"{c}x")
        else:
            terms.append(f"x^{{{i}}}" if c == 1 else f"{c}x^{{{i}}}")

    if not terms:
        return "0"
    return " + ".join(terms)


def matrix_to_latex(mat):
    """Преобразует numpy матрицу полиномов в строку LaTeX"""
    rows, cols = mat.shape
    latex_str = r"\begin{pmatrix}" + "\n"
    for i in range(rows):
        row_strs = [poly_to_latex(mat[i, j]) for j in range(cols)]
        latex_str += " & ".join(row_strs) + r" \\" + "\n"
    latex_str += r"\end{pmatrix}"
    return latex_str


# --- ИНТЕРФЕЙС STREAMLIT ---
st.set_page_config(page_title="Stickel Protocol", layout="wide")
st.title("Протокол Стикеля над циклическими многочленами")

st.sidebar.header("Параметры генерации")
modulus = st.sidebar.number_input(
    "Модуль кольца ($n$)", min_value=2, max_value=100, value=7, step=1
)
N = st.sidebar.number_input(
    "Макс. степень многочлена ($N$)", min_value=1, max_value=10, value=3, step=1
)
matrix_size = st.sidebar.slider("Размер матриц", min_value=2, max_value=4, value=2)
density = st.sidebar.slider(
    "Плотность (вероятность ненулевого коэффициента)",
    min_value=0.1,
    max_value=1.0,
    value=0.6,
)

if st.sidebar.button("Сгенерировать и запустить протокол", type="primary"):
    # Генерация матриц, проверяем чтобы они не коммутировали (AB != BA)
    with st.spinner("Генерация матриц и выполнение протокола..."):
        while True:
            A = generate_random_matrix(matrix_size, N, modulus, density)
            B = generate_random_matrix(matrix_size, N, modulus, density)
            if not np.array_equal(A @ B, B @ A):
                break

        # Запуск протокола
        protocol = StickelProtocol(A, B)
        results = protocol.run()

    # Вывод публичных матриц
    st.header("1. Публичные параметры")
    st.write(
        "Матрицы $A$ и $B$ над $\mathbb{Z}_{"
        + str(modulus)
        + "}[x]/(x^{"
        + str(N + 1)
        + "}-1)$:"
    )

    col1, col2 = st.columns(2)
    with col1:
        st.subheader("Матрица $A$")
        st.latex(r"A = " + matrix_to_latex(A))
    with col2:
        st.subheader("Матрица $B$")
        st.latex(r"B = " + matrix_to_latex(B))

    st.divider()

    # Обмен ключами
    st.header("2. Обмен сообщениями")

    col_alice, col_bob = st.columns(2)
    with col_alice:
        st.subheader("👩 Алиса")
        st.write(
            f"Генерирует секретные числа: $n = {results['n']}$, $m = {results['m']}$"
        )
        st.write("Вычисляет и отправляет $u = A^n B^m$:")
        st.latex(r"u = " + matrix_to_latex(results["u"]))

    with col_bob:
        st.subheader("👨 Боб")
        st.write(
            f"Генерирует секретные числа: $r = {results['r']}$, $s = {results['s']}$"
        )
        st.write("Вычисляет и отправляет $v = A^r B^s$:")
        st.latex(r"v = " + matrix_to_latex(results["v"]))

    st.divider()

    # Вычисление общего ключа
    st.header("3. Вычисление общего ключа")
    st.write(
        "Каждая сторона вычисляет общий секрет: $K_A = A^n v B^m$ и $K_B = A^r u B^s$."
    )

    col_k1, col_k2 = st.columns(2)
    with col_k1:
        st.markdown("**Ключ, вычисленный Алисой ($K_A$):**")
        st.latex(r"K_A = " + matrix_to_latex(results["K_alice"]))
    with col_k2:
        st.markdown("**Ключ, вычисленный Бобом ($K_B$):**")
        st.latex(r"K_B = " + matrix_to_latex(results["K_bob"]))

    if results["keys_match"]:
        st.success("✅ Протокол успешно завершен! Ключи Алисы и Боба совпадают.")
    else:
        st.error("❌ Ошибка! Ключи не совпадают.")
```<appendix:app>

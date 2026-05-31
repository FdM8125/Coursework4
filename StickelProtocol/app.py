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

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

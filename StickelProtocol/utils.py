import numpy as np


def mat_pow(mat, exponent):
    """Возведение матрицы (np.ndarray, dtype=object) в целую неотрицательную степень"""
    size = mat.shape[0]

    result = np.eye(size, dtype=object)
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
    identity = np.eye(size, dtype=object)
    return np.array_equal(mat, identity)


def compute_order(matrix, max_order=1000):
    """
    Находит наименьшее положительное t такое, что matrix^t = I.
    Возвращает t или None, если порядок не найден в пределах max_order.
    """
    size = matrix.shape[0]
    identity = np.eye(size, dtype=object)
    if np.array_equal(matrix, identity):
        return 1

    current = matrix
    for t in range(2, max_order + 1):
        current = current @ matrix
        if np.array_equal(current, identity):
            return t

    return None

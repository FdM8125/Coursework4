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

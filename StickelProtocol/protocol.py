import numpy as np
import random
from CyclicPolynomial import CyclicPolynomial
from utils import compute_order, is_identity, mat_pow


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
        self.orderA = compute_order(A, max_order=10**6)
        self.orderB = compute_order(B)

        if self.orderA is None or self.orderB is None:
            raise ValueError(
                "Не удалось вычислить порядки матриц (возможно, они слишком велики)"
            )

    def alice_step(self):
        """Алиса: выбирает n < orderA, m < orderB и вычисляет u = A^n * B^m."""
        n = random.randint(0, self.orderA - 1)
        m = random.randint(0, self.orderB - 1)
        An = mat_pow(self.A, n)
        Bm = mat_pow(self.B, m)
        u = An @ Bm
        return u, n, m

    def bob_step(self):
        """Боб: выбирает r < orderA, s < orderB и вычисляет v = A^r * B^s."""
        r = random.randint(0, self.orderA - 1)
        s = random.randint(0, self.orderB - 1)
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

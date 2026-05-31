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

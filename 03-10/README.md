## Условие tl;dr
Сначала дано число $N$, потом $N$ пар чисел $Xi, Yi$, каждая пара — это дробь: $\frac{Xi}{Yi}$
Нужно найти сумму всех дробей и вывести её как несократимую дробь.
## Решение — псевдокод

``` rust
fn gcd(a: u32, b: u32) -> u32 {
    // Алгоритм Евклида
    while b != 0 {
        let t = a % b;
        a = b;
        b = t;
    }
    return a;
}

fn solve() {
    read n;

    // Начальная сумма = num / den
    let num = 0;
    let den = 1;

    for i 0..n {
        read x, y;

        // Прибавляем очередную дробь x/y:
        // num/den + x/y = (num*y + x*den) / (den*y)
        num = num * y + x * den;
        den = den * y;

        // Сразу сокращаем результат,
        // чтобы числа не разрастались
        let g = gcd(num, den);
        num = num / g;
        den = den / g;
    }

    print num, den
}
```

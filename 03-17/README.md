# 03-17. Беззнаковое произведение
## Условие tl;dr
На вход подаются три неотрицательных целых числа: $a, b, c$
Нужно вычислить: $a \cdot b \cdot c$
и вывести результат в десятичной записи без ведущих нулей.

## Решение — псевдокод

``` rust
const BASE = 1000000000

type Big = struct {
    d[4]: u32,   // блоки числа в базе 10^9, от младшего к старшему
    size: u32    // сколько блоков реально используется
}

// Складывает два u32.
// Возвращает:
// - sum   : младшие 32 бита суммы
// - carry : перенос (0 или 1)
fn add32(a: u32, b: u32) -> (u32, u32) {
    let sum = a + b // 
    let carry = 0

    if sum < a {
        carry = 1
    }

    return (sum, carry)
}

// Умножает два u32.
// Возвращает 64-битный результат как пару:
// hi:lo
//
// В asm это обычный mul.
fn mul_u32(a: u32, b: u32) -> (u32, u32) {
    // result = a * b // 200 * 2 = 400 -> lo = 255 hi = 145
    // return (hi, lo)
}

// Делит 64-битное число hi:lo на BASE.
// Возвращает:
// - q   : частное (u32)
// - rem : остаток (u32)
//
// В asm это:
//   EDX = hi
//   EAX = lo
//   div BASE
// после чего:
//   EAX = q
//   EDX = rem
fn div_u64_by_base(hi: u32, lo: u32) -> (u32, u32) {
    // return (q, rem)
}

fn mul_big_by_u32(big: Big, num: u32) {
    let i = 0
    let carry = 0   // перенос между блоками, обычный u32

    while i < big.size or carry > 0 {
        if i == big.size {
            big.d[i] = 0
            big.size += 1
        }

        // 1) prod = big.d[i] * num
        let (prod_hi, prod_lo) = mul_u32(big.d[i], num)

        // 2) cur = prod + carry
        // carry добавляем только к младшей части
        let (cur_lo, c1) = add32(prod_lo, carry)
        let cur_hi = prod_hi + c1

        // 3) делим cur на BASE
        // rem  -> новый блок
        // q    -> новый carry
        let (new_carry, rem) = div_u64_by_base(cur_hi, cur_lo)

        big.d[i] = rem
        carry = new_carry

        i += 1
    }
}

fn solve(a: u32, b: u32, c: u32) -> Big {
    let res = Big {
        d: [0, 0, 0, 0],
        size: 1
    }

    // Изначально число равно a
    res.d[0] = a

    // Домножаем на b и c
    mul_big_by_u32(res, b)
    mul_big_by_u32(res, c)

    return res
}
```

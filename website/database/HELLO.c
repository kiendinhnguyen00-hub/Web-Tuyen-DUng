//chương trình liệt kê các số nguyên tố từ m đến n nhập vào từ bàn phím 
#include <stdio.h>
#include <math.h>

int isPrime(int x) {
    if (x < 2) return 0;
    if (x == 2) return 1;
    if (x % 2 == 0) return 0;
    int limit = (int)sqrt((double)x);
    for (int i = 3; i <= limit; i += 2) {
        if (x % i == 0) return 0;
    }
    return 1;
}

int main() {
    int m, n;
    printf("Nhap m va n: ");
    if (scanf("%d %d", &m, &n) != 2) {
        return 0;
    }

    if (m > n) {
        int tmp = m;
        m = n;
        n = tmp;
    }

    printf("Cac so nguyen to tu %d den %d:\n", m, n);
    for (int i = m; i <= n; i++) {
        if (isPrime(i)) {
            printf("%d ", i);
        }
    }
    printf("\n");

    return 0;
}
#include <stdio.h>
#include <string.h>

extern "C" {
    void my_printf(const char* str, ...);
}

int main() {
    const char* str = "%x lalalalalala\n";
    long long x = -214213;
    my_printf(str, x);

    return 0;
}
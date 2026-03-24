#include <stdio.h>
#include <string.h>

extern "C" {
    void my_printf(const char* str, ...);
}

int main() {
    const char* str = "%b huuuuuuuuuuuuuuuuuuuui\n";
    my_printf(str, 5);

    return 0;
}
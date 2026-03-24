#include <stdio.h>
#include <string.h>

extern "C" {
    void my_printf(const char* str, ...);
}

int main() {
    const char* str = "%x huuuuuuuuuuuuuuuuuuuui\n";
    my_printf(str, 10);

    return 0;
}
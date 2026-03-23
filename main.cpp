#include <stdio.h>
#include <string.h>

extern "C" {
    void my_printf(const char* str);
}

int main() {
    const char* str = "huuuuuuuuuuuuuuuuuuuui\n";
    my_printf(str);

    return 0;
}
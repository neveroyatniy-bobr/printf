#include <stdio.h>
#include <string.h>

extern "C" {
    void my_printf(size_t len, const char* str);
}

int main() {
    const char* str = "huuuuuuuuuuuuuuuuuuuui\n";
    my_printf(strlen(str), str);

    return 0;
}
#include <stdio.h>
#include <string.h>

extern "C" {
    void my_printf(const char* str, ...);
}

int main() {
    const char* str = "%c lalalalalala\n";
    my_printf(str, 'h');

    return 0;
}
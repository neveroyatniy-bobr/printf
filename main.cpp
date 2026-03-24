#include <stdio.h>
#include <string.h>

extern "C" {
    void my_printf(const char* str, ...);
}

int main() {
    const char* str = "%s lalalalalala\n";
    my_printf(str, "shashasha");

    return 0;
}
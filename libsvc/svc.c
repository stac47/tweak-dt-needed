#include <stdio.h>

extern void stac_common_print();

void stac_svc_decorate() {
    puts("Decorated");
    stac_common_print();
}

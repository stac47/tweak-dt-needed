#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

extern void stac_common_print();

int main(int argc, const char *argv[])
{
    void *libHandle;
    void (*funcp)();
    const char *err;

    stac_common_print();

    libHandle = dlopen("libsvc.so", RTLD_LAZY);
    err = dlerror();
    printf("dlopen: %s\n", err);
    if (libHandle == NULL) {
        exit(1);
    }
    *(void **) (&funcp) = dlsym(libHandle, "stac_svc_decorate");
    err = dlerror();
    if (funcp == NULL) {
        exit(1);
    }

    (*funcp)();

    dlclose(libHandle);
    return 0;
}

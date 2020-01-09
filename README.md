!DT_NEEDED Tweak

In Python 3.8, the C extensions are no more linked with `libpython` so that
there is no problem importing a C extension module from a statically linked
python. Moreover, from now, the choice of `libpython` is lead by the python
interpreter binary when dynamically linked. This is described in the
[bpo-21536](https://bugs.python.org/issue21536).

I was told this could lead to performance gain.  Although, I can understand the
benefit for python (it allows to debug the same version of the library when
loaded by a module), but I was wondering how this could give a performance
boost at program startup and at function call.

!!Test

!!!Before

```
main ------------- dlopen --------------> libsvc.so
 |                                         |
 L DT_NEEDED libcommon.so                  L DT_NEEDED libcommon.so
```

`main` will call a function in `libcommon.so` and `dlopen` the shared library
`libsvc.so` and call the same function defined in `libcommon.so`.

!!! After

Same scenario without linking `libsvc.so` with `libcommon.so`. This results in
a missing `DT_NEEDED` entry. As a matter of fact, if the main does not declare
its dependency upon `libcommon.so`, the program will crash. The `libsvc.so` is
kink of malformed. In the Python case, this is unimportant since a module will
be executed in a Python interpreter context.

```
main ------------- dlopen --------------> libsvc.so
 |
 L DT_NEEDED libcommon.so
```

!!Results

The only I could see was that when the `libsvc.so` is `dlopen`ed, the dynamic
linker will have to perform a lookup of weak symbols that need to be relocated
(in `rela.dyn` section). The lookup of weak symbols continues until the a
defined symbol is found. So, it will look for those symbols in all the
DT_NEEDED libraries. As a consequence, if the `DT_NEEDED` libraries set is
incomplete, this lookup is shorter.

It is the only thing that could explain a performance boost when the `dlopen`
is performed.

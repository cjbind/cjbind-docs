# Command Line Usage

If you have installed `cjbind` according to the instructions in [Installation](/en/guide/install) and can view the version number using the `cjbind --version` command, you can use the `cjbind` command to generate FFI binding code.

The `cjbind` command takes a C header file path as input and optionally specifies an output file path for the generated bindings. If no output file path is provided, the binding code will be output to `stdout`.

If we want to generate Cangjie FFI bindings from a C header file named `library.h` and place them in a `cjbind_ffi.cj` file, we can invoke `cjbind` like this:

```bash
$ cjbind -o cjbind_ffi.cj library.h
```

To view more detailed help information, pass the `--help` argument:

```text
$ cjbind --help
Automatically generate FFI bindings from C libraries to Cangjie.

Usage: cjbind <OPTIONS> <HEADER> -- <CLANG_ARGS>

Arguments:
    <HEADER>          C header file path
    [CLANG_ARGS]...   Arguments that will be passed directly to clang

Options:
        --no-enum-prefix                 When generating enums, do not use enum names as prefixes for enum values
        --no-detect-include-path         Disable automatic include path detection
        --no-comment                     Do not attempt to generate comments in the code
        --no-layout-test                 Do not generate layout test code
        --builtins                       Generate bindings for builtin definitions like __builtin_va_list
        --make-func-wrapper              Generate foreign function wrappers to allow calls from outside the package
        --func-wrapper-suffix <SUFFIX>   Suffix used when generating function wrappers, defaults to _cjbindwrapper
        --auto-cstring                   Convert char* to CString instead of CPointer<UInt8>
        --array-pointers-in-args         Convert arrays T arr[size] to VArray<T, $size> instead of CPointer<T>
        --make-cjstring                  Convert C strings to Cangjie String instead of VArray<UInt8>, which may cause binary representation inconsistency
    -o, --output <FILE>                  Output the generated bindings to a file
    -p, --package <PACKAGE>              Package name in the generated bindings
    -v, --version                        Display version number and exit
    -h, --help                           Display help information
```

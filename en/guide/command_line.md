# Command Line Usage

If you have installed `cjbind` according to the instructions in [Installation](/en/guide/install) and can view the version number using the `cjbind --version` command, you can use the `cjbind` command to generate FFI binding code.

The `cjbind` command accepts one or more header file paths as input and can optionally write the generated bindings to an output file. If no output file path is provided, the bindings are written to `stdout`.

If we want to generate Cangjie FFI bindings from a C header file named `library.h` and place them in a `cjbind_ffi.cj` file, we can invoke `cjbind` like this:

```bash
$ cjbind -o cjbind_ffi.cj library.h
```

If you pass multiple headers, the last header is treated as the main translation unit, and the earlier headers are added through `-include`:

```bash
$ cjbind base.h config.h api.h -- -I./include
```

To generate Objective-C bindings, enable `--objc`:

```bash
$ cjbind --objc Foundation/NSString.h
```

If you want declarations tailored for Cangjie's Objective-C interop layer, switch to `compiler` mode:

```bash
$ cjbind --objc --objc-codegen-mode compiler --objc-generate-definitions UIKit/UIView.h
```

For supported Objective-C constructs, the two code generation modes, and usage guidance, see [Objective-C Bindings](/en/guide/objective_c).

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
        --objc                           Enable Objective-C binding generation mode
        --objc-codegen-mode <MODE>       ObjC code generation mode: runtime (default) or compiler
        --objc-generate-definitions      Generate stub method bodies with default return values in compiler mode
        --default-enum-style <STYLE>     Default enum generation style: consts (default) or newtype
        --fit-macro-constants            Pick the smallest fitting integer type for macro constants
    -o, --output <FILE>                  Output the generated bindings to a file
    -p, --package <PACKAGE>              Package name in the generated bindings
    -v, --version                        Display version number and exit
    -h, --help                           Display help information
```

## Option Notes

- `--default-enum-style newtype`: emit enums as `@C struct` newtypes instead of a flat list of constants.
- `--fit-macro-constants`: shrink integer macro constants to the smallest fitting integer type instead of always using `Int64` / `UInt64`.
- `--objc`: enable Objective-C parsing and code generation.
- `--objc-codegen-mode runtime`: generate wrappers based on `objc_msgSend`, suitable for direct Objective-C Runtime dispatch.
- `--objc-codegen-mode compiler`: generate declarations with annotations such as `@ObjCMirror`, suitable for Cangjie's Objective-C interop layer.
- `--objc-generate-definitions`: meaningful only in `compiler` mode; emits stub method bodies with default return values so the generated code can compile earlier in the workflow.

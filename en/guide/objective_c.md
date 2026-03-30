# Objective-C Bindings

`cjbind` can parse Objective-C headers and generate Cangjie bindings with the `--objc` option.

## Basic Usage

The simplest form looks like this:

```bash
$ cjbind --objc Foundation/NSString.h
```

If you also need to pass SDK paths, framework search paths, or other clang arguments, put them after `--`:

```bash
$ cjbind --objc UIKit/UIView.h -- -isysroot /path/to/SDK -F/path/to/Frameworks
```

## Supported Declarations

Objective-C mode is primarily aimed at declarations found in headers, including:

- `@interface`
- `@protocol`
- categories
- instance methods and class methods
- properties
- block parameters
- nullability information
- lightweight generic names as comments

The generated output is mapped into classes, interfaces, extensions, and the corresponding methods and properties.

## Code Generation Modes

`--objc-codegen-mode` provides two modes.

### runtime

`runtime` is the default mode. It generates wrappers based on the Objective-C Runtime and dispatches calls through functions such as `objc_msgSend`, `objc_getClass`, and `sel_registerName`.

This mode is closer to direct runtime bridging and is suitable when the runtime environment is already in place and you want to use Objective-C APIs as regular Cangjie wrappers.

```bash
$ cjbind --objc --objc-codegen-mode runtime Foundation/NSString.h
```

### compiler

`compiler` mode generates declarations with annotations such as `@ObjCMirror`, `@ForeignName`, `@ObjCInit`, and `@ObjCOptional`, which is better suited for Cangjie's Objective-C interop layer.

```bash
$ cjbind --objc --objc-codegen-mode compiler Foundation/NSString.h
```

If you want generated methods to include stub bodies with default return values so the code can compile earlier in the workflow, add `--objc-generate-definitions`:

```bash
$ cjbind --objc --objc-codegen-mode compiler --objc-generate-definitions Foundation/NSString.h
```

## Usage Notes

- Pass complete system header and framework search paths to clang, or many Objective-C types will fail to resolve correctly.
- Prefer `runtime` mode when your goal is direct Runtime-based dispatch.
- Prefer `compiler` mode when your goal is declaration-oriented code for Cangjie interop.
- Review generated code manually for APIs that depend on ownership, lifetime, or unusual ABI behavior.

## Related Limitations

Objective-C mode covers common declaration generation, but it does not infer higher-level framework semantics for you. For ownership, lifecycle, and unusual dispatch edge cases, also see [Known Limitations](/en/guide/limitation).

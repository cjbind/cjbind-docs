# Known Limitations

The following cases need extra attention when generating bindings with `cjbind`.

## Packed Layouts and Non-default Alignment

Cangjie still lacks precise alignment-control syntax, so `cjbind` cannot reliably model layouts changed by `#pragma pack`, `__attribute__((packed))`, and similar mechanisms. Packed types are currently skipped instead of generating bindings that are likely to be wrong.

## Bitfields

Bitfields are now supported, but the generated API is not a native field-for-field mapping. Instead, `cjbind` emits hidden storage plus generated getter/setter accessors. In practice this means:

- The generated API shape differs from direct C field access.
- ABI-sensitive cases should still be reviewed manually.
- Packed bitfield structs remain unsupported.

## Unions

Unions are currently emitted as blob storage plus per-field read/write helpers rather than native union syntax. This works for many FFI use cases, but if you depend on subtle aliasing behavior or unusual layout tricks, you should review the generated code manually.

## Macro Evaluation

`cjbind` uses `clang` to evaluate macros when possible, so integer, floating-point, and string literal macros can often be generated successfully. The following cases may still be skipped:

- Function-like macros.
- Complex expressions that `clang` cannot statically evaluate in this context.
- NaN, Infinity, subnormal floating-point values, and other literals that cannot be represented safely in generated Cangjie code.

## Opaque Types

`cjbind` attempts to generate bindings for opaque types while attaching a constructor that always throws exceptions, but users may still create struct instances using `zeroValue`. The memory layout of opaque types is not always guaranteed to be correct, so extra caution is needed when using opaque types. Typically, memory allocation should not be performed on the Cangjie side; instead, pointers returned from the C side should be held.

## Flexible Array Members

Cangjie does not have native syntax for flexible array members, so `cjbind` lowers them to `CPointer<T>`. This keeps the binding usable, but length information, ownership, and allocation rules still need to be handled manually by the caller.

## Calling Convention

`cjbind` attempts to infer the calling convention based on function signatures in the C code, but errors may occur. If you find that the function signature in the binding code is incorrect, you should manually modify the binding code.

Due to unclear documentation in Cangjie regarding the `STDCALL` calling convention, the currently generated calling convention is always `CDECL`. You can track the progress of this issue at [Issue#1595](https://gitcode.com/Cangjie/UsersForum/issues/1595).

## Objective-C Semantics

`--objc` mode already covers interfaces, protocols, categories, properties, methods, nullability, and block parameters, but it mainly solves declaration generation and dispatch bridging. You should still manually review:

- Object ownership and lifetime management.
- Special ABI cases or unusual message-send behavior.
- High-level framework semantics that are not fully expressed by header declarations alone.

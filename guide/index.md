# 简介

**[cjbind](https://github.com/cjbind/cjbind) 可以自动生成 C 的仓颉 FFI 绑定代码。**

例如，假设有如下的 C 头文件 *example.h*:

```c
#ifndef CANGJIE_H
#define CANGJIE_H

typedef enum {
    CAT,
    DOG,
    BIRD
} AnimalType;

typedef struct {
    AnimalType type;
    int age;
    char name[32];
} Animal;

void print_animal(const Animal* animal);

int compute_sum(int a, int b);

#endif
```

使用 cjbind 后，将生成仓颉 FFI 绑定代码，允许你调用 C 库中的函数并使用其类型：

```cangjie
// cjbind 0.1.0 生成，请勿编辑, DO NOT EDIT

package cjbind_ffi

public const AnimalType_CAT: AnimalType = 0
public const AnimalType_DOG: AnimalType = 1
public const AnimalType_BIRD: AnimalType = 2

public type AnimalType = UInt32

@C
public struct Animal {
    public let type_: AnimalType
    public let age: Int32
    public let name: VArray<Int8, $32>

    init(type_: AnimalType, age: Int32, name: VArray<Int8, $32>) {
        this.type_ = type_
        this.age = age
        this.name = name
    }
}

foreign func print_animal(animal: CPointer<Animal>): Unit

foreign func compute_sum(a: Int32, b: Int32): Int32
```
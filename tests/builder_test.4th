\ tests/builder_test.4th
include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th
require ../fhdl.builder.4th

: streq ( addr u addr u -- flag ) COMPARE 0= ;

TESTING Complex Assigns

T{ 
    module: complex_logic
        input-bus: a 8
        input-bus: b 8
        output-bus: sum 8
        output: carry
        
        \ 1. Сложная левая часть с пробелами и запятыми
        \ Обязательно нужен знак '='
        assign: {carry, sum} = a + b
        
        \ 2. Стандартный стиль (можно без пробелов вокруг =)
        assign: x=y
        
        \ 3. Старый стиль без равно (только для простых имен)
        assign: simple ~complex
    end-module

    assign-count @ 
-> 3 }T

\ --- Проверка 1: {carry, sum} ---
T{ 0 NAME_LIMIT * a-lhs + count s" {carry, sum}" streq -> TRUE }T
T{ 0 EXPR_LIMIT * a-rhs + count s" a + b"        streq -> TRUE }T

\ --- Проверка 2: x=y ---
T{ 1 NAME_LIMIT * a-lhs + count s" x" streq -> TRUE }T
T{ 1 EXPR_LIMIT * a-rhs + count s" y" streq -> TRUE }T

\ --- Проверка 3: simple ~complex ---
T{ 2 NAME_LIMIT * a-lhs + count s" simple"   streq -> TRUE }T
T{ 2 EXPR_LIMIT * a-rhs + count s" ~complex" streq -> TRUE }T

CR .( Tests finished successfully! ) CR
bye


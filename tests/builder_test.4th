\ tests/builder_test.4th
include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th
require ../fhdl.builder.4th

\ Переименовали str= в streq, чтобы не конфликтовать с библиотеками Gforth
: streq ( addr u addr u -- flag ) COMPARE 0= ;

TESTING Assign Logic

T{ 
    \ Определяем модуль с assign
    module: logic_gate
        input: a
        input: b
        output: y_and
        output: y_inv
        
        \ ВАЖНО: Комментарии нельзя писать в той же строке, что и assign:,
        \ так как assign: читает строку до конца.
        
        \ С пробелами и равно
        assign: y_and = a & b
        
        \ Без равно
        assign: y_inv ~a
    end-module

    \ Проверяем количество assign
    assign-count @ 
-> 2 }T

\ --- Проверяем первый assign (y_and) ---
T{ 
    \ LHS должно быть "y_and"
    0 NAME_LIMIT * a-lhs + count s" y_and" streq 
-> TRUE }T

T{ 
    \ RHS должно быть "a & b" (без комментариев и мусора)
    0 EXPR_LIMIT * a-rhs + count s" a & b" streq 
-> TRUE }T

\ --- Проверяем второй assign (y_inv) ---
T{ 
    \ LHS -> "y_inv"
    1 NAME_LIMIT * a-lhs + count s" y_inv" streq 
-> TRUE }T

T{ 
    \ RHS -> "~a"
    1 EXPR_LIMIT * a-rhs + count s" ~a" streq 
-> TRUE }T

CR .( Tests finished successfully! ) CR
bye

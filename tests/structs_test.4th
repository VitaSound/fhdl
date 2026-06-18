\ tests/structs_test.4th
include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th
require ../fhdl.structs.4th

: streq ( addr u addr u -- flag ) COMPARE 0= ;

VARIABLE my-head
VARIABLE my-tail
0 my-head ! 
0 my-tail !

\ ==========================================================
TESTING Memory & Strings
\ ==========================================================

T{
    s" Hello" str-dup 
    \ ( new-addr u )
    2dup s" Hello" streq 
    \ ( new-addr u flag )
    -rot 
    \ ( flag new-addr u )
    str-free
    \ ( flag )
-> TRUE }T

\ ==========================================================
TESTING Linked List (Modules)
\ ==========================================================

\ 1. Добавление первого модуля
T{
    module% allocate throw dup >r
    s" mod_one" str-dup r@ mod.name-len ! r@ mod.name-addr !
    0 r@ mod.next !
    
    my-head my-tail r> list-append
    
    my-head @ 0= -> FALSE }T
    
T{  my-tail @ 0= -> FALSE }T
T{  my-head @ my-tail @ = -> TRUE }T

\ 2. Добавление второго модуля
T{
    module% allocate throw dup >r
    s" mod_two" str-dup r@ mod.name-len ! r@ mod.name-addr !
    0 r@ mod.next !
    
    my-head my-tail r> list-append
    
    my-head @ my-tail @ = -> FALSE }T
    
T{  my-head @ mod.next @ my-tail @ = -> TRUE }T

\ 3. Проверка данных
T{
    my-head @ mod.name-addr @ my-head @ mod.name-len @ 
    s" mod_one" streq -> TRUE
}T

T{
    \ Проверка второго модуля через next
    my-head @ mod.next @ 
    dup mod.name-addr @ swap mod.name-len @
    s" mod_two" streq -> TRUE
}T

\ ==========================================================
TESTING Cleanup
\ ==========================================================

T{
    \ Освобождаем первый
    my-head @ mod.name-addr @ my-head @ mod.name-len @ str-free
    my-head @ free throw
    
    \ Освобождаем второй
    my-tail @ mod.name-addr @ my-tail @ mod.name-len @ str-free
    my-tail @ free throw
    
    0 my-head ! 0 my-tail !
    my-head @ -> 0
}T

CR .( Tests passed successfully! ) CR

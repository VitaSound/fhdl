\ tests/params_test.4th
require ~/fmix/forth-packages/ttester/1.2.1/ttester.4th
require ../fhdl.builder.4th
require ../fhdl.utils.4th

reset-builder

\ ==========================================================
TESTING Parameters
\ ==========================================================

s" param_test_mod" module,

\ --- Тест 1: Добавление первого параметра ---
T{
    \ 1. Строка + Строка
    s" 32" s" WIDTH" parameter,
    \ Проверяем, что список не пуст
    current-module @ mod.params-head @ 0= 
-> FALSE }T

\ --- Тест 2: Проверка значений первого параметра ---
T{
    current-module @ mod.params-head @ >r
    \ Проверяем Имя
    r@ param.name-addr @ r@ param.name-len @ s" WIDTH" streq
    \ Проверяем Значение
    r@ param.val-addr @ r@ param.val-len @   s" 32"    streq
    \ Объединяем результаты (оба должны быть TRUE)
    AND
    r> drop
-> TRUE }T

\ --- Тест 3: Добавление и проверка Integer параметра ---
T{
    \ 2. Число + Строка
    16 s" DEPTH" param-int,
    
    \ Берем второй параметр (head -> next)
    current-module @ mod.params-head @ param.next @ >r
    
    r@ param.name-addr @ r@ param.name-len @ s" DEPTH" streq
    r@ param.val-addr @ r@ param.val-len @   s" 16"    streq
    AND
    r> drop
-> TRUE }T

\ --- Тест 4: Добавление и проверка параметра с кавычками ---
T{
    \ 3. Сахар value с кавычками
    value "FAST" name MODE parameter,
    
    \ Берем третий параметр (head -> next -> next)
    current-module @ mod.params-head @ param.next @ param.next @ >r
    
    r@ param.name-addr @ r@ param.name-len @ s" MODE" streq
    
    \ Проверяем значение (оно должно содержать кавычки)
    \ Используем s\" для экранирования кавычек внутри строки Forth
    r@ param.val-addr @ r@ param.val-len @   s\" \"FAST\"" streq
    
    AND
    r> drop
-> TRUE }T

free-all
CR .( Parameters tests passed! ) CR

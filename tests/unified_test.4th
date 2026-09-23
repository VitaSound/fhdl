\ tests/unified_test.4th
require ~/fmix/forth-packages/ttester/1.2.1/ttester.4th
require ../fhdl.builder.4th
require ../fhdl.utils.4th

reset-builder

\ ==========================================================
TESTING Unified List (Modules + Includes)
\ ==========================================================

T{
    \ 1. Добавляем элементы вперемешку
    s" defines.v" include,      \ Node 1: Include
    s" top_alu" module,         \ Node 2: Module
    s" extra_lib.v" include,    \ Node 3: Include
    
    \ Проверяем, что список существует
    items-head @ 0= -> FALSE
}T

\ --- Проверка Узла 1 (Include) ---
T{
    items-head @ >r
    \ Проверяем тип
    r@ inc.type @ NODE_INCLUDE = 
    \ Проверяем путь
    r@ inc.path-addr @ r@ inc.path-len @ s" defines.v" streq 
    AND
    r> drop
-> TRUE }T

\ --- Проверка Узла 2 (Module) ---
T{
    items-head @ inc.next @ >r  \ Берем второй элемент
    \ Проверяем тип
    r@ mod.type @ NODE_MODULE =
    \ Проверяем имя
    r@ mod.name-addr @ r@ mod.name-len @ s" top_alu" streq
    AND
    r> drop
-> TRUE }T

\ --- Проверка Узла 3 (Include) ---
T{
    items-head @ inc.next @ mod.next @ >r \ Берем третий элемент
    \ Проверяем тип
    r@ inc.type @ NODE_INCLUDE =
    \ Проверяем путь
    r@ inc.path-addr @ r@ inc.path-len @ s" extra_lib.v" streq
    AND
    r> drop
-> TRUE }T

CR .( Unified List tests passed! ) CR

\ Генерация для визуальной проверки
generate-verilog,

free-all

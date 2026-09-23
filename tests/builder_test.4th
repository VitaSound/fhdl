\ tests/builder_test.4th
require ~/fmix/forth-packages/ttester/1.2.1/ttester.4th
require ../fhdl.builder.4th
require ../fhdl.utils.4th

\ Сбросим билдер перед тестами
reset-builder

\ ==========================================================
TESTING Builder V3 - Unified List
\ ==========================================================

\ 1. Создание первого модуля
T{
    s" module_A" module,
    
    \ Проверяем, что общий список не пуст
    \ Было: modules-head, Стало: items-head
    items-head @ 0= -> FALSE 
}T

T{
    \ Проверяем, что созданный элемент - это МОДУЛЬ
    items-head @ mod.type @ NODE_MODULE = -> TRUE
}T

T{
    \ Проверяем, что current-module указывает на module_A
    current-module @ mod.name-addr @ current-module @ mod.name-len @
    s" module_A" streq -> TRUE
}T

\ 2. Создание второго модуля
T{
    s" module_B" module,
    
    \ Проверяем целостность списка
    \ items-head (начало) не равно items-tail (конец), значит элементов >= 2
    items-head @ items-tail @ = -> FALSE 
}T

T{
    \ Проверяем, что current-module переключился на module_B
    current-module @ mod.name-addr @ current-module @ mod.name-len @
    s" module_B" streq -> TRUE
}T

T{
    \ Проверяем связь: module_A -> next == module_B
    items-head @ mod.next @ current-module @ = -> TRUE
}T

\ ==========================================================
TESTING Cleanup
\ ==========================================================

T{
    \ В V3 используется free-all
    free-all
    items-head @ -> 0
}T

T{
    current-module @ -> 0
}T

CR .( Builder V3 tests passed successfully! ) CR

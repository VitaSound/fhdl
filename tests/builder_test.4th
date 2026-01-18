\ tests/builder_test.4th
include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th
require ../fhdl.builder.4th

: streq ( addr u addr u -- flag ) COMPARE 0= ;

\ Сбросим билдер перед тестами
reset-builder

\ ==========================================================
TESTING Builder V2 - Modules
\ ==========================================================

\ 1. Создание первого модуля
T{
    s" module_A" module,
    
    \ Проверяем, что список не пуст
    modules-head @ 0= -> FALSE 
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
    \ ОШИБКА БЫЛА ТУТ: используем modules-tail вместо my-tail
    modules-head @ modules-tail @ = -> FALSE 
}T

T{
    \ Проверяем, что current-module переключился на module_B
    current-module @ mod.name-addr @ current-module @ mod.name-len @
    s" module_B" streq -> TRUE
}T

T{
    \ Проверяем связь: module_A -> next == module_B
    modules-head @ mod.next @ current-module @ = -> TRUE
}T

\ ==========================================================
TESTING Cleanup
\ ==========================================================

T{
    free-modules
    modules-head @ -> 0
}T

T{
    current-module @ -> 0
}T

CR .( Builder V2 tests passed successfully! ) CR

\ tests/params_test.4th
include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th
require ../fhdl.builder.4th

: streq ( addr u addr u -- flag ) COMPARE 0= ;
reset-builder

\ ==========================================================
TESTING Parameters
\ ==========================================================

\ Мы не тестируем module, внутри T{}, так как он не возвращает значений на стек
s" design_ip" module,

T{
    \ 1. Добавляем параметры (stack effect: -- )
    s" 32" s" BUS_WIDTH" parameter,
    s" 64" s" DATA_WIDTH" parameter,
    512    s" FIFO_DEPTH" param-int,
    
    \ Проверяем, что параметры добавились (голова списка не 0)
    current-module @ mod.params-head @ 0= -> FALSE
}T

\ Проверка значений первого параметра (BUS_WIDTH)
T{
    current-module @ mod.params-head @ >r
    r@ param.name-addr @ r@ param.name-len @ s" BUS_WIDTH" streq 
    r@ param.val-addr @ r@ param.val-len @   s" 32"        streq 
    AND
    r> drop
-> TRUE }T

\ Проверка значений последнего параметра (FIFO_DEPTH)
T{
    current-module @ mod.params-tail @ >r
    r@ param.name-addr @ r@ param.name-len @ s" FIFO_DEPTH" streq 
    r@ param.val-addr @ r@ param.val-len @   s" 512"        streq 
    AND
    r> drop
-> TRUE }T

CR .( Parameters tests passed! ) CR

\ Генерация вывода для проверки глазами
generate-verilog,

free-modules
bye


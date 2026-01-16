\ tests/localparam_test.4th
include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th
require ../fhdl.builder.4th

: streq ( addr u addr u -- flag ) COMPARE 0= ;
reset-builder

s" test_mod" module,

T{
    s" 10" name P1 parameter,
    s" 20" name L1 localparam,
    
    \ Проверка первого (P1) - is-local должен быть 0
    current-module @ mod.params-head @ param.is-local @ -> 0
}T

T{
    \ Проверка второго (L1) - is-local должен быть 1
    current-module @ mod.params-head @ param.next @ param.is-local @ -> 1
}T

CR .( Localparam tests passed! ) CR

\ Генерация для визуальной проверки
generate-verilog,

free-modules
bye

\ tests/builder_test.4th
include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th
require ../fhdl.builder.4th

: streq ( addr u addr u -- flag ) COMPARE 0= ;

\ ==========================================================
TESTING Parameters Support
\ ==========================================================

T{ 
    module: param_test
        \ Стандартный стиль Verilog
        parameter: WIDTH = 8;
        
        \ Стиль без точки с запятой
        parameter: HEIGHT = 16
        
        \ Стиль без равно (Forth-style)
        parameter: DEPTH 32
        
        \ Параметр-выражение с комментарием
        parameter: AREA = WIDTH * HEIGHT \ Площадь
    end-module

    param-count @ 
-> 4 }T

\ --- 1. WIDTH ---
T{ 0 NAME_LIMIT * param-names + count s" WIDTH" streq -> TRUE }T
T{ 0 EXPR_LIMIT * param-values + count s" 8"    streq -> TRUE }T

\ --- 2. HEIGHT ---
T{ 1 NAME_LIMIT * param-names + count s" HEIGHT" streq -> TRUE }T
T{ 1 EXPR_LIMIT * param-values + count s" 16"    streq -> TRUE }T

\ --- 3. DEPTH (без равно) ---
T{ 2 NAME_LIMIT * param-names + count s" DEPTH" streq -> TRUE }T
T{ 2 EXPR_LIMIT * param-values + count s" 32"   streq -> TRUE }T

\ --- 4. AREA (выражение) ---
T{ 3 NAME_LIMIT * param-names + count s" AREA"           streq -> TRUE }T
T{ 3 EXPR_LIMIT * param-values + count s" WIDTH * HEIGHT" streq -> TRUE }T


\ ==========================================================
TESTING Bus Support (Raw Strings - V7)
\ ==========================================================
\ Проверяем, что диапазоны сохраняются как строки, а не вычисляются

T{
    module: bus_test
        parameter: WIDTH = 32;
        
        \ 1. Шина с выражением Verilog
        input-bus: data [WIDTH-1:0]
        
        \ 2. Шина с явным диапазоном (Little Endian)
        output-bus: debug [0:7]
        
        \ 3. Одиночный бит (input:) должен иметь пустой диапазон
        input: clk
    end-module
    
    port-count @
-> 3 }T

\ --- 1. data [WIDTH-1:0] ---
\ Проверяем имя
T{ 0 NAME_LIMIT * p-names + count s" data" streq -> TRUE }T
\ Проверяем, что диапазон сохранен как строка
T{ 0 RANGE_LIMIT * p-ranges + count s" [WIDTH-1:0]" streq -> TRUE }T

\ --- 2. debug [0:7] ---
T{ 1 NAME_LIMIT * p-names + count s" debug" streq -> TRUE }T
T{ 1 RANGE_LIMIT * p-ranges + count s" [0:7]" streq -> TRUE }T

\ --- 3. clk (single bit) ---
T{ 2 NAME_LIMIT * p-names + count s" clk" streq -> TRUE }T
\ Длина строки диапазона должна быть 0
T{ 2 RANGE_LIMIT * p-ranges + count nip -> 0 }T


\ ==========================================================
TESTING Assign Logic (Regression Test)
\ ==========================================================

T{ 
    module: logic_gate
        input: a
        output: y
        assign: y = ~a;
    end-module
    assign-count @ 
-> 1 }T

CR .( Tests finished successfully! ) CR
bye

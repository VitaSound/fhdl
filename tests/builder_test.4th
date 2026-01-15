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


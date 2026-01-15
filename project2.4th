\ project2.4th

module: logic_demo
    input: sys_clk
    input: a
    input: b
    output: res_and
    output: res_not
    output: res_complex
    inout: tristate

    \ Простые присваивания (можно писать '=' или пропускать его)
    assign: res_and = a & b
    assign: res_not = ~a
    
    \ Сложное выражение (Verilog синтаксис поддерживается, 
    \ так как мы просто копируем текст до конца строки)
    assign: res_complex = (a | b) & ~sys_clk

    assign: y = a & b | (c ^ d)
    assign: y = ~a
    assign: sum = a + b - 1
    assign: res = a * 5
    assign: y = sel ? a : b
    assign: bus = {high_part, low_part}
    assign: broad = {8{a}}
    assign: is_equal = (a == b)
    assign: is_greater = (a > b)

    assign: {carry, sum} = a + b;
    assign: tristate = enable ? data_in : 1'bz
end-module

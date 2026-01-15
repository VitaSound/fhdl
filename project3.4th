\ project3.4th
module: flexible_adder
    \ Параметры
    parameter: WIDTH = 8;
    parameter: INIT_VAL = 0
    parameter: SOME_VAL 1

    \ Используем параметры в шинах (в парсере пока нет eval параметра, 
    \ поэтому ширину указываем числом, но для Verilog это валидно,
    \ если мы добавим поддержку параметра как ширины в будущем.
    \ Пока ширину шины пишем явно числом, так как `input-bus:` делает `evaluate`)
    
    input-bus: a 8
    input-bus: b 8
    output-bus: sum 8
    
    assign: sum = a + b + INIT_VAL;
end-module

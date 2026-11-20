\ project3.4th

\ 1. Глобальный конфиг
s" global_defines.vh" include,

\ 2. Первый модуль
name alu module,
    s" 32" name WIDTH parameter,

\ 3. Инклюд МЕЖДУ модулями (допустимо в Verilog)
s" alu_utils.v" include,

\ 4. Второй модуль
name cpu module,
    s" 64" name DATA_W parameter,

generate-verilog,
free-all

\ project1.4th

\ 1. Создаем первый модуль, передавая строку со стека
s" top_module" module,

\ 2. Создаем второй модуль, используя слово-помощник 'name'
name sub_module_A module,

\ 3. Генерируем Verilog код для всех накопленных модулей
generate-verilog,

\ 4. Очищаем память
free-modules

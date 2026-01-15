\ tests/builder_test.4th
\ Тестирование логики fhdl.builder.4th

\ 1. Подключаем ttester
include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th

\ 2. Подключаем тестируемый модуль (путь относительный)
require ../fhdl.builder.4th

\ Вспомогательное слово для сравнения строк (вернет -1 если равны)
\ : str= ( addr u addr u -- flag )
    \ COMPARE 0= ;

\ ==========================================================
\ TEST SET 1: Пустой модуль
\ ==========================================================
TESTING Empty Module Parsing

T{ 
    \ Выполняем парсинг
    module: empty_mod 
    end-module

    \ Проверяем имя модуля
    mod-name-buf count s" empty_mod" str= 
-> TRUE }T

T{ 
    \ Проверяем количество портов (должно быть 0)
    port-count @ 
-> 0 }T

\ ==========================================================
\ TEST SET 2: Сложный модуль (Порты, шины, атрибуты)
\ ==========================================================
TESTING Complex Module Parsing

T{
    \ Определяем модуль со всеми видами портов
    module: complex_unit
        input: clk
        input: rst
        
        \ Шина ввода
        input-bus: data_in 8
        
        \ Шина вывода (reg)
        reg output-bus: status 4
        
        \ Шина ввода-вывода (signed)
        signed inout-bus: audio 16
        
        \ Сложный случай: reg signed output
        reg signed output: result
    end-module
    
    mod-name-buf count s" complex_unit" str=
-> TRUE }T

\ Проверяем общее количество портов
T{ port-count @ -> 6 }T

\ --- Проверка порта 0 (clk) ---
T{ 0 get-name-addr count s" clk" str= -> TRUE }T  \ Имя
T{ 0 cells p-widths + @ -> 1 }T                   \ Ширина
T{ 0 cells p-types + @  -> 0 }T                   \ Тип (0=input)
T{ 0 cells p-attrs + @  -> 0 }T                   \ Атрибуты (0)

\ --- Проверка порта 2 (data_in) ---
T{ 2 get-name-addr count s" data_in" str= -> TRUE }T
T{ 2 cells p-widths + @ -> 8 }T
T{ 2 cells p-types + @  -> 0 }T                   \ Тип (0=input)

\ --- Проверка порта 3 (status) ---
\ Ожидаем: reg (bit 0 set) -> attrs=1
T{ 3 get-name-addr count s" status" str= -> TRUE }T
T{ 3 cells p-widths + @ -> 4 }T
T{ 3 cells p-types + @  -> 1 }T                   \ Тип (1=output)
T{ 3 cells p-attrs + @  -> 1 }T                   \ Attr (1=reg)

\ --- Проверка порта 4 (audio) ---
\ Ожидаем: signed (bit 1 set) -> attrs=2
T{ 4 get-name-addr count s" audio" str= -> TRUE }T
T{ 4 cells p-widths + @ -> 16 }T
T{ 4 cells p-types + @  -> 2 }T                   \ Тип (2=inout)
T{ 4 cells p-attrs + @  -> 2 }T                   \ Attr (2=signed)

\ --- Проверка порта 5 (result) ---
\ Ожидаем: reg + signed -> attrs = 1 + 2 = 3
T{ 5 get-name-addr count s" result" str= -> TRUE }T
T{ 5 cells p-widths + @ -> 1 }T
T{ 5 cells p-types + @  -> 1 }T                   \ Тип (1=output)
T{ 5 cells p-attrs + @  -> 3 }T                   \ Attr (3=reg+signed)


\ ==========================================================
\ Завершение
\ ==========================================================
CR .( Tests finished successfully! ) CR
bye
\ fhdl.builder.4th
\ V7: Поддержка raw-строк для диапазонов шин (Verilog style)

\ ==========================================================
\ 1. Хранилище данных
\ ==========================================================

100 constant MAX_PORTS
50  constant MAX_ASSIGNS
16  constant MAX_PARAMS     \ Макс. количество параметров
64  constant NAME_LIMIT
64  constant EXPR_LIMIT
64  constant RANGE_LIMIT    \ Макс. длина строки диапазона (например "[WIDTH-1:0]")

create mod-name-buf 256 allot
variable mod-defined   0 mod-defined !

create p-names  MAX_PORTS NAME_LIMIT * allot 
create p-ranges MAX_PORTS RANGE_LIMIT * allot \ Бывший p-widths, теперь храним строки
create p-types  MAX_PORTS cells allot
create p-attrs  MAX_PORTS cells allot
variable port-count    0 port-count !
variable is-reg        0 is-reg !
variable is-signed     0 is-signed !

create a-lhs  MAX_ASSIGNS NAME_LIMIT * allot
create a-rhs  MAX_ASSIGNS EXPR_LIMIT * allot
variable assign-count  0 assign-count !

\ --- Параметры ---
create param-names  MAX_PARAMS NAME_LIMIT * allot
create param-values MAX_PARAMS EXPR_LIMIT * allot
variable param-count   0 param-count !

\ ==========================================================
\ 2. Утилиты обработки строк
\ ==========================================================

: strip-comment ( addr u -- addr u' )
    2dup bounds ?DO
        i c@ 92 = IF drop i over - LEAVE THEN
    LOOP ;

: trim-right ( addr u -- addr u' )
    BEGIN dup 0 > WHILE
        2dup 1- + c@ 32 = IF 1- ELSE EXIT THEN
    REPEAT ;

: trim-left ( addr u -- addr' u' )
    BEGIN dup 0 > WHILE
        over c@ 32 = IF 1 /string ELSE EXIT THEN
    REPEAT ;

: trim ( addr u -- addr' u' )
    trim-left trim-right ;

: strip-semicolon ( addr u -- addr u' )
    dup 0 > IF
        2dup 1- + c@ [char] ; = IF 1- THEN
    THEN ;

\ Удаляет ведущий знак равенства (для параметров)
: strip-equals ( addr u -- addr' u' )
    trim-left
    dup 0 > IF
        over c@ [char] = = IF 
            1 /string trim-left 
        THEN
    THEN ;

: split-by-char ( addr u char -- lhs-a lhs-u rhs-a rhs-u flag )
    >r 2dup r> scan ( addr u found-addr found-u )
    dup 0= IF
        2drop 2drop false
    ELSE
        2dup 1 /string ( addr u found-addr found-u rhs-a rhs-u )
        2>r            ( addr u found-addr found-u ) ( R: rhs-a rhs-u )
        drop nip       ( addr found-addr )
        over -         ( addr lhs-len )
        2r> true
    THEN ;

\ ==========================================================
\ 3. Логика Builder
\ ==========================================================

: reset-builder
    0 mod-defined !
    0 port-count !
    0 assign-count !
    0 param-count !
    0 is-reg !
    0 is-signed ! ;

: get-name-addr ( index -- addr )
    NAME_LIMIT * p-names + ;

: get-range-addr ( index -- addr )
    RANGE_LIMIT * p-ranges + ;

\ Теперь принимает строку диапазона вместо ширины
: register-port ( name-addr name-u range-addr range-u type -- )
    port-count @ MAX_PORTS >= IF
        cr s" [ERROR] Too many ports!" type cr bye
    THEN
    >r \ Сохраняем type на R-стеке
    
    \ Сохраняем строку диапазона (range)
    port-count @ get-range-addr place
    
    \ Сохраняем имя порта (name)
    port-count @ get-name-addr place
    
    \ Сохраняем тип и атрибуты
    r> port-count @ cells p-types + !
    is-reg @ is-signed @ 2 * + port-count @ cells p-attrs + !
    
    \ Сброс флагов и инкремент
    0 is-reg ! 0 is-signed !
    1 port-count +! 
;

: register-assign ( lhs-addr lhs-u rhs-addr rhs-u -- )
    assign-count @ MAX_ASSIGNS >= IF
        cr s" [ERROR] Too many assigns!" type cr bye
    THEN
    assign-count @ EXPR_LIMIT * a-rhs + place
    assign-count @ NAME_LIMIT * a-lhs + place
    1 assign-count +! ;

: register-param ( name-addr name-u val-addr val-u -- )
    param-count @ MAX_PARAMS >= IF
        cr s" [ERROR] Too many parameters!" type cr bye
    THEN
    param-count @ EXPR_LIMIT * param-values + place
    param-count @ NAME_LIMIT * param-names + place
    1 param-count +! ;

\ ==========================================================
\ 4. DSL
\ ==========================================================

warnings off

: module: ( "name" -- )
    parse-name mod-name-buf place
    1 mod-defined !
    0 port-count ! 
    0 assign-count ! 
    0 param-count ! ;

: reg    1 is-reg ! ;
: signed 1 is-signed ! ;

\ Читает остаток строки как диапазон (например "[7:0]")
: parse-range ( -- addr u )
    0 parse strip-comment trim strip-semicolon trim ;

\ Одинарные порты передают пустую строку диапазона
: input:      parse-name s" "          0 register-port ;
: output:     parse-name s" "          1 register-port ;
: inout:      parse-name s" "          2 register-port ;

\ Шинные порты читают диапазон "как есть"
: input-bus:  parse-name parse-range 0 register-port ;
: output-bus: parse-name parse-range 1 register-port ;
: inout-bus:  parse-name parse-range 2 register-port ;

: assign: 
    0 parse strip-comment trim
    strip-semicolon trim
    2dup [char] = split-by-char IF
        trim 2swap trim 2swap register-assign 2drop
    ELSE
        2dup 32 split-by-char IF
            trim 2swap trim 2swap register-assign 2drop
        ELSE
            cr s" [ERROR] Invalid assign format: " type type cr bye
        THEN
    THEN ;

\ parameter: NAME [=] VALUE [;]
: parameter:
    parse-name ( name-addr name-u )
    
    \ Читаем остаток строки (значение)
    0 parse strip-comment trim 
    strip-semicolon trim
    strip-equals    ( value-addr value-u )
    
    register-param ;

: end-module ;

warnings on

\ ==========================================================
\ 5. Генератор Verilog
\ ==========================================================

\ Выводит диапазон, если он есть
: .width ( index -- )
    get-range-addr count 
    dup 0 > IF
        \ Если строка не пустая, выводим её и пробел
        type space 
    ELSE
        2drop
    THEN ;

: .dir ( type -- )
    dup 0 = IF ." input "  drop EXIT THEN
    dup 1 = IF ." output " drop EXIT THEN
    dup 2 = IF ." inout "  drop EXIT THEN
    drop ." wire " ;

: .attrs ( attr -- )
    dup 1 and IF ." reg " THEN
    2 and IF ." signed " THEN ;

: gen-params
    param-count @ 0 ?DO
        cr ."   parameter "
        i NAME_LIMIT * param-names + count type
        ."  = "
        i EXPR_LIMIT * param-values + count type
        ." ;"
    LOOP
;

: gen-header-ports
    port-count @ 0 ?DO
        i get-name-addr count type
        i port-count @ 1- < IF ." , " THEN
    LOOP
;

: gen-decl-ports
    port-count @ 0 ?DO
        cr ."   "
        i cells p-types + @ .dir
        i cells p-attrs + @ .attrs
        
        \ Выводим диапазон (если есть) перед именем
        i .width
        
        i get-name-addr count type
        ." ;"
    LOOP
;

: gen-assigns
    assign-count @ 0 ?DO
        cr ."   assign "
        i NAME_LIMIT * a-lhs + count type
        ."  = "
        i EXPR_LIMIT * a-rhs + count type
        ." ;"
    LOOP
;

: generate-verilog
    cr s" // Generated by FHDL" type cr
    
    s" module " type
    mod-name-buf count type
    s"  (" type 
    gen-header-ports 
    s" );" type       
    
    gen-params       \ <-- Параметры выводятся первыми
    gen-decl-ports
    cr
    gen-assigns
    cr
    
    s" endmodule" type cr
;

\ ==========================================================
\ 6. Точка входа
\ ==========================================================

: run-build ( addr u -- )
    reset-builder

    2dup file-status nip 0= IF
        cr s" [BUILDER] Parsing file: " type 2dup type cr
        ['] included catch dup IF
            cr s" [ERROR] Error parsing file. Code: " type . cr
            2drop drop EXIT
        THEN
        drop
        
        mod-defined @ IF
            generate-verilog
        ELSE
            cr s" [ERROR] No 'module:' found." type cr
        THEN
    ELSE
        cr s" [ERROR] File not found: " type type cr
    THEN
;

\ fhdl.structs.utils.4th
\ Базовые утилиты памяти

\ Утилиты памяти
: str-dup ( addr u -- new-addr u )
    dup allocate throw >r tuck r@ swap move r> swap ;

: str-free ( addr u -- ) drop free throw ;


\ Утилита списка (исправленная и проверенная)
: list-append ( head-var tail-var node -- )
    >r 2dup @ IF
        \ Список не пуст: ( H T H )
        drop nip dup @ r@ swap ! r@ swap !
    ELSE
        \ Список пуст: ( H T H )
        r@ swap ! r@ swap ! drop
    THEN r> drop ;

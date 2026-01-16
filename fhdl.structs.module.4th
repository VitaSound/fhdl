\ fhdl.structs.module.4th
\ Базовые структуры модуля и утилиты памяти

\ ==========================================================
\ 1. Утилиты памяти
\ ==========================================================

\ Копирование строки в Heap (возвращает addr u)
: str-dup ( addr u -- new-addr u )
    dup allocate throw >r   \ ( addr u ) R: ptr
    tuck                    \ ( u addr u )
    r@ swap move            \ ( u )  move(src=addr, dst=ptr, len=u)
    r> swap                 \ ( ptr u )
;

\ Освобождение строки
: str-free ( addr u -- )
    drop free throw ;

\ ==========================================================
\ 2. Утилиты списков (Linked List)
\ ==========================================================

\ Добавление узла в конец списка
\ head-var: адрес переменной головы
\ tail-var: адрес переменной хвоста
\ node: адрес узла (поле .next должно быть первым!)
: list-append ( head-var tail-var node -- )
    >r              \ ( H T ) R: node
    2dup @          \ ( H T H val_T )
    
    IF              \ Список НЕ пуст (val_T != 0)
        \ Stack: H T H
        drop        \ ( H T ) Убираем копию H
        nip         \ ( T )   Убираем H снизу, нам нужен только Tail
        dup @       \ ( T old_tail )
        r@ swap !   \ ( T )   old_tail.next = node
        r@ swap !   \ ( )     tail_var = node
    ELSE            \ Список пуст
        \ Stack: H T H
        r@ swap !   \ ( H T ) head_var = node
        r@ swap !   \ ( H )   tail_var = node
        drop        \ ( )     Очищаем остаток H
    THEN
    r> drop
;

\ ==========================================================
\ 3. Определения структур
\ ==========================================================

begin-structure module%
    field: mod.next         \ Указатель на следующий модуль (Offset 0)
    field: mod.name-addr    
    field: mod.name-len
end-structure


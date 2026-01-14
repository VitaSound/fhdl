\ fhdl.builder.4th
\ Модуль для разбора (build) пользовательских файлов

\ Основное слово, которое будет вызываться из главного файла
\ Вход: ( addr u -- ) - имя файла для обработки
: run-build ( addr u -- )
    2dup file-status nip 0= IF
        \ Файл существует
        cr s" [BUILDER] Found file: " type 2dup type cr
        
        \ --- МЕСТО ДЛЯ БУДУЩЕЙ ЛОГИКИ ---
        \ Здесь мы откроем файл (included или open-file) 
        \ и начнем заполнять структуры.
        \ Пока просто выведем сообщение:
        s" [BUILDER] Parsing logic will be here..." type cr
        2drop 
    ELSE
        \ Файл не найден
        cr s" [ERROR] File not found: " type type cr
    THEN
;

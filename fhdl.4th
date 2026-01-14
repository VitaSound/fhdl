\ fhdl.4th
\ FHDL - Forth HDL Interpreter

require fhdl.reader.4th   \ Чтение конфига package.4th
require fhdl.builder.4th  \ Подключаем логику билдера

2VARIABLE cmd-arg
2VARIABLE param-arg

: read_args
    next-arg 2drop \ Пропуск имени интерпретатора/скрипта
    next-arg cmd-arg 2!
    next-arg param-arg 2!
;

: fhdl.help
    cr s" Usage: fhdl <command>" type cr
    s" Commands:" type cr
    s"    version      - Show version from package.4th" type cr 
    s"    help         - Show this message" type cr cr
;

: fhdl.version
    cr s" ** (fhdl) fhdl v." type 
    \ Используем переменную, заполненную в reader.fs
    pkg-version 2@ type 
    cr cr
;

\ Обработчик команды build
: fhdl.build
    \ Проверяем, есть ли параметр (имя файла)
    param-arg 2@ nip 0= IF
        cr s" Error: 'build' command requires a filename argument." type cr
        s" Example: fhdl build project.4th" type cr
        EXIT
    THEN
    
    \ Передаем имя файла в модуль fhdl.builder.4th
    param-arg 2@ run-build
;

: fhdl ( -- )
    \ Сначала загружаем конфигурацию
    load-config

    read_args

    \ Если аргументов нет
    cmd-arg 2@ nip 0= IF fhdl.help EXIT THEN

    \ Обработка команд
    cmd-arg 2@ s" version" COMPARE 0= IF fhdl.version EXIT THEN
    cmd-arg 2@ s" help"    COMPARE 0= IF fhdl.help    EXIT THEN
    cmd-arg 2@ s" build"   COMPARE 0= IF fhdl.build   EXIT THEN

    \ Ошибка
    s" Unknown command." type cr fhdl.help
;

fhdl bye

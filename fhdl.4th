\ fhdl.4th
\ FHDL - Forth HDL Interpreter

require fhdl.reader.4th   \ Чтение конфига package.4th
require fhdl.builder.4th  \ Подключаем логику билдера

2VARIABLE cmd-arg
2VARIABLE param-arg

: read_args
    s" FHDL_CMD" getenv 2dup nip IF
        cmd-arg 2!
    ELSE
        2drop
        next-arg 2drop \ Пропуск имени интерпретатора/скрипта
        next-arg cmd-arg 2!
    THEN
    s" FHDL_PARAM" getenv 2dup nip IF
        param-arg 2!
    ELSE
        2drop
        next-arg param-arg 2!
    THEN
;

: fhdl.help
    cr
    s" FHDL v" type pkg-version 2@ type
    s"  is a Gforth-based application for generating Verilog project files from Forth definitions." type  cr
    s" Usage: fhdl <command>" type cr
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

\ Look up sd in wid; if found, drop sd, execute the word, return true.
\ Otherwise leave any1+sd and return false.
: obey-wordlist? ( any1 sd wid -- any2 true | any1 sd false )
    >r 2dup r> search-wordlist IF
        nip nip execute true EXIT
    THEN false
;

wordlist constant fhdl.commands
get-current fhdl.commands set-current
    synonym version fhdl.version
    synonym help    fhdl.help
    synonym build   fhdl.build
set-current

: fhdl.dispatch-command ( sd.command -- )
    dup 0= IF 2drop fhdl.help EXIT THEN
    fhdl.commands obey-wordlist? IF EXIT THEN
    s" Unknown command." type cr
    2drop fhdl.help ;

: fhdl ( -- )
    \ Сначала загружаем конфигурацию
    load-config

    read_args
    cmd-arg 2@ fhdl.dispatch-command
;

fhdl bye

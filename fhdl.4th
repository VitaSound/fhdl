include string.fs
include ~/fmix/forth-packages/f/0.2.4/compat-gforth.4th



variable arg-param1
variable arg-param1-size
variable arg-param2
variable arg-param2-size



: get_param1 arg-param1 @ arg-param1-size @ ;
: get_param2 arg-param2 @ arg-param2-size @ ;

0 Value fd-out

: fopen ( c-addr u – wfileid ) w/o create-file throw ;

: fwrite fd-out write-file throw ;
: fwriteln fd-out write-line throw ;

: fclose 
    dup
    flush-file throw
    close-file throw
;

variable def-module-state
\ 0 - module name
\ 1 - ports

create name-string 255 allot
create hdl-module-name-string 255 allot
create hdl-module-ports-string 255 allot
variable hdl-module-ports-count

: module-fwrite 
\ write module to file 
    s" module " fwrite

    s" " hdl-module-name-string $@ s+ fwrite
    s" (" fwrite
    hdl-module-ports-string $@ fwrite
    s" );" fwriteln

    s" endmodule" fwriteln
;

: init-hdl-module
    0 def-module-state !
    s" " hdl-module-ports-string $!
    0 hdl-module-ports-count !
;

: end-prev-hdl-module
    def-module-state @ 0>  IF
        module-fwrite
    THEN
    init-hdl-module
;

: end-prev-hdl-port
    hdl-module-ports-count @ 0>  IF
        hdl-module-ports-string $@
        s" , " $+
        hdl-module-ports-string $!
    THEN

    hdl-module-ports-string $@
    name-string $@
    $+
    hdl-module-ports-string $!
    hdl-module-ports-count @ 1 + hdl-module-ports-count ! \ inc
;

: read_args
    next-arg drop drop \ drop -e
    next-arg arg-param1-size ! arg-param1 !
    next-arg arg-param2-size ! arg-param2 !
;

: name
    parse-name name-string $!
;

: sname
    name-string $!
;

: hdl-module
    end-prev-hdl-module

    \ name-string -> hdl-module-name-string
    name-string $@ hdl-module-name-string $!
    1 def-module-state !
;

: hdl-port
    end-prev-hdl-port

;

: hdl-include
    s\" `include \"" fwrite
    fwrite
    s\" \"" fwriteln
;

: fhdl ( -- )
    read_args

    s" Generate Verilog HDL file" type cr
    s" Input  file: " type get_param1 type cr
    s" Output file: " type get_param2 type cr

    get_param2 fopen to fd-out

    init-hdl-module

    get_param1 included

    end-prev-hdl-module

    fd-out fclose

;

fhdl cr bye


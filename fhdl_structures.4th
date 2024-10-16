\ module structure

[IFUNDEF] module%

variable modules_root
       0 modules_root !

variable current_module_name
    s" " current_module_name $!

variable current_port_name
    s" " current_port_name $!

: module-name-fwrite 
\ write module to file 
    s" module " fwrite

    s" " current_module_name $@ s+ fwrite

    s" ;" fwriteln
    \ s" (" fwrite
    \ hdl-module-ports-string $@ fwrite
    \ s" );" fwriteln
    \ s" ;" fwriteln
;

: module-ports-fwrite 
    s" (" fwrite
    \ hdl-module-ports-string $@ fwrite
    s" );" fwriteln
    \ s" ;" fwriteln
;

: endmodule-fwrite 
    \ module-ports-fwrite
    s" " fwriteln
    s" endmodule" fwriteln
;

: port-data-fwrite
  s" " current_port_name $@ s+ fwrite
  s"  port," fwriteln
;

\ port structure
    struct
        cell% field module-name-text          \ address of counted string module name
        cell% field module-next               \ address of next module
    end-struct module%

\ port structure
    struct
        cell% field port-name-text          \ address of counted string port name
        cell% field port-next               \ address of next port
    end-struct port%

\ : structs_init
\ ;

\ declare module with pre condition
\ example: s" tst1" module, 
: module, current_module_name $! 
  module-name-fwrite
;

\ declare module with post condition
\ example: module tst1
: module parse-name module, ;

: port, current_port_name $!
  port-data-fwrite
;

: port parse-name port, ;

\ end of module declaration
: endmodule, endmodule-fwrite ;

\ alias 
: endmodule endmodule, ;

: input ;
: output ;
: inout ;

[THEN]

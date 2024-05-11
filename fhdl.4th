variable arg-param1
variable arg-param1-size
variable arg-param2
variable arg-param2-size

: get_param1 arg-param1 @ arg-param1-size @ ;
: get_param2 arg-param2 @ arg-param2-size @ ;

include string.fs

: read_args
    next-arg drop drop \ drop -e
    next-arg arg-param1-size ! arg-param1 !
    next-arg arg-param2-size ! arg-param2 !
;


: fhdl ( -- )
    read_args

    get_param1 type cr
    get_param2 type cr

;

fhdl cr bye
\ fmix cr

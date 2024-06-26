\ include ~/fmix/forth-packages/ttester/1.1.0/ttester.4th
include ../forth-packages/ttester/1.1.0/ttester.4th
include ../platforms/generic_platform.4th


\ see examples:
\ https://forth-standard.org/standard/testsuite


create boards_buff 255 allot
create boards_path 255 allot
variable b_wdirid

: boards_get_path
    boards_path $@
;

: board_file_test

    boards_get_path 2swap s+
    2dup
    type

    \ set to default
    s" ../platforms/generic_platform.4th" included 

    included

    DEVICE_PLATFORM $@ s" None" str=
    IF
        s"  - Undef DEVICE_PLATFORM" type cr
    ELSE
        DEVICE_FAMILY $@ s" None" str=
        IF
            s"  - Undef DEVICE_FAMILY" type cr
        ELSE
            s"  - OK" type cr
        THEN
    THEN

;

: board_file_filter
    2dup
    s" 4th" search 
    0= invert IF
        2DROP
        s" * Test file: " type
        board_file_test
    ELSE
        2DROP
        2DROP
    THEN
;

: boards_read_dir
    boards_get_path open-dir
    0= IF
        b_wdirid !

        begin
            boards_buff 255 b_wdirid @ read-dir 

            rot boards_buff swap board_file_filter
            drop
        0= until
    ELSE
        s" ERROR of read ./boards directory" type cr
    THEN
;

    cr
    s" * Boards Tests" type cr

    s" PWD" getenv
    s" /boards/" s+ boards_path $!

    boards_read_dir



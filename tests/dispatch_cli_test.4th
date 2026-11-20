\ tests/dispatch_cli_test.4th — wordlist CLI dispatch smoke

require ~/fmix/forth-packages/ttester/1.2.1/ttester.4th
require ~/fmix/forth-packages/ttester/1.2.1/ttester-ext.4th

: expect-system-ok ( c-addr u -- )
    system $? 0= expect-true ;

s" FHDL_CMD=version gforth fhdl.4th" expect-system-ok
s" FHDL_CMD=help gforth fhdl.4th" expect-system-ok

\ unknown command still exits 0 (prints help), must not crash
s" FHDL_CMD=nosuch gforth fhdl.4th" expect-system-ok

\ build without param prints usage error, still exits 0
s" FHDL_CMD=build gforth fhdl.4th" expect-system-ok

cr ." dispatch_cli_test ok" cr

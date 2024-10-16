
\ s" foo.v" include-verilog;
\ s" bar.v" include-verilog;

\ include-verilog bazz.v

\ name tst1 hdl-module
\     name a hdl-port
\     name b hdl-port
\     name c hdl-port

\ name tst2 hdl-module

\ s" tst3" sname  hdl-module

module tst1
    input port a
    input port b
    output port a
endmodule

s" tst2" module,
endmodule

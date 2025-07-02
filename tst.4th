
\ s" foo.v" include-verilog;
\ s" bar.v" include-verilog;

\ include-verilog bazz.v

\ name tst1 hdl-module
\     name a hdl-port
\     name b hdl-port
\     name c hdl-port

\ name tst2 hdl-module

\ s" tst3" sname  hdl-module

\ input  [net_type] [range] list_of_names; // Input port
\ inout  [net_type] [range] list_of_names; // Input & Output port
\ output [net_type] [range] list_of_names; // Output port driven by a wire
\ output [var_type] [range] list_of_names; // Output port driven by a variable


module tst1
    moduleports
        input a
        input b
        output c
        inout d
        s" f" ,output
    endmoduleports
endmodule

s" tst2" module,
endmodule

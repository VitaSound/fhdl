\ project2.4th

name design_ip module,
    
    \ Определение параметров как в примере
    s" 32"  name BUS_WIDTH  parameter,
    s" 64"  name DATA_WIDTH parameter,
    s" 512" name FIFO_DEPTH parameter,
    256 (.) name PAR1 parameter,
    value 128 name PAR2 parameter,
    value PAR1 name PAR3 parameter,
    value "STR" name PAR4 localparam,
    

generate-verilog,
free-modules

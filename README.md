# fhdl

FORTH to verilog generator

```
alias fhdl='gforth ~/fhdl/fhdl.4th -e'
```

## Test conversion

```
fhdl tst.4th tst.v
```

Input file

```
s" foo.v" hdl-include
s" bar.v" hdl-include

name tst1 hdl-module
    name a hdl-port
    name b hdl-port
    name c hdl-port

name tst2 hdl-module

s" tst3" sname  hdl-module
```

Output file
```
`include "foo.v"
`include "bar.v"
module tst1(a, b, c);
endmodule
module tst2();
endmodule
module tst3();
endmodule
```

## Features

 * Create module
 * Create port names
 * Include .v files

## Installation

For install dependecies

```forth
   fmix packages.get
```

fpath path+ ./forth-packages/ffl/ffl-0-8-0

include ffl/config.fs
include ffl/frc.fs
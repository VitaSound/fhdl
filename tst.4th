include ./boards/ebaz4205.4th

s" Device platform: " type DEVICE_PLATFORM $@ type cr
s" Device family: " type DEVICE_FAMILY $@ type cr

s" foo.v" hdl-include
s" bar.v" hdl-include

name tst1 hdl-module
    name a hdl-port
    name b hdl-port
    name c hdl-port

name tst2 hdl-module

s" tst3" sname  hdl-module
include ../generic_platform.4th

s" XilinxPlatform" DEVICE_PLATFORM $!

[IFUNDEF] xilinx_platform
    variable xilinx_platform \ defined
    : XilinxSpartan6Platform s" spartan6" DEVICE_FAMILY $! ;
    : Xilinx7SeriesPlatform  s" 7series" DEVICE_FAMILY $! ;
    : XilinxUSPlatform s" ultrascale" DEVICE_FAMILY $! ;
    : XilinxUSPPlatform s" ultrascale+" DEVICE_FAMILY $! ;
[THEN]

supported-toolchains
    device-toolchain spartan6 ise
    device-toolchain 7series vivado
    device-toolchain 7series f4pga
    device-toolchain 7series yosys+nextpnr
    device-toolchain 7series openxc7
    device-toolchain ultrascale  vivado
    device-toolchain ultrascale+ vivado
end-supported-toolchains


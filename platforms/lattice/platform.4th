include ../generic_platform.4th

s" LatticePlatform" DEVICE_PLATFORM $!

[IFUNDEF] lattice_platform
    variable lattice_platform \ defined
    : LatticeiCE40Platform s" ice40" DEVICE_FAMILY $! ;
    : LatticeECP5Platform  s" ecp5" DEVICE_FAMILY $! ;
    : LatticeNexusPlatform s" nexus" DEVICE_FAMILY $! ;
    : LatticeMachXO3Platform s" MachXO3" DEVICE_FAMILY $!  ;
[THEN]

supported-toolchains
    device-toolchain ice40 icestorm
    device-toolchain ecp5 trellis
    device-toolchain ecp5 diamond
    device-toolchain nexus radiant
    device-toolchain nexus oxide
end-supported-toolchains

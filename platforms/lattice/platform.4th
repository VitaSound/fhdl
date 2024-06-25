include ../generic_platform.4th

name LatticePlatform hdl-platform

supported-toolchains
    device-toolchain ice40 icestorm
    device-toolchain ecp5 trellis
    device-toolchain ecp5 diamond
    device-toolchain nexus radiant
    device-toolchain nexus oxide
end-supported-toolchains

name LatticePlatform hdl-platform

\ # LatticeiCE40Platform -----------------------------------------------------------------------------

\ class LatticeiCE40Platform(LatticePlatform):
\     device_family = "ice40"

\ # LatticeECP5Platform ------------------------------------------------------------------------------

\ class LatticeECP5Platform(LatticePlatform):
\     device_family = "ecp5"

\ # LatticeNexusPlatform -----------------------------------------------------------------------------

\ class LatticeNexusPlatform(LatticePlatform):
\     device_family = "nexus"
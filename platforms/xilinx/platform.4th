include ../generic_platform.4th

name XilinxPlatform hdl-platform

supported-toolchains
    device-toolchain spartan6 ise
    device-toolchain 7series vivado
    device-toolchain 7series f4pga
    device-toolchain 7series yosys+nextpnr
    device-toolchain 7series openxc7
    device-toolchain ultrascale  vivado
    device-toolchain ultrascale+ vivado
end-supported-toolchains

\ _supported_toolchains = {
\     "spartan6"    : ["ise"],
\     "7series"     : ["vivado", "f4pga", "yosys+nextpnr", "openxc7"],
\     "ultrascale"  : ["vivado"],
\     "ultrascale+" : ["vivado"],
\ }

\ # XilinxSpartan6Platform ---------------------------------------------------------------------------

\ class XilinxSpartan6Platform(XilinxPlatform):
\     device_family = "spartan6"

\ # Xilinx7SeriesPlatform ----------------------------------------------------------------------------

\ class Xilinx7SeriesPlatform(XilinxPlatform):
\     device_family = "7series"

\ # XilinxUSPlatform ---------------------------------------------------------------------------------

\ class XilinxUSPlatform(XilinxPlatform):
\     device_family = "ultrascale"

\ # XilinxUSPPlatform --------------------------------------------------------------------------------

\ class XilinxUSPPlatform(XilinxPlatform):
\     device_family = "ultrascale+"
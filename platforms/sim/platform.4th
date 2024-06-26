include ../generic_platform.4th

s" SimPlatform" DEVICE_PLATFORM $!
s" Sim" DEVICE_FAMILY $!

supported-toolchains
    device-toolchain sim verilator
end-supported-toolchains

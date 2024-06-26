include ../generic_platform.4th

s" GowinPlatform" DEVICE_PLATFORM $!
s" Gowin" DEVICE_FAMILY $!

supported-toolchains
    device-toolchain gowin gowin
    device-toolchain gowin apicula
end-supported-toolchains

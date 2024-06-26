include ../generic_platform.4th

s" MicrosemiPlatform" DEVICE_PLATFORM $!
s" Microsemi" DEVICE_FAMILY $!

supported-toolchains
    device-toolchain microsemi libero_soc_polarfire
end-supported-toolchains

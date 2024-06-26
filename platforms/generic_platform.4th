[IFUNDEF] generic_platform

    variable generic_platform \ defined
    create DEVICE_PLATFORM 255 allot
    create DEVICE_FAMILY 255 allot

    : supported-toolchains ;
    : end-supported-toolchains ;
    : device-toolchain parse-name drop drop parse-name drop drop ;

[THEN]

\ init
s" None" DEVICE_PLATFORM $!
s" None" DEVICE_FAMILY $!
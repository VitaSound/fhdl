[IFUNDEF] generic_platform

    variable generic_platform \ defined
    create DEVICE_PLATFORM 255 allot
    create DEVICE_FAMILY 255 allot

    : supported-toolchains ;
    : end-supported-toolchains ;
    : device-toolchain parse-name drop drop parse-name drop drop ;

    : IOs parse-name drop drop ;
    : end-IOs ;
    : Signal parse-name drop drop ;
    : Subsignal parse-name drop drop ;
    : Index parse-name drop drop ;
    : Pin parse-name drop drop ;
    : Pins drop drop ;
    : IOStandard parse-name drop drop ;

[THEN]

\ init
s" None" DEVICE_PLATFORM $!
s" None" DEVICE_FAMILY $!
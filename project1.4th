\ project1.4th

module: top_system
    \ Обычные порты
    input: sys_clk
    input: sys_rst

    \ двунаправленный порт
    inout: dat
    
    \ Вход со знаком
    signed input-bus: audio_in 16

    \ Выход типа reg (для использования в always блоках)
    reg output: status_led
    
    \ Выход типа reg со знаком (сложный случай)
    reg signed output-bus: calc_res 32
    
    \ Обычный провод
    output-bus: simple_data 8
end-module
\ fhdl.structs.parameter.4th
\ Базовые структуры параметров

\ Структура ПАРАМЕТРА
begin-structure param%
    field: param.next
    field: param.name-addr  
    field: param.name-len
    field: param.val-addr   
    field: param.val-len
    field: param.is-local   \ 0 = parameter, 1 = localparam
end-structure

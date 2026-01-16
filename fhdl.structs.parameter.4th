\ fhdl.structs.parameter.4th
\ Базовые структуры параметров

\ Структура ПАРАМЕТРА
begin-structure param%
    field: param.next       \ Указатель на следующий (0)
    field: param.name-addr  field: param.name-len
    field: param.val-addr   field: param.val-len
end-structure

\ Обновленная структура МОДУЛЯ
begin-structure module%
    field: mod.next         \ Next module
    field: mod.name-addr    
    field: mod.name-len
    
    \ Списки
    field: mod.params-head  field: mod.params-tail
    \ (сюда потом добавятся порты)
end-structure

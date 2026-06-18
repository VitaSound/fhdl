\ fhdl.structs.module.4th

begin-structure module%
    field: mod.next
    field: mod.name-addr    
    field: mod.name-len
    
    \ Списки параметров
    field: mod.params-head  
    field: mod.params-tail
    
    \ Списки портов
    field: mod.ports-head   
    field: mod.ports-tail
    
    \ Списки assign
    field: mod.assigns-head
    field: mod.assigns-tail
end-structure

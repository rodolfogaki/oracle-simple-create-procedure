## oracle-simple-create-procedure
###### exec: 
```
DECLARE
  v_id_retorno NUMBER;
  v_retorno    VARCHAR2(100);
BEGIN
    sp_validar_maior_idade (
        p_id_pessoa  => 1
       ,p_id_retorno => v_id_retorno
       ,p_retorno    => v_retorno
    );
    --
    dbms_output.put_line(v_id_retorno||' - '||v_retorno);
END;
```
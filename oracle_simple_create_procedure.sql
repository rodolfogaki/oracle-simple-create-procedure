CREATE OR REPLACE PROCEDURE sp_validar_maior_idade (
  p_id_pessoa  IN  NUMBER,
  p_id_retorno OUT NUMBER,
  p_retorno    OUT VARCHAR2) IS
  --
  v_id_pessoa     NUMBER        := p_id_pessoa;
  v_id_retorno    NUMBER        := 0; --retornando 0 então ok.
  v_retorno       VARCHAR2(100) := null;
  v_dt_nascimento pessoa.dt_nascimento%type;
  v_status        pessoa.status%type;
  --
BEGIN
  IF (v_id_pessoa is null) THEN
    v_id_retorno := 1;
    v_retorno    := 'Necessário informar o código da pessoa.';
  END IF;
  --
  IF (v_id_retorno = 0) THEN
    BEGIN
      select a.dt_nascimento
            ,a.status
        into v_dt_nascimento
            ,v_status
        from pessoa a 
       where 1=1
         and a.id_pessoa = v_id_pessoa
        ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_id_retorno := 2;
        v_retorno    := 'Nenhum registro encontrado para o código: '||v_id_pessoa||'.';
      WHEN OTHERS THEN
        v_id_retorno := 3;
        v_retorno    := 'Erro não tratado na busca por pessoa: '||sqlerrm;
    END;
    --
    IF (v_id_retorno = 0) THEN
      IF (v_status = 'I') THEN
        v_id_retorno := 4;
        v_retorno    := 'Pessoa está inativa.';
      ELSIF (trunc(months_between(sysdate,v_dt_nascimento)/12) < 18) THEN
        v_id_retorno := 5;
        v_retorno    := 'Pessoa é de menor idade.';
      ELSE
        v_retorno    := 'Validação ok, pessoa é de maior idade.';
      END IF;
    END IF;
  END IF;
  --
  p_id_retorno := v_id_retorno;
  p_retorno    := v_retorno;
  --
EXCEPTION
  WHEN OTHERS THEN
     p_id_retorno := 999;
     p_retorno    := 'Erro não tratado: '||sqlerrm;
END sp_validar_maior_idade;

/*
-- CRIACAO DE TABELAS
CREATE TABLE pessoa (
    id_pessoa NUMBER(11) NOT NULL,
    nome_completo VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    dt_nascimento DATE NOT NULL,
    sexo VARCHAR2(1) NOT NULL,
    status VARCHAR2(1) NOT NULL, --I=INATIVO,A=ATIVO
    PRIMARY KEY (id_pessoa)
);

-- INCLUSAO DE INFORMACOES
insert into pessoa values (1,'João Henrique da Silva','joaohs@joaohs.com',to_date('01/01/1990','dd/mm/yyyy'),'M','A');
insert into pessoa values (2,'Ana Patrícia Monteiro Dias','anapmd@anapmd.com',to_date('05/05/2006','dd/mm/yyyy'),'F','A');
insert into pessoa values (3,'Carlos José Pinheiro','carlosjp@carlosjp.com',to_date('05/05/2006','dd/mm/yyyy'),'M','I');
*/
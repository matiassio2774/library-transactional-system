DECLARE

  PARAMETRO NUMBER;
  vregistros SYS_REFCURSOR;
  vid Biblioteca.Clientes.cli_codigo%TYPE;
  vnombre Biblioteca.Clientes.cli_nombre%TYPE;

BEGIN

--  1= En mora | 2= Suspendidos | 3= Total
  PARAMETRO := 1;
  Biblioteca.BIBLIO_PKG.sp_listar_clientes(parametro,vregistros);

  LOOP
      FETCH vregistros INTO vid, vnombre;
      EXIT WHEN vregistros%NOTFOUND;
      Dbms_Output.put_line('ID: ' || vid || ' - Nombre: ' || vnombre );
  END LOOP;

END;

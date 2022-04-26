
DECLARE

  PARAMETRO NUMBER;
  vregistros SYS_REFCURSOR;
  vid Biblioteca.Prestamos.pre_cliente%TYPE;
  vfecha Biblioteca.Prestamos.pre_fecha%TYPE;


BEGIN

--  0= lista total | 1= prestamos por cliente | 2= morosos
  PARAMETRO := 1;
  vid :=10;
  Biblioteca.BIBLIO_PKG.sp_mostrar_prestamo(parametro,vregistros,vid);

  LOOP
      FETCH vregistros INTO vid,vfecha;
      EXIT WHEN vregistros%NOTFOUND;

      Dbms_Output.put_line('ID Prestamo: ' || vid || ' - Fecha de entrega:  ' || vfecha );

  END LOOP;

END;



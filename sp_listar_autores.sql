--- Listar Autores

DECLARE

  PARAMETRO NUMBER;
  vregistros SYS_REFCURSOR;
  vnombre Biblioteca.Autores.aut_nombre%TYPE;
  vid Biblioteca.Autores.aut_codigo%TYPE;
  vpli_libro Biblioteca.Prestamos_Libros.pli_libro%TYPE;
  xcount NUMBER;
  vfecha1 DATE;
  vfecha2 DATE;

BEGIN

--  1= sin orden. | 0=  ordena los autores por cantidad de libros en préstamo, entre dos fechas
  PARAMETRO := 0;
  vfecha1 := '15/11/2021'; --ESTA FECHA TIENE QUE SER LA FINAL
  vfecha2 := '20/10/2021'; --ESTA ES LA INICIAL

  Biblioteca.BIBLIO_PKG.sp_listar_autores(parametro,vregistros,vfecha1,vfecha2);

  LOOP
      FETCH vregistros INTO vpli_libro,vnombre,vid,xcount;
      EXIT WHEN vregistros%NOTFOUND;

      Dbms_Output.put_line('ID: ' || vid || '   -- Nombre: ' || vnombre || '   -- Cantidad de prestamos: '||xcount);

  END LOOP;

END;

SELECT * FROM biblioteca.prestamos_libros

COMMIT;


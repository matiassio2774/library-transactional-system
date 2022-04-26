DECLARE

  PARAMETRO NUMBER;
  vregistros SYS_REFCURSOR;
  vlibro Biblioteca.Libros.lib_descripcion%TYPE;
  vcantidad Biblioteca.Libros.lib_cantidad%TYPE;
  vid Biblioteca.Libros.lib_codigo%TYPE;

BEGIN

--  1= ordenado | 0= sin orden
  PARAMETRO := 0;
  Biblioteca.BIBLIO_PKG.sp_listar_libros(parametro,vregistros);

  LOOP
      FETCH vregistros INTO vlibro, vcantidad, vid;
      EXIT WHEN vregistros%NOTFOUND;

      Dbms_Output.put_line('ID: ' || vid || ' - Libro: ' || vlibro || ' - Stock: '||vcantidad);

  END LOOP;

END;

COMMIT;
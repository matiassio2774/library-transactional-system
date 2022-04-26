 DECLARE

  PARAMETRO NUMBER;
  vregistros SYS_REFCURSOR;
  vid_libro Biblioteca.Libros.lib_codigo%TYPE;
  vid_cliente Biblioteca.Clientes.cli_codigo%TYPE;
  vpre_dias Biblioteca.Prestamos_Libros.pli_dias%TYPE;
  vlibro Biblioteca.Prestamos_Libros.pli_libro%TYPE;
  vnombre Biblioteca.Libros.lib_descripcion%TYPE;

BEGIN

  vid_libro := 4;   --Libro a pedir
  vid_cliente :=9; --Cliente prestamo
  vpre_dias := 4;   --Dias prestamo
  PARAMETRO := 1;

  Biblioteca.BIBLIO_PKG.sp_realizar_prestamo(PARAMETRO,vregistros,vid_libro,vid_cliente,vpre_dias);

END;

DECLARE

  vid_cliente Biblioteca.Clientes.cli_codigo%TYPE;
  vid_libro Biblioteca.Libros.lib_codigo%TYPE;

BEGIN

  vid_libro :=9;   --Libro a devolver
  vid_cliente :=4; --Cliente id

  Biblioteca.BIBLIO_PKG.sp_devoluciones(vid_cliente,vid_libro);

END;

SELECT * FROM Biblioteca.Prestamos;
SELECT * FROM Biblioteca.Prestamos_Libros;

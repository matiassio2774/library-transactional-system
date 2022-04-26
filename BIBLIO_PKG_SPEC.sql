CREATE OR REPLACE PACKAGE biblio_pkg AS

  PROCEDURE sp_listar_clientes(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR);

  PROCEDURE sp_listar_autores(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR, FECHA1 IN DATE, FECHA2 IN DATE);

  PROCEDURE sp_realizar_prestamo(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR, id_libro Biblioteca.Libros.lib_codigo%TYPE, id_cliente Biblioteca.Clientes.cli_codigo%TYPE, pre_dias Biblioteca.Prestamos_Libros.pli_dias%TYPE);

  PROCEDURE sp_listar_libros(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR);

  PROCEDURE sp_mostrar_prestamo(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR, id_cliente Biblioteca.Prestamos.pre_cliente%TYPE);

  PROCEDURE sp_devoluciones(id_cliente Biblioteca.Clientes.cli_codigo%TYPE, id_libro Biblioteca.Libros.lib_codigo%TYPE);

END BIBLIO_PKG;




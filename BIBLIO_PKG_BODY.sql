CREATE OR REPLACE PACKAGE BODY biblio_pkg AS

--- Listar Libros
	PROCEDURE sp_listar_libros(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR) IS

    CONSULTA VARCHAR(100);

	BEGIN

      CONSULTA := 'SELECT lib_descripcion, lib_cantidad, lib_codigo FROM Biblioteca.Libros ';

      IF (PARAMETRO=1) THEN

        CONSULTA := CONSULTA || 'ORDER BY lib_cantidad DESC';

      ELSIF (PARAMETRO=0) THEN

        CONSULTA := CONSULTA;

      END IF;

        OPEN REGISTROS FOR CONSULTA;

  END sp_listar_libros;

--- Listar Autores
	PROCEDURE sp_listar_autores(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR, FECHA1 IN DATE, FECHA2 IN DATE) IS

    CONSULTA VARCHAR(900);

	BEGIN

      CONSULTA := 'SELECT PL.pli_libro,A.aut_nombre, A.aut_codigo, Count(*) FROM Biblioteca.Autores A
      INNER JOIN Biblioteca.Libros_Autores LA ON A.aut_codigo=LA.lau_autor
      INNER JOIN Biblioteca.Libros L ON LA.lau_libro = L.lib_codigo
      INNER JOIN Biblioteca.Prestamos_Libros PL ON PL.pli_libro = L.lib_codigo
      INNER JOIN Biblioteca.Prestamos P ON PL.pli_prestamo = P.pre_numero ';

      IF (PARAMETRO=1) THEN -- Listado de autores

        CONSULTA := CONSULTA||' GROUP BY
                                  PL.pli_libro,
                                  A.aut_nombre,
                                  A.aut_codigo
                                ORDER BY A.aut_codigo';

      ELSIF (PARAMETRO=0) THEN  -- Listado que ordena los autores por cantidad de libros en préstamo, entre dos fechas.

                                                                                    -- CHR(39) son las comillas simples en ASCII

        CONSULTA := CONSULTA||' WHERE L.lib_codigo = PL.pli_libro AND P.pre_fecha<='||chr(39)||FECHA1||Chr(39)||' AND P.pre_fecha>='||Chr(39)||FECHA2||Chr(39)||'
                                GROUP BY
                                  PL.pli_libro,
                                  A.aut_nombre,
                                  A.aut_codigo

                                ORDER BY Count(1) DESC';

      END IF;


        OPEN REGISTROS FOR CONSULTA;

  END sp_listar_autores;

  PROCEDURE sp_realizar_prestamo(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR, id_libro Biblioteca.Libros.lib_codigo%TYPE, id_cliente Biblioteca.Clientes.cli_codigo%TYPE, pre_dias Biblioteca.Prestamos_Libros.pli_dias%TYPE) IS
    fechahoy DATE;
    fecha_prestamo DATE;
    cantlibros_cliente NUMBER;
    mismolibro_cliente NUMBER;
    fechamora NUMBER;
    stock_libro NUMBER;
    cantidad NUMBER;
    fechapre DATE;
    maxdiaspre NUMBER;
    moroso NUMBER;
    estado_cliente NUMBER;
    precio_pre NUMBER;
    precio_libro NUMBER;
    lib_valor NUMBER;
    lib_precio NUMBER;
    suspendido DATE;
  BEGIN

        SELECT Trunc(SYSDATE) INTO fechahoy FROM DUAL;

        SELECT Count(*) INTO cantidad
          FROM Biblioteca.Libros L
            INNER JOIN Biblioteca.Prestamos_Libros PL ON L.lib_codigo = PL.pli_libro
            INNER JOIN Biblioteca.Prestamos P ON PL.pli_prestamo = P.pre_numero
          WHERE lib_codigo = id_libro AND P.pre_fecha <= fechahoy+3 AND L.lib_cantidad = 1;

        SELECT C.cli_suspendido
        INTO suspendido
        FROM Biblioteca.Clientes C
        WHERE id_cliente = C.cli_codigo;

        IF (cantidad < 1) THEN

          maxdiaspre :=15;

        ELSIF (cantidad >=1) THEN

          maxdiaspre :=7;

        END IF;

        estado_cliente := 0; -- EN PRESTAMO. 1= DEVUELTO

      IF (suspendido IS NULL OR suspendido<fechahoy) THEN

          SELECT Count(*) INTO cantlibros_cliente
          FROM Biblioteca.Clientes C
          INNER JOIN Biblioteca.Prestamos P ON C.cli_codigo = P.pre_cliente
          WHERE C.cli_codigo = id_cliente;

        IF (cantlibros_cliente < 3) THEN

            SELECT Count(*)
            INTO mismolibro_cliente
            FROM Biblioteca.Libros L
            INNER JOIN Biblioteca.Prestamos_Libros PL ON L.lib_codigo = PL.pli_libro
            INNER JOIN Biblioteca.Prestamos P ON PL.pli_prestamo = P.pre_numero
            INNER JOIN Biblioteca.Clientes C ON P.pre_cliente = C.cli_codigo
            WHERE C.cli_codigo = id_cliente AND PL.pli_libro = id_libro;

              IF (mismolibro_cliente =0) THEN



                SELECT Count(*)
                INTO fechamora
                FROM Biblioteca.Clientes C
                INNER JOIN Biblioteca.Prestamos P ON C.cli_codigo = P.pre_cliente
                INNER JOIN BIblioteca.Prestamos_Libros PL ON P.pre_numero = PL.pli_prestamo
                WHERE
                P.pre_fecha < fechahoy AND
                C.cli_codigo = id_cliente;

                fecha_prestamo := fechahoy + pre_dias;



                IF (fechamora=0) THEN

                  SELECT lib_cantidad
                  INTO stock_libro
                  FROM Biblioteca.Libros L
                  WHERE L.lib_codigo = id_libro;

                  IF (stock_libro >0) THEN

                    SELECT Count(*)
                    INTO moroso
                    FROM Biblioteca.Clientes C
                    INNER JOIN Biblioteca.Prestamos P ON C.cli_codigo = P.pre_cliente
                    INNER JOIN Biblioteca.Prestamos_Libros PL ON P.pre_numero = PL.pli_prestamo
                    WHERE C.cli_codigo = id_cliente AND fechahoy > pre_fecha;

                    IF(moroso < 1 AND pre_dias <= maxdiaspre) THEN

                      SELECT Biblioteca.Libros.lib_precio
                      INTO lib_precio
                      FROM Biblioteca.Libros
                      WHERE lib_codigo = id_libro;

                    BEGIN

                        lib_valor := lib_precio;

                        UPDATE Biblioteca.Libros
                          SET lib_cantidad = lib_cantidad-1,
                          lib_precio = lib_precio * 1.10
                        WHERE lib_codigo = id_libro;

                        INSERT INTO Biblioteca.Prestamos (pre_cliente,pre_fecha,pre_observacion)
                        VALUES (''||id_cliente||'',fecha_prestamo,'obs');


                        INSERT INTO Biblioteca.Prestamos_Libros (pli_libro,pli_estado,pli_dias,pli_valor,pli_multa)
                        VALUES (id_libro,estado_cliente,pre_dias,lib_valor,0);

                        EXCEPTION
                          WHEN No_Data_Found THEN
                          Dbms_Output.put_line('Mensaje de Error :'||SQLERRM);
                          Dbms_Output.put_line('Codigo de Error :'||SQLCODE);
                    END;

                      Dbms_Output.put_line('¡Prestamo realizado!');

                    ELSE

                      Dbms_Output.put_line('No puede realizar el prestamo porque el cliente está en mora o cantidad de dias incorrecta..');

                    END IF;

                  ELSE

                  Dbms_Output.put_line('No puede realizar el prestamo porque no hay stock del libro elegido..');

                  END IF;

                ELSE

                Dbms_Output.put_line('No puede realizar el prestamo porque el cliente esta en mora.');

                END IF;

              ELSE

              Dbms_Output.put_line('No puede realizar el prestamo porque el cliente ya tiene este libro.');

              END IF;
        ELSE

        Dbms_Output.put_line('No puede realizar el prestamo porque el cliente tiene 3 libros en prestamo.');

        END IF;
      ELSE
              Dbms_Output.put_line('No puede realizar el prestamo porque el cliente esta suspendido.');

      END IF;
  END sp_realizar_prestamo;

--- Listar Clientes
	PROCEDURE sp_listar_clientes(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR) IS

    CONSULTA VARCHAR(500);
    fechahoy DATE;
	BEGIN

      -- Debe obtener los listados de clientes, los clientes en mora, los
      --    suspendidos y lista total.


      CONSULTA := '
      SELECT DISTINCT C.cli_codigo, C.cli_nombre
      FROM Biblioteca.Clientes C
      ';

      IF (PARAMETRO=1) THEN -- Clientes mora

      SELECT Trunc(SYSDATE) INTO fechahoy FROM DUAL;
      CONSULTA:=CONSULTA||' INNER JOIN Biblioteca.Prestamos P ON C.cli_codigo = P.pre_cliente WHERE P.pre_fecha<'|| Chr(39) || fechahoy || Chr(39);

      END IF;

      IF (PARAMETRO=2) THEN -- Clientes suspendidos
            SELECT Trunc(SYSDATE) INTO fechahoy FROM DUAL;
      CONSULTA:=CONSULTA||' WHERE C.cli_suspendido>'|| Chr(39) || fechahoy || Chr(39);
      END IF;

      IF (PARAMETRO=3) THEN -- Lista Total
        CONSULTA := CONSULTA;
      END IF;

        OPEN REGISTROS FOR CONSULTA;

  END sp_listar_clientes;

  PROCEDURE sp_mostrar_prestamo(PARAMETRO IN NUMBER, REGISTROS OUT SYS_REFCURSOR, id_cliente Biblioteca.Prestamos.pre_cliente%TYPE) IS

    CONSULTA VARCHAR(500);
    fechahoy DATE;

  BEGIN
          SELECT Trunc(SYSDATE) INTO fechahoy FROM DUAL;


      -- Funcionalidad que permite retornar prestamos en vigencia por
      -- cliente, o listado total. También debe poder devolver listado de morosos.
      CONSULTA := '
          SELECT
           P.pre_numero
          ,P.pre_fecha
          FROM Biblioteca.Prestamos P
          INNER JOIN Biblioteca.Prestamos_Libros PL ON P.pre_numero = PL.pli_prestamo
          ';

    IF (PARAMETRO=0) THEN -- Listado Total

    CONSULTA := CONSULTA;

    END IF;

    IF (PARAMETRO=1) THEN -- Listado prestamos en vigencia por Cliente

    CONSULTA := CONSULTA || ' INNER JOIN Biblioteca.Clientes C ON P.pre_cliente = C.cli_codigo WHERE C.cli_codigo = '||id_cliente||'';

    END IF;

    IF (PARAMETRO=2) THEN -- Listado de morosos

    CONSULTA := 'SELECT
           P.pre_numero
          ,P.pre_fecha
          FROM Biblioteca.Prestamos P WHERE P.pre_fecha<'|| Chr(39) || fechahoy || Chr(39);

    END IF;

    OPEN REGISTROS FOR CONSULTA;

  END sp_mostrar_prestamo;

  PROCEDURE sp_devoluciones(id_cliente Biblioteca.Clientes.cli_codigo%TYPE, id_libro Biblioteca.Libros.lib_codigo%TYPE) IS

    libro_cliente NUMBER; -- =0: NO TIENE EL LIBRO, !=0: TIENE EL LIBRO
    dias_mora NUMBER; -- CANTIDAD DE DIAS DE MORA
    fecha_entrega DATE; -- FECHA DE ENTREGA DE PRESTAMO
    fechahoy DATE; -- FECHA DE HOY
    valor_prestamo NUMBER;
    codigo_cliente NUMBER;
    estado_cliente NUMBER;

  BEGIN

    SELECT Trunc(SYSDATE) INTO fechahoy FROM DUAL;

    SELECT C.cli_codigo
    INTO codigo_cliente
    FROM Biblioteca.Clientes C
    WHERE C.cli_codigo = id_cliente;

    SELECT PL.pli_estado
    INTO estado_cliente
    FROM Biblioteca.Prestamos_Libros PL
    INNER JOIN Biblioteca.Prestamos P
    ON PL.pli_prestamo = P.pre_numero
    WHERE P.pre_cliente = id_cliente AND PL.pli_libro = id_libro;

    BEGIN

    SELECT P.pre_fecha
    INTO fecha_entrega
    FROM Biblioteca.Prestamos P
    INNER JOIN Biblioteca.Clientes C ON P.pre_cliente = C.cli_codigo
    INNER JOIN Biblioteca.Prestamos_Libros PL ON P.pre_numero = PL.pli_prestamo
    WHERE C.cli_codigo = id_cliente AND PL.pli_libro = id_libro;

    dias_mora := fechahoy - fecha_entrega;

    EXCEPTION
    WHEN No_Data_Found THEN
    Dbms_Output.put_line('Mensaje de Error :'||SQLERRM);
    Dbms_Output.put_line('Codigo de Error :'||SQLCODE);

    END;
    IF(estado_cliente=0) THEN

        IF(dias_mora > 0) THEN

                SELECT Count(1)
                INTO libro_cliente
                FROM Biblioteca.Prestamos_Libros PL
                INNER JOIN Biblioteca.Prestamos P ON PL.pli_prestamo = P.pre_numero
                INNER JOIN Biblioteca.Clientes C ON P.pre_cliente = C.cli_codigo
                WHERE PL.pli_libro = id_libro AND C.cli_codigo = id_cliente;


            IF(libro_cliente>0) then
            Dbms_Output.put_line('El cliente tiene el libro.');
            -- Por cada día de mora, se carga un punitorio del 0.1% del valor de alquiler
              SELECT PL.pli_valor
              INTO valor_prestamo
              FROM Biblioteca.Prestamos_Libros PL
              INNER JOIN Biblioteca.Prestamos P ON PL.pli_prestamo = P.pre_numero
              WHERE PL.pli_libro = id_libro AND P.pre_cliente = id_cliente;


              UPDATE Biblioteca.Prestamos_Libros
                  SET pli_multa = pli_valor * (0.01*dias_mora)
                  WHERE pli_libro = id_libro;
              Dbms_Output.put_line('Dias Mora: '||dias_mora);
              Dbms_Output.put_line('Multa actualizada');



              UPDATE Biblioteca.Prestamos_Libros PL
              SET PL.pli_estado = 1
              WHERE codigo_cliente = id_cliente AND PL.pli_libro = id_libro;


              Dbms_Output.put_line('Devolucion realizada.');
              UPDATE Biblioteca.Libros
                SET lib_cantidad = lib_cantidad+1
              WHERE lib_codigo = id_libro;


              --Si la devolución excede los 15 días de mora. Se deben suspender los préstamos a dicho cliente, por 90 días.
              IF (fechahoy > fecha_entrega+15) THEN

              UPDATE Biblioteca.Clientes
                  SET cli_suspendido = fechahoy+90
                  WHERE cli_codigo = id_cliente;

              Dbms_Output.put_line('Devolucion realizada.');
              UPDATE Biblioteca.Libros
                SET lib_cantidad = lib_cantidad+1
              WHERE lib_codigo = id_libro;


              UPDATE Biblioteca.Prestamos_Libros PL
              SET PL.pli_estado = 1
              WHERE codigo_cliente = id_cliente AND PL.pli_libro = id_libro;


              Dbms_Output.put_line('Cliente suspendido');

              END IF;

            ELSE

            Dbms_Output.put_line('El cliente no tiene el libro.');

            END IF;

        ELSE

            Dbms_Output.put_line('Devolucion realizada.');
            UPDATE Biblioteca.Libros
              SET lib_cantidad = lib_cantidad+1
            WHERE lib_codigo = id_libro;


            UPDATE Biblioteca.Prestamos_Libros PL
            SET PL.pli_estado = 1
            WHERE codigo_cliente = id_cliente AND PL.pli_libro = id_libro;
        END IF;
    ELSE

    Dbms_Output.put_line('No puede realizar devoluciones.');

    END IF;

  END sp_devoluciones;

END BIBLIO_PKG;


CREATE TABLE Biblioteca.Autores(
	aut_codigo NUMBER(3),
	aut_nombre VARCHAR(30),
	aut_nacionalidad VARCHAR(30),
  CONSTRAINT pk_aut_codigo PRIMARY KEY (aut_codigo)
);


CREATE TABLE Biblioteca.Libros(
	lib_codigo NUMBER(10),
	lib_descripcion VARCHAR(50),
	lib_cantidad NUMBER(6),
	lib_edicion NUMBER(1),
	lib_observacion VARCHAR(50),
  CONSTRAINT pk_lib_codigo PRIMARY KEY (lib_codigo)
);


ALTER TABLE Biblioteca.Libros
  ADD lib_precio NUMBER;


CREATE TABLE Biblioteca.Ciudades(
	ciu_codigo NUMBER(3),
	ciu_descripcion VARCHAR(30),
  CONSTRAINT pk_ciu_codigo PRIMARY KEY (ciu_codigo)
);




CREATE TABLE Biblioteca.Libros_Autores(
	lau_libro NUMBER(10),
	lau_autor NUMBER(3),
  CONSTRAINT fk_lau_libro
    FOREIGN KEY (lau_libro)
    REFERENCES Biblioteca.Libros (lib_codigo),
  CONSTRAINT fk_lau_autor
    FOREIGN KEY (lau_autor)
    REFERENCES Biblioteca.Autores (aut_codigo)
);
CREATE INDEX Lau_indice1 ON Biblioteca.Libros_Autores(lau_libro);
CREATE INDEX Lau_indice2 ON Biblioteca.Libros_Autores(lau_autor);


CREATE TABLE Biblioteca.Clientes(
	cli_codigo NUMBER(3),
	cli_nombre VARCHAR(30),
	cli_direccion VARCHAR(30),
	cli_ciudad NUMBER(3),
	cli_obs VARCHAR(50),
  CONSTRAINT pk_cli_codigo PRIMARY KEY (cli_codigo),
  CONSTRAINT fk_cli_ciudad
    FOREIGN KEY (cli_ciudad)
    REFERENCES Biblioteca.Ciudades (ciu_codigo)
);
CREATE INDEX Clientes_indice1 ON Biblioteca.Clientes(cli_ciudad);

CREATE TABLE Biblioteca.Prestamos(
	pre_numero NUMBER(10),
	pre_cliente NUMBER(3),
  pre_fecha DATE,
	pre_observacion VARCHAR(50),
  CONSTRAINT fk_pre_cliente
    FOREIGN KEY (pre_cliente)
    REFERENCES Biblioteca.Clientes (cli_codigo)
);

ALTER TABLE Biblioteca.Prestamos
  ADD (
    CONSTRAINT pk_pre_numero PRIMARY KEY (pre_numero)
  );

CREATE INDEX Prestamos_indice1 ON Biblioteca.Prestamos(pre_cliente);
CREATE SEQUENCE pkpre_secuencia;

CREATE OR REPLACE TRIGGER Prestamos
  BEFORE INSERT ON Biblioteca.Prestamos
  FOR EACH ROW
BEGIN
  SELECT pkpre_secuencia.NEXTVAL
  INTO :NEW.pre_numero
  FROM dual;
END;

CREATE TABLE Biblioteca.Prestamos_Libros(
	pli_libro NUMBER(10),
	pli_prestamo NUMBER(10),
	pli_estado NUMBER(1),
	pli_dias NUMBER(2),
	pli_valor NUMBER(12,2),
	pli_multa NUMBER(12,2),
  CONSTRAINT fk_pli_libro
    FOREIGN KEY (pli_libro)
    REFERENCES Biblioteca.Libros (lib_codigo),
  CONSTRAINT fk_pli_prestamo
    FOREIGN KEY (pli_prestamo)
    REFERENCES Biblioteca.Prestamos (pre_numero)
);
CREATE INDEX Pli_indice1 ON Biblioteca.Prestamos_Libros(pli_prestamo);
CREATE INDEX Pli_indice2 ON Biblioteca.Prestamos_Libros(pli_libro);

CREATE SEQUENCE fkpli_secuencia;


CREATE OR REPLACE TRIGGER Prestamos_Libros
  BEFORE INSERT ON Biblioteca.Prestamos_Libros
  FOR EACH ROW
BEGIN
  SELECT fkpli_secuencia.nextval
  INTO :NEW.pli_prestamo
  FROM dual;
END;

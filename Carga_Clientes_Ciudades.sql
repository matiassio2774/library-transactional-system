
--- 'CARGA CIUDADES'
SELECT * FROM Biblioteca.Ciudades;  --- ID - CIUDAD

INSERT INTO Biblioteca.Ciudades VALUES (1,'Amsterdam');
INSERT INTO Biblioteca.Ciudades VALUES (2,'Emeliefurt');
INSERT INTO Biblioteca.Ciudades VALUES (3,'Greenholthaven');
INSERT INTO Biblioteca.Ciudades VALUES (4,'La Vila');
INSERT INTO Biblioteca.Ciudades VALUES (5,'Razo Alta');
INSERT INTO Biblioteca.Ciudades VALUES (6,'Los Ledesma del Puerto');
INSERT INTO Biblioteca.Ciudades VALUES (7,'Rael del Vallès');
INSERT INTO Biblioteca.Ciudades VALUES (8,'Villa Esperanza');
INSERT INTO Biblioteca.Ciudades VALUES (9,'Sesto Oreste');
INSERT INTO Biblioteca.Ciudades VALUES (10,'Pellegrini ligure');


ALTER TABLE Clientes
  ADD cli_suspendido DATE;

--- 'CARGA CLIENTES'
SELECT * FROM Biblioteca.Clientes;  --- ID - NOMBRE -   DIRECCION  - ID CIU - OBS

INSERT INTO Biblioteca.Clientes VALUES (1,'Isabella','Reestraat',1,'EJ.1');
INSERT INTO Biblioteca.Clientes VALUES (2,'Kasey Lueilwitz','Jennie Isle',2,'EJ.2');
INSERT INTO Biblioteca.Clientes VALUES (3,'Paula Ernser','Hubert Place Suite ',3,'EJ.3');
INSERT INTO Biblioteca.Clientes VALUES (4,'Joel Villalpando','Paseo Giménez',4,'EJ.4');
INSERT INTO Biblioteca.Clientes VALUES (5,'Daniel Benito','Rúa Delacrúz',5,'EJ.5');
INSERT INTO Biblioteca.Clientes VALUES (6,'Ona Gracia','Plaza Samuel',6,'EJ.6');
INSERT INTO Biblioteca.Clientes VALUES (7,'Marina Brito','Calle Unai',7,'EJ.7');
INSERT INTO Biblioteca.Clientes VALUES (8,'Sofía Corrales','Paseo Biel',8,'EJ.8');
INSERT INTO Biblioteca.Clientes VALUES (9,'Emidio Mancini','Via Grazia',9,'EJ.9');
INSERT INTO Biblioteca.Clientes VALUES (10,'Kris Conti','Contrada Marieva',10,'EJ.10');

COMMIT;

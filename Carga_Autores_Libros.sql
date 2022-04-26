
--- CARGA LIBROS
SELECT * FROM Biblioteca.Libros;  --- ID - NOMBRE - CANT - EDICION - OBS

INSERT INTO Biblioteca.Libros VALUES (1,'La tregua',12,1,'EJ.1');
INSERT INTO Biblioteca.Libros VALUES (2,'Ficciones',9,2,'EJ.2');
INSERT INTO Biblioteca.Libros VALUES (3,'Cloudstreet',14,1,'EJ.3');
INSERT INTO Biblioteca.Libros VALUES (4,'Raza de bronce',12,2,'EJ.4');
INSERT INTO Biblioteca.Libros VALUES (5,'Don Casmurro',8,1,'EJ.5');
INSERT INTO Biblioteca.Libros VALUES (6,'La casa de los espíritus',15,2,'EJ.6');
INSERT INTO Biblioteca.Libros VALUES (7,'Cien años de soledad',6,3,'EJ.7');
INSERT INTO Biblioteca.Libros VALUES (8,'Café Europa',11,11,'EJ.8');
INSERT INTO Biblioteca.Libros VALUES (9,'Havana Bay',14,2,'EJ.9');
INSERT INTO Biblioteca.Libros VALUES (10,'Don Quijote de la Mancha',7,1,'EJ.10');
INSERT INTO Biblioteca.Libros VALUES (11,'Soldados desconocidos',9,2,'EJ.11');
INSERT INTO Biblioteca.Libros VALUES (12,'El conde de Montecristo',5,1,'EJ.12');
INSERT INTO Biblioteca.Libros VALUES (13,'La Ilíada',15,3,'EJ.13');
INSERT INTO Biblioteca.Libros VALUES (14,'La voz',6,1,'EJ.14');
INSERT INTO Biblioteca.Libros VALUES (15,'La divina comedia',11,1,'EJ.15');


UPDATE Biblioteca.Libros
SET lib_precio = 100;


SELECT * FROM Biblioteca.Libros;


--- CARGA AUTORES
SELECT * FROM Biblioteca.Autores;   --- ID -    NOMBRE   - NACIONALIDAD

INSERT INTO Biblioteca.Autores VALUES (1,'Mario Benedetti','Uruguay');
INSERT INTO Biblioteca.Autores VALUES (2,'Jorge Luis Borges','Argentina');
INSERT INTO Biblioteca.Autores VALUES (3,'Tim Winton','Australia');
INSERT INTO Biblioteca.Autores VALUES (4,'Alcides Arguedas','Bolivia');
INSERT INTO Biblioteca.Autores VALUES (5,'Machado de Assis','Brasil');
INSERT INTO Biblioteca.Autores VALUES (6,' Isabel Allende','Chile');
INSERT INTO Biblioteca.Autores VALUES (7,'Gabriel García Márquez','Colombia');
INSERT INTO Biblioteca.Autores VALUES (8,'Slavenka Drakulik','Croacia');
INSERT INTO Biblioteca.Autores VALUES (9,'Martin Cruz Smith','Cuba');
INSERT INTO Biblioteca.Autores VALUES (10,'Miguel de Cervantes','España');
INSERT INTO Biblioteca.Autores VALUES (11,'Väinö Linna','Finlandia');
INSERT INTO Biblioteca.Autores VALUES (12,'Alejandro Dumas','Francia');
INSERT INTO Biblioteca.Autores VALUES (13,'Homero','Grecia');
INSERT INTO Biblioteca.Autores VALUES (14,'Arnaldur Indriðason','Islandia');
INSERT INTO Biblioteca.Autores VALUES (15,'Dante Alighieri','Italia');


--- CARGA RELACION LIBROS AUTORES
SELECT * From Biblioteca.Libros_Autores; --- ID - ID

INSERT INTO Biblioteca.Libros_Autores VALUES (1,1);
INSERT INTO Biblioteca.Libros_Autores VALUES (2,2);
INSERT INTO Biblioteca.Libros_Autores VALUES (3,3);
INSERT INTO Biblioteca.Libros_Autores VALUES (4,4);
INSERT INTO Biblioteca.Libros_Autores VALUES (5,5);
INSERT INTO Biblioteca.Libros_Autores VALUES (6,6);
INSERT INTO Biblioteca.Libros_Autores VALUES (7,7);
INSERT INTO Biblioteca.Libros_Autores VALUES (8,8);
INSERT INTO Biblioteca.Libros_Autores VALUES (9,9);
INSERT INTO Biblioteca.Libros_Autores VALUES (10,10);
INSERT INTO Biblioteca.Libros_Autores VALUES (11,11);
INSERT INTO Biblioteca.Libros_Autores VALUES (12,12);
INSERT INTO Biblioteca.Libros_Autores VALUES (13,13);
INSERT INTO Biblioteca.Libros_Autores VALUES (14,14);
INSERT into biblioteca.libros_autores VALUES (15,15);


COMMIT;
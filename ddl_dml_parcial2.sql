-- DDL
CREATE DATABASE Parcial2Aafa;
GO

USE master
GO

CREATE LOGIN usrparcial2 WITH PASSWORD = '12345678',
    DEFAULT_DATABASE = Parcial2Aafa,
    CHECK_EXPIRATION = OFF,
    CHECK_POLICY = ON
GO

USE Parcial2Aafa
GO

CREATE USER usrparcial2 FOR LOGIN usrparcial2
GO

ALTER ROLE db_owner ADD MEMBER usrparcial2
GO

DROP TABLE IF EXISTS Programa;
DROP TABLE IF EXISTS Canal;
GO

CREATE TABLE Canal (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(20) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1 -- 1: Activo, 0: Inactivo (Eliminación Lógica)
);

CREATE TABLE Programa (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    idCanal INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NULL,
    duracion INT NOT NULL,
    productor VARCHAR(100) NOT NULL,
    fechaEstreno DATE NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1, -- 1: Activo, 0: Inactivo (Eliminación Lógica)
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Programa_Canal FOREIGN KEY (idCanal) REFERENCES Canal(id)
);
ALTER TABLE Canal ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Canal ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Canal ADD estado INT NOT NULL DEFAULT 1; 

ALTER TABLE Programa ADD usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME();
ALTER TABLE Programa ADD fechaRegistro DATETIME NOT NULL DEFAULT GETDATE();
ALTER TABLE Programa ADD estado INT NOT NULL DEFAULT 1;
GO

DROP PROC IF EXISTS paProgramaListar;
GO

CREATE PROC paProgramaListar @parametro VARCHAR(50)
AS
    SELECT p.id, p.idCanal, c.nombre AS canal, p.titulo, p.descripcion, 
           p.duracion, p.productor, p.fechaEstreno, p.usuarioRegistro, 
           p.fechaRegistro, p.estado
    FROM Programa p
    INNER JOIN Canal c ON c.id = p.idCanal
    -- Eliminación lógica: estado = 1 (Activo), estado = 0 o -1 (Inactivo/Eliminado)
    WHERE p.estado = 1 
      AND (p.titulo + p.descripcion + p.productor) LIKE '%' + REPLACE(@parametro, ' ', '%') + '%'
    ORDER BY p.titulo;
GO

-- Insertar datos de prueba iniciales (Opcional para verificación)
INSERT INTO Canal (nombre, frecuencia, estado) VALUES ('Red Uno', 'Canal 13', 1);
INSERT INTO Canal (nombre, frecuencia, estado) VALUES ('Unitel', 'Canal 4', 1);
INSERT INTO Canal (nombre, frecuencia, estado) VALUES ('Unitel', 'Canal 4', 1);
INSERT INTO Canal (nombre, frecuencia, estado) VALUES ('Red Uno', 'Canal 13', 1);
INSERT INTO Canal (nombre, frecuencia, estado) VALUES ('Bolivia TV', 'Canal 7', 1);
INSERT INTO Canal (nombre, frecuencia, estado) VALUES ('ATB', 'Canal 9', 1);
GO

INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado) 
VALUES (1, 'Noticiero Central', 'Noticias locales y nacionales', 60, 'Juan Pérez', '2026-01-15', 1);
INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (1, 'Telepaís Central', 'Noticiero principal de la noche con cobertura nacional', 75, 'Director de Prensa Unitel', '2026-01-10', 1);

INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (1, 'La Revista', 'Programa matutino con noticias, datos del clima y cocina', 180, 'Producciones Mañana Unitel', '2026-01-12', 1);

INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (1, 'Calle 7', 'Programa de competencia juvenil y entretenimiento', 90, 'Entretenimiento Unitel', '2026-03-15', 1);
-- Programas para Red Uno (idCanal = 2)
INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (2, 'Notivisión Central', 'Noticiero nocturno con reportajes en vivo y debates', 60, 'Prensa Red Uno Sucre', '2026-02-01', 1);

INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (2, 'El Mañanero', 'Revista matinal informativa y de entretenimiento local', 150, 'Producciones Locales Red Uno', '2026-02-05', 1);

INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (2, 'Factor X', 'Concurso de canto y talento musical a nivel nacional', 120, 'Formatos Internacionales S.A.', '2026-04-20', 1);


-- Programas para Bolivia TV (idCanal = 3)
INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (3, 'BTV Noticias', 'Informativo estatal con reportajes de las provincias', 65, 'Ministerio de Comunicación', '2026-01-01', 1);

INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (3, 'Pica Bolivia', 'Programa educativo e informativo para adolescentes', 45, 'Educación Digital', '2026-05-10', 1);


-- Programas para ATB (idCanal = 4)
INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (4, 'ATB Noticias Edición Central', 'Espacio informativo de la noche', 60, 'Prensa ATB', '2026-02-20', 1);

INSERT INTO Programa (idCanal, titulo, descripcion, duracion, productor, fechaEstreno, estado)
VALUES (4, 'Anoticiando', 'Análisis político y entrevistas de actualidad', 90, 'Periodismo Independiente', '2026-03-01', 1);
GO

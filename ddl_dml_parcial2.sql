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
DROP TABLE IF EXISTS CategoriaPrograma;
GO

CREATE TABLE Canal (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    frecuencia VARCHAR(20) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1 
);

CREATE TABLE CategoriaPrograma (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1 
);

CREATE TABLE Programa (
    id INT IDENTITY(1, 1) PRIMARY KEY,
    idCanal INT NOT NULL,
    idCategoriaPrograma INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NULL,
    duracion INT NOT NULL,
    productor VARCHAR(100) NOT NULL,
    fechaEstreno DATE NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1, 
    usuarioRegistro VARCHAR(50) NOT NULL DEFAULT SUSER_NAME(),
    fechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Programa_Canal FOREIGN KEY (idCanal) REFERENCES Canal(id),
    CONSTRAINT FK_Porgrama_CategoriaPrograma FOREIGN KEY (idCategoriaPrograma) REFERENCES CategoriaPrograma(id)  
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
    SELECT p.id, 
           p.idCanal, c.nombre AS canal,              -- Trae el nombre del Canal
           p.idCategoriaPrograma, cat.nombre AS categoria, -- ¡NUEVO! Trae el nombre de la Categoría
           p.titulo, p.descripcion, p.duracion, p.productor, p.fechaEstreno, 
           p.usuarioRegistro, p.fechaRegistro, p.estado
    FROM Programa p
    INNER JOIN Canal c ON c.id = p.idCanal
    INNER JOIN CategoriaPrograma cat ON cat.id = p.idCategoriaPrograma -- ¡NUEVO! El segundo amarre obligatorio
    -- Eliminación lógica: solo muestra los programas activos (estado = 1)
    WHERE p.estado = 1 
      -- Búsqueda inteligente: ahora también busca por el nombre de la categoría o del canal
      AND (p.titulo + p.descripcion + p.productor + c.nombre + cat.nombre) LIKE '%' + REPLACE(@parametro, ' ', '%') + '%'
    ORDER BY p.titulo;
GO

-- Insertar datos de prueba iniciales (Opcional para verificación)
INSERT INTO Canal (nombre, frecuencia) VALUES ('Unitel', 'Canal 4'), ('Red Uno', 'Canal 13'), ('Bolivia TV', 'Canal 7'), ('ATB', 'Canal 9');

-- Categorías (Genera de forma automática los IDs: 1=Informativo, 2=Entretenimiento, 3=Educativo, 4=Deportivo)
INSERT INTO CategoriaPrograma (nombre) VALUES ('Informativo'), ('Entretenimiento'), ('Educativo'), ('Deportivo');
GO

-- Programas con sus llaves correspondientes (idCanal, idCategoriaPrograma)
INSERT INTO Programa (idCanal, idCategoriaPrograma, titulo, descripcion, duracion, productor, fechaEstreno) 
VALUES (1, 1, 'Telepaís Central', 'Noticiero principal de la noche', 75, 'Director de Prensa Unitel', '2026-01-10');

INSERT INTO Programa (idCanal, idCategoriaPrograma, titulo, descripcion, duracion, productor, fechaEstreno)
VALUES (1, 2, 'La Revista', 'Programa matutino con cocina y humor', 180, 'Producciones Mañana Unitel', '2026-01-12');

INSERT INTO Programa (idCanal, idCategoriaPrograma, titulo, descripcion, duracion, productor, fechaEstreno)
VALUES (2, 1, 'Notivisión Central', 'Noticiero nocturno Red Uno', 60, 'Prensa Red Uno Sucre', '2026-02-01');

INSERT INTO Programa (idCanal, idCategoriaPrograma, titulo, descripcion, duracion, productor, fechaEstreno)
VALUES (2, 2, 'Factor X', 'Concurso de canto musical', 120, 'Formatos Internacionales S.A.', '2026-04-20');
GO
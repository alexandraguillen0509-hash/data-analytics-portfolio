CREATE TABLE ROLES (
ID_Rol INT   Not null Primary Key Identity(1,1),
Rol Varchar(50) Not null check
(Rol in('Estuiante','Profesor',
'Administrador')),

)

CREATE TABLE USUARIOS (
ID_Usuario INT  Not null Primary Key Identity(1,1),
Nombre Varchar(50) Not null,
Correo Varchar(100) UNIQUE Not null,
Contraseña Varchar(100) Not null,
FechaRegistro DATETIME Not null Default(getdate()),
ID_Rol int Not null,
Estado bit not null
FOREIGN KEY (ID_Rol) REFERENCES ROLES(ID_Rol)

)

CREATE TABLE CURSOS (
ID_Curso INT  Not null Primary Key Identity(1,1),
NombreCurso Varchar(50) Not null,
FechaCurso DATETIME Not null Default(getdate()), 
Nivel Varchar(50) Not null, CHECK(Nivel in ('Básico',
'Intermedio', 'Avanzado')),
DescripcionCurso Varchar(max) Not null, 
Estado bit not null

)

CREATE TABLE TIPO_CONTENIDOS (
ID_TipoContenido INT Not null Primary Key Identity(1,1),
DescripcionContenido Varchar(max) Not null  CHECK(DescripcionContenido in 
('VIDEO','DOCUMENT','EVALUACION'))


)

CREATE TABLE CONTENIDOS (
 ID_Contenido INT  Not null Primary Key Identity(1,1),
 ID_Curso INT Not null,
 ID_TipoContenido INT Not null,
 FechaCreacion DATETIME DEFAULT(GETDATE()),
 FOREIGN KEY (ID_TipoContenido ) REFERENCES TIPO_CONTENIDOS(ID_TipoContenido )

)

CREATE TABLE INSCRIPCIONES (
 ID_Inscrpcion INT  Not null Primary Key Identity(1,1),
 ID_Usuario INT  Not null ,
 ID_Curso INT Not null,
 FechaInscripcion  DATETIME DEFAULT(GETDATE()),
 FechaFinal  DATETIME,
 Progreso DECIMAL(5,2) not null 
 DEFAULT 0 check(Progreso between 0 and 100),
 FOREIGN KEY (ID_Usuario) REFERENCES USUARIOS(ID_Usuario),
 FOREIGN KEY (ID_Curso) REFERENCES CURSOS(ID_Curso)

)


CREATE TABLE EVALUACIONES (
ID_Evaluacion INT Not null Primary Key Identity(1,1),
ID_Curso INT Not null,
NombreEvaluacion Varchar(max) not null,
Calificacion DECIMAL Not null CHECK(Calificacion >= 0),
CalificacionMaxima  INT CHECK(CalificacionMaxima > 0),
FechaEvaluacion DATETIME Not null DEFAULT(GETDATE()),
FOREIGN KEY (ID_Curso) REFERENCES CURSOS(ID_Curso)

)

CREATE TABLE RESULTADOS (
ID_Resultado INT Not null Primary Key Identity(1,1),
ID_Evaluacion INT Not null,
ID_Usuario INT  Not null ,
CalificacionFinal DECIMAL Not null CHECK(CalificacionFinal > 0),
FechaResultados DATETIME Not null DEFAULT(GETDATE()),
FOREIGN KEY (ID_Evaluacion) REFERENCES EVALUACIONES(ID_Evaluacion),
FOREIGN KEY (ID_Usuario) REFERENCES USUARIOS(ID_Usuario),
)



CREATE TABLE CERTIFICACIONES (
ID_Certificacion INT PRIMARY  Key Identity(1,1),
ID_Usuario INT  Not null ,
ID_Curso INT Not null,
FechaEmision DATETIME NOT NULL  DEFAULT(GETDATE()),
FOREIGN KEY (ID_Usuario) REFERENCES USUARIOS(ID_Usuario),
FOREIGN KEY (ID_Curso) REFERENCES CURSOS(ID_Curso)


)


CREATE UNIQUE INDEX  idx_Usuarios_Inscripciones on INSCRIPCIONES(ID_Usuario)

CREATE UNIQUE INDEX  idx_






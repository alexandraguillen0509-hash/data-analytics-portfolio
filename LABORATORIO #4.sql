
CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Correo_Electronico VARCHAR(100) UNIQUE NOT NULL CHECK(Correo_Electronico  LIKE '%_@__%.__%'  ),
    Telefono VARCHAR(15),
    Fecha_Registro DATETIME NOT NULL,
    Puntos_Loyalty INT DEFAULT 0 CHECK(Puntos_Loyalty >= 0)
)


CREATE TABLE VideoJuegos (
    ID_Videojuego INT PRIMARY KEY IDENTITY(1,1),
    Titulo VARCHAR(100) NOT NULL,
    Genero VARCHAR(50) NOT NULL,
    Precio_Venta DECIMAL(10, 2) CHECK (Precio_Venta >= 0),
    Precio_Alquiler DECIMAL(10, 2) CHECK (Precio_Alquiler >= 0),
    Cantidad_Disponible INT CHECK (Cantidad_Disponible >= 0),
    Plataforma VARCHAR(20) NOT NULL,
    Descripcion TEXT,
    Calificacion INT CHECK (Calificacion BETWEEN 1 AND 10)
)


CREATE TABLE Metodos_Pago (
    ID_MetodoPago INT PRIMARY KEY IDENTITY(1,1),
    Nombre_MetodoPago VARCHAR(50) NOT NULL CHECK (Nombre_MetodoPago IN ('Tarjeta', 'Efectivo', 'Transferencia', 'PayPal', 'Crédito')),
    Descripcion VARCHAR(MAX)
)


CREATE TABLE Ventas (
    ID_Venta INT PRIMARY KEY IDENTITY(1,1),
    Fecha_Venta DATE NOT NULL,
    ID_Cliente INT NOT NULL,
    Total_Venta DECIMAL(10, 2) CHECK (Total_Venta >= 0),
    ID_MetodoPago INT NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_MetodoPago) REFERENCES Metodos_Pago(ID_MetodoPago) 
)


CREATE TABLE Detalles_Venta (
    ID_Detalle INT PRIMARY KEY IDENTITY(1,1),
    ID_Venta INT NOT NULL,
    ID_Videojuego INT NOT NULL,
    Cantidad INT CHECK (Cantidad > 0),
    Precio_Unitario DECIMAL(10, 2) CHECK (Precio_Unitario >= 0),
    FOREIGN KEY (ID_Venta) REFERENCES Ventas(ID_Venta),
    FOREIGN KEY (ID_Videojuego) REFERENCES Videojuegos(ID_Videojuego)
)


CREATE TABLE Alquileres (
    ID_Alquiler INT PRIMARY KEY IDENTITY(1,1),
    ID_Cliente INT NOT NULL,
    ID_Videojuego INT NOT NULL,
    Fecha_Alquiler DATE NOT NULL,
    Fecha_Devolucion DATETIME NOT NULL,
    Precio_Alquiler DECIMAL(10, 2) CHECK (Precio_Alquiler >= 0),
    Estado VARCHAR(20) CHECK (Estado IN ('Activo', 'Finalizado')),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Videojuego) REFERENCES Videojuegos(ID_Videojuego)
);

CREATE TABLE Reparaciones (
    ID_Reparacion INT PRIMARY KEY IDENTITY(1,1),
    ID_Videojuego INT NOT NULL,
    Descripcion_Problema TEXT NOT NULL,
    Fecha_Recepcion DATETIME NOT NULL DEFAULT(Getdate()),
    Fecha_Entrega DATETIME NOT NULL,
    Costo_Reparacion DECIMAL(10, 2) CHECK (Costo_Reparacion >= 0),
    Estado VARCHAR(20) CHECK (Estado IN ('Pendiente', 'Completado')),
    FOREIGN KEY (ID_Videojuego) REFERENCES Videojuegos(ID_Videojuego)
)


CREATE TABLE Programas_Lealtad (
    ID_Programa INT PRIMARY KEY IDENTITY(1,1),
    Nombre_Programa VARCHAR(50) NOT NULL,
    Puntos_Necesarios INT CHECK (Puntos_Necesarios > 0),
    Beneficio VARCHAR(100) NOT NULL
)


CREATE TABLE Canje_Puntos (
    ID_Canje INT PRIMARY KEY IDENTITY(1,1),
    ID_Cliente INT NOT NULL,
    ID_Programa INT NOT NULL,
    Fecha_Canje DATETIME NOT NULL,
    Puntos_Canjados INT CHECK (Puntos_Canjados > 0),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Programa) REFERENCES Programas_Lealtad(ID_Programa)
)


CREATE TABLE Preventas (
    ID_Preventa INT PRIMARY KEY IDENTITY(1,1),
    ID_Cliente INT NOT NULL,
    ID_Videojuego INT NOT NULL,
    Fecha_Reserva DATETIME NOT NULL,
    Fecha_Lanzamiento DATETIME NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Videojuego) REFERENCES Videojuegos(ID_Videojuego)
)


CREATE UNIQUE INDEX Idx_Ventas_Cliente ON Ventas(ID_Cliente)
CREATE UNIQUE INDEX Idx_Clientes_Correo_Electronico ON Clientes(Correo_Electronico)
CREATE UNIQUE INDEX Idx_CanjePuntos_ID_Cliente ON Canje_Puntos(ID_Cliente)
CREATE UNIQUE INDEX Idx_Reparaciones_ID_Videojuego ON Reparaciones(ID_Videojuego)


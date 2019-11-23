/************************************ CREATE TYPE ************************************/
CREATE TYPE estadoAparcamiento AS ENUM ('disponible', 'limitado', 'suspendido');
CREATE TYPE tipoPlaza AS ENUM ('rotacional', 'residencial');
CREATE TYPE tipoVehiculo AS ENUM ('motocicleta', 'turismo', 'autocaravana');
CREATE TYPE tipoServicioComplementario AS ENUM ('lavado', 'reparacion', 'sustitucionLunas', 'micrologistica', 'alquilerBicicletas');
CREATE TYPE tipoEmisiones AS ENUM ('ECO', 'CERO', 'B', 'C');
CREATE TYPE estadoSolicitud AS ENUM ('aprobado', 'pendiente', 'rechazado');
CREATE TYPE tipoSolicitud AS ENUM ('conReserva24', 'conReservaCesionDeUso', 'sinReservaDiurno', 'sinReservaNocturno');

/************************************* DROP TABLE ************************************/
DROP TABLE Aparcamiento;
DROP TABLE Plaza;
DROP TABLE ServicioComplementario;
DROP TABLE ReclamacionesYSugerencias;
DROP TABLE Ingresos;
DROP TABLE Vehiculos;
DROP TABLE RegistroEntradaSalida;
DROP TABLE Empleado;
DROP TABLE Usuario;
DROP TABLE Solicitud;
DROP TABLE Abono;

/************************************ CREATE TABLE ***********************************/
CREATE TABLE Aparcamiento (                                                     
    nombre char(20),
    direccion char(20) NOT NULL UNIQUE,
    horaApertura time NOT NULL,
    horaCierre time NOT NULL,
    estado estadoAparcamiento NOT NULL,
    publico bit NOT NULL,
    disuasorio bit NOT NULL,
    tarifaMotocicletas FLOAT NOT NULL,
    tarifaTurismos FLOAT NOT NULL,
    tarifaAutocaravanas FLOAT NOT NULL,
    PRIMARY KEY (nombre)
);

CREATE TABLE Plaza (
    nombreAparcamiento char(20),
    numPlaza INTEGER,
    tipo tipoPlaza NOT NULL,
    accesible bit NOT NULL,
    funcional bit NOT NULL,
    limitada bit NOT NULL,
    recargaElectrica bit NOT NULL,
    tipoVehiculo tipoVehiculo NOT NULL,
    PRIMARY KEY (numPlaza),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre)
);

CREATE TABLE ServicioComplementario (
    nombreAparcamiento char(20),
    numPlaza INTEGER,
    tipo tipoServicioComplementario NOT NULL,
    precio FLOAT NOT NULL,
    PRIMARY KEY (tipo),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre),
    FOREIGN KEY (numPlaza) REFERENCES Plaza (numPlaza)
);

CREATE TABLE ReclamacionesYSugerencias (
    nombreAparcamiento char(20),
    cod INTEGER,
    texto text NOT NULL,
    primary key (cod),
    foreign key (nombreAparcamiento) references Aparcamiento (nombre)
);

CREATE TABLE Ingresos (
    nombreAparcamiento char(20),
    fecha date NOT NULL,
    dinero  FLOAT NOT NULL,
    PRIMARY KEY (fecha),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre)
);

CREATE TABLE Vehiculo (
    matricula char(20),
    modelo char(20),
    tipo tipoVehiculo NOT NULL,
    emisiones tipoEmisiones NOT NULL,
    PRIMARY KEY (matricula)
);

CREATE TABLE RegistroEntradaSalida (
    nombreAparcamiento char(20),
    matrVehiculo char(20),
    entrada timestamp NOT NULL,
    salida timestamp,
    importe FLOAT,                  /*CHECK si el vehiculo tiene un abolo debe ser 0*/ 
    PRIMARY KEY (entrada),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre),
    FOREIGN KEY (matrVehiculo) REFERENCES Vehiculo (matricula)
);

CREATE TABLE Empleado(
    nombreAparcamiento char(20),
    numIdentificacion char(20),
    nombre char(20) NOT NULL,
    apellidos char[40] NOT NULL,
    direccion char[30] NOT NULL,
    esGestor bit NOT NULL,
    PRIMARY KEY(numIdentificacion),
    FOREIGN KEY(nombreAparcamiento) REFERENCES Aparcamiento(nombre)
);

CREATE TABLE Usuario(
    numIdentificacion char(20),
    nombre char(20) NOT NULL,
    apellidos char(40) NOT NULL,
    direccion char(30) NOT NULL,
    pmr bit NOT NULL,
    PRIMARY KEY(numIdentificacion)
);

CREATE TABLE Solicitud(
    nombreAparcamiento char(20),
    usuario char(20),
    fecha timestamp,
    estado estadoSolicitud NOT NULL,
    acreditacion char(10000) NOT NULL,
    tipo tipoSolicitud NOT NULL,
    nif char(20) NOT NULL,
    PRIMARY KEY(fecha),
    FOREIGN KEY(usuario) REFERENCES Usuario(numIdentificacion),
    FOREIGN KEY(nombreAparcamiento) REFERENCES Aparcamiento(nombre)
);

CREATE TABLE Abono(
    nombreAparcamiento char(20),
    vehiculo char(20),
    idAbono char[10],
    plaza INTEGER REFERENCES Plaza(numPlaza),
    precio FLOAT NOT NULL,
    gastosRepercutibles FLOAT NOT NULL,
    fechaInicioContrato date NOT NULL,
    fechaFinContrato date NOT NULL,
    fianza FLOAT NOT NULL,
    mesesEnMorosidad INTEGER NOT NULL,
    horaEntrada time,
    horaSalida time,
    PRIMARY KEY(idAbono),
    FOREIGN KEY(vehiculo) REFERENCES Vehiculo(matricula),
    FOREIGN KEY(nombreAparcamiento) REFERENCES Aparcamiento(nombre)
);

/************************************** INSERTS **************************************/
INSERT INTO Aparcamiento VALUES ('UVa', 'C/ Uno', '08:00:00', '20:00:00', 'disponible', '1', '0', 0.1, 0.1, 0.2);
INSERT INTO Aparcamiento VALUES ('Hospital', 'C/ Dos', '08:00:00', '21:00:00', 'disponible', '1', '0', 0.1, 0.1, 0.2);
INSERT INTO Aparcamiento VALUES ('Aparcamiento 2', 'C/ Cinco', '09:00:00', '21:00:00', 'disponible', '1', '0', 0.3, 0.1, 0.2);
INSERT INTO Aparcamiento VALUES ('Aparcamiento 3', 'C/ Tres', '06:00:00', '22:00:00', 'limitado', '1', '0', 0.1, 0.3, 0.2);
INSERT INTO Aparcamiento VALUES ('Aparcamiento 4', 'C/ Cuatro', '06:00:00', '23:00:00', 'suspendido', '1', '1', 0.2, 0.1, 0.2);


INSERT INTO Plaza VALUES ('UVa', 1, 'residencial', '0', '1', '0', '0', 'turismo');
/*INSERT INTO Plaza VALUES ('UVa', 2, 'rotacional', 0, 0, 0, 0, 'motocicleta');
INSERT INTO Plaza VALUES ('UVa', 3, 'rotacional', 0, 1, 0, 1, 'turismo');
INSERT INTO Plaza VALUES ('UVa', 4, 'rotacional', 1, 1, 0, 0, 'turismo');
INSERT INTO Plaza VALUES ('Hospital', 1, 'rotacional', 0, 1, 0, 0, 'turismo');
INSERT INTO Plaza VALUES ('Hospital', 2, 'rotacional', 0, 0, 0, 0, 'turismo');
INSERT INTO Plaza VALUES ('Hospital', 3, 'rotacional', 0, 1, 0, 0, 'motocicleta');
INSERT INTO Plaza VALUES ('Hospital', 4, 'rotacional', 1, 0, 0, 0, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 2', 1, 'residencial', 1, 1, 0, 1, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 2', 2, 'rotacional', 0, 1, 0, 1, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 2', 3, 'residencial', 0, 1, 0, 1, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 2', 4, 'residencial', 0, 1, 0, 1, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 3', 1, 'residencial', 0, 1, 0, 0, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 3', 2, 'residencial', 0, 1, 0, 0, 'motocicleta');
INSERT INTO Plaza VALUES ('Aparcamiento 3', 3, 'residencial', 0, 1, 0, 1, 'motocicleta');
INSERT INTO Plaza VALUES ('Aparcamiento 3', 4, 'residencial', 0, 1, 0, 0, 'autocaravana');
INSERT INTO Plaza VALUES ('Aparcamiento 4', 1, 'rotacional', 1, 0, 0, 0, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 4', 2, 'rotacional', 0, 0, 0, 0, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 4', 3, 'rotacional', 0, 0, 0, 0, 'turismo');
INSERT INTO Plaza VALUES ('Aparcamiento 4', 4, 'rotacional', 0, 0, 0, 0, 'turismo');*/

INSERT INTO ServicioComplementario VALUES ('UVa', 1, 'lavado', 15.3);
INSERT INTO ServicioComplementario VALUES ('UVa', 1, 'sustitucionLunas', 100.3);
INSERT INTO ServicioComplementario VALUES ('Aparcamiento 3', 3, 'reparacion', 200.3);
INSERT INTO ServicioComplementario VALUES ('Aparcamiento 2', 4, 'lavado', 18.3);
INSERT INTO ServicioComplementario VALUES ('Aparcamiento 2', 1, 'alquilerBicicletas', 30.4);

INSERT INTO Vehiculo VALUES('3180 IQL', 'Koenigsegg', 'turismo', 'ECO');
/*INSERT INTO Vehiculo VALUES('2780 KJU', 'Lamborghini', 'CERO' );
INSERT INTO Vehiculo VALUES('0941 YBS', 'Aston Martin', 'B');
INSERT INTO Vehiculo VALUES('4015 WKK', 'Aston Martin', 'B');
INSERT INTO Vehiculo VALUES('1218 XWQ', 'Ferrari', 'C');
INSERT INTO Vehiculo VALUES('3456 XWA', NULL, 'C');
INSERT INTO Vehiculo VALUES('5656 AVWA', NULL, 'C');*/

INSERT INTO ReclamacionesYSugerencias VALUES('UVA', 1, 'Lo que paso paso');
INSERT INTO ReclamacionesYSugerencias VALUES('Aparcamiento 4', 1, 'Lo que paso paso');
INSERT INTO ReclamacionesYSugerencias VALUES('Aparcamiento 4', 1, 'Fallo 1');
INSERT INTO ReclamacionesYSugerencias VALUES('Aparcamiento 4', 2, 'Fallo 2');
INSERT INTO ReclamacionesYSugerencias VALUES('Aparcamiento 4', 3, 'Fallo 3');

INSERT INTO Ingresos VALUES('Aparcamiento 1', '2019-02-21', 50.2);
INSERT INTO Ingresos VALUES('Aparcamiento 1', '2019-02-22', 60.2);
INSERT INTO Ingresos VALUES('Aparcamiento 2', '2019-02-21', 43.2);
INSERT INTO Ingresos VALUES('Aparcamiento 3', '2019-02-21', 50.2);
INSERT INTO Ingresos VALUES('UVA', '2019-02-21', 80.2);

INSERT INTO RegistroEntrada VALUES('UVA',5656 AVWA' ,'2019-02-21 12:00:00' , 0);
INSERT INTO RegistroEntrada VALUES('Aparcamiento 1','3456 XWA' '3180 IQL','2019-02-21 12:00:00' ,'2019-02-21 12:00:00' , 0);
INSERT INTO RegistroEntrada VALUES('Aparcamiento 1','3180 IQL' ,'2019-02-21 12:00:00' ,'2019-02-21 13:00:00' , 0);
INSERT INTO RegistroEntrada VALUES('Aparcamiento 1',3456 XWA' ,'2019-02-21 12:00:00' ,'2019-02-21 20:00:00' , 0);
INSERT INTO RegistroEntrada VALUES('Aparcamiento 2','4015 WKK' ,'2019-02-21 12:00:00' ,'2019-02-21 23:00:00' , 0);
INSERT INTO RegistroEntrada VALUES('Aparcamiento 2','4015 WKK' ,'2019-02-21 12:00:00' ,'2019-02-21 13:30:00' , 0);
INSERT INTO RegistroEntrada VALUES('Aparcamiento 3','2780 KJU' ,'2019-02-21 12:00:00' ,'2019-02-21 12:35:00' , 0);

INSERT INTO Empleado VALUES('UVA','DNI 1' ,'Enombre 1' ,'Apellidos 1', 'C/ Cinco', 1);
INSERT INTO Empleado VALUES('Aparcamiento 1','DNI 1' ,'Enombre 1' ,'Apellidos 1', 'C/ Cinco', 1);
INSERT INTO Empleado VALUES('Aparcamiento 2','DNI 2' ,'Enombre 2' ,'Apellidos 2', 'C/ Seis', 1);
INSERT INTO Empleado VALUES('Aparcamiento 3','DNI 3' ,'Enombre 3' ,'Apellidos 3', 'C/ Siete', 1);
INSERT INTO Empleado VALUES('Aparcamiento 4','DNI 4' ,'Enombre 2' ,'Apellidos 4', 'C/ Cuatro', 1);
INSERT INTO Empleado VALUES('Aparcamiento 1','DNI 5' ,'Enombre 4' ,'Apellidos 7', 'C/ Siete', 0);
INSERT INTO Empleado VALUES('Aparcamiento 2','DNI 6' ,'Enombre 5' ,'Apellidos 5', 'C/ Dos', 0);
INSERT INTO Empleado VALUES('Aparcamiento 3','DNI 7' ,'Enombre 6' ,'Apellidos 6', 'C/ Tres', 0);

INSERT INTO Usuario VALUES('DNI 8' ,'nombre 1' ,'Apellidos 8', 'C/ Tres', 0);
INSERT INTO Usuario VALUES('DNI 8' ,'nombre 2' ,'Apellidos 9', 'C/ Cuatro', 0);
INSERT INTO Usuario VALUES('DNI 8' ,'nombre 3' ,'Apellidos 10', 'C/ Cinco', 0);
INSERT INTO Usuario VALUES('DNI 8' ,'nombre 4' ,'Apellidos 9', 'C/ Seis', 1);
INSERT INTO Usuario VALUES('DNI 8' ,'nombre 5' ,'Apellidos 11', 'C/ Ocho', 0);





*/
/******************************************************************************************/

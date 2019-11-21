CREATE TYPE estadoAparcamiento AS ENUM ('disponible', 'limitado', 'suspendido');
CREATE TYPE tipoPlaza AS ENUM ('rotacional', 'residencial');
CREATE TYPE tipoVehiculo AS ENUM ('motocicleta', 'turismo', 'autocaravana');
CREATE TYPE tipoServicioComplementario AS ENUM ('lavado', 'reparacion', 'sustitucionLunas', 'micrologistica', 'alquilerBicicletas');
CREATE TYPE tipoEmisiones AS ENUM ('ECO', 'CERO', 'B', 'C');
CREATE TYPE estadoSolicitud AS ENUM ('aprobado', 'pendiente', 'rechazado');
CREATE TYPE tipoSolicitud AS ENUM ('conReserva24', 'conReservaCesionDeUso', 'sinReservaDiurno', 'sinReservaNocturno');


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

CREATE TABLE Aparcamiento (                                                     
    nombre char(20),
    direccion char(20) NOT NULL UNIQUE,
    horaApertura time NOT NULL,
    horaCierre time NOT NULL,
    estado estadoAparcamiento NOT NULL,
    publico bit NOT NULL,
    disuasorio bit NOT NULL,
    tarifaMotocicletas money NOT NULL,
    tarifaTurismos money NOT NULL,
    tarifaAutocaravanas money NOT NULL,
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
    tipo tipoServicioComplementario,
    precio FLOAT,
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
    fecha date,
    dinero  FLOAT NOT NULL,
    PRIMARY KEY (fecha),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre)
);

CREATE TABLE Vehiculo (
    matricula char(20),
    modelo char(20),
    tipo tipoVehiculo NOT NULL,
    emisiones tipoEmisiones NOT NULL,
    PRIMARY KEY (matricula),
);

CREATE TABLE RegistroEntradaSalida (
    nombreAparcamiento char(20),
    matrVehiculo char(20),
    entrada datetime NOT NULL,
    salida datetime,
    importe FLOAT,                  /*CHECK si el vehiculo tiene un abolo debe ser 0*/ 
    PRIMARY KEY (entredada),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre),
    FOREIGN KEY (matrVehiculo) REFERENCES Vehiculo (matricula)
);

CREATE TABLE Empleado(
    nombreAparcamiento char(20),
    numIdentificacion char(20),
    apellidos char[40] NOT NULL,
    direccion char[30] NOT NULL,
    esGestor bit,
    PRIMARY KEY(numIdentificacion),
    FOREIGN KEY(nombreAparcamiento) REFERENCES Aparcamiento(nombre)
);

CREATE TABLE Usuario(
    numIdentificacion char(20),
    nombre char(20) NOT NULL,
    apellidos char(40) NOT NULL,
    direccion char(30) NOT NULL,
    pmr bit NOT NULL,
    PRIMARY KEY(numIdentificador)
);

CREATE TABLE Solicitud(
    nombreAparcamiento char(20),
    usuario char(20),
    fecha datetime,
    estado estadoSolicitud NOT NULL,
    acreditacion char(10000) NOT NULL,
    tipo tipoSolicitud NOT NULL,
    nif char(20) NOT NULL,
    PRIMARY KEY(fecha),
    FOREIGN KEY(usuario) REFERENCES Usuario(numId),
    FOREIGN KEY(nombreAparcamiento) REFERENCES Aparcamiento(nombre)
);

CREATE TABLE Abono(
    nombreAparcamiento char(20),
    vehiculos char(20),
    plaza INTEGER,
    idAbono char[10],
    precio FLOAT,
    gastosRepercutibles FLOAT,
    fechaInicioContrato date,
    fechaFinContrato date,
    fianza FLOAT,
    mesesEnMorosidad INTEGER,
    horaEntrada time,
    horaSalida time,
    PRIMARY KEY(idAbono),
    FOREIGN KEY(vehiculo) REFERENCES Aparcamiento(matriculaVehiculo),
    FOREIGN KEY(plaza) REFERENCES Aparcamiento(numPlaza)
);

/************************************** Aparcamiento **************************************/
/*
INSERT INTO Aparcamiento VALUES ('UVa', 'C/ Uno', '08:00:00', '20:00:00', 'disponible', 1, 0, 0.1, 0.1, 0.2);
INSERT INTO Plaza VALUES ('UVa', 1, 1, 1, 0, 0, 'turismo');
INSERT INTO ServicioComplementario VALUE ('UVa', 'lavado', 15.3, 'UVa', 1);
*/
/******************************************************************************************/
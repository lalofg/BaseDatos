CREATE TYPE estadoAparcamiento AS ENUM ('disponible', 'limitado', 'suspendido');
CREATE TYPE tipoPlaza AS ENUM ('rotacional', 'residencial');
CREATE TYPE tipoVehiculo AS ENUM ('motocicleta', 'turismo', 'autocaravana');
CREATE TYPE tipoServicioComplementario AS ENUM ('lavado', 'reparacion', 'sustitucionLunas', 'micrologistica', 'alquilerBicicletas');
CREATE TYPE tipoEmisiones AS ENUM ('ECO', 'CERO', 'B', 'C');
CREATE TYPE estadoSolicitud AS ENUM ('aprobado', 'pendiente', 'rechazado')
CREATE TYPE tipoSolicitud AS ENUM ('conReserva24', 'conReservaCesionDeUso', 'sinReservaDiurno', 'sinReservaNocturno')


DROP TABLE Aparcamiento;
DROP TABLE 
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
    tipo tipoServicioComplementario,
    precio FLOAT,
    PRIMARY KEY (tipo),
    FOREIGN KEY (numPlaza) REFERENCES Plaza (numPlaza),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre)
);

CREATE TABLE ReclamacionesYSugerencias (
    cod INTEGER,
    texto text NOT NULL,
    primary key (cod),
    foreign key (nombreAparcamiento) references Aparcamiento (nombre)
);

CREATE TABLE Ingresos (
    fecha date,
    dinero  FLOAT NOT NULL,
    PRIMARY KEY (fecha),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre)
);

CREATE TABLE RegistroEntradaSalida (
    /*idReg INTEGER,*/
    entrada datetime NOT NULL,
    salida datetime,
    importe FLOAT,                  /*CHECK si el vehiculo tiene un abolo debe ser 0*/ 
    PRIMARY KEY (entredada),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre),
    FOREIGN KEY (matrVehiculo) REFERENCES Vehiculo (matricula)
);

CREATE TABLE Vehiculo (
    matricula char(20),
    modelo char(20),
    tipo tipoVehiculo NOT NULL,
    emisiones tipoEmisiones NOT NULL,
    PRIMARY KEY (matricula),
    FOREIGN KEY (abono) REFERENCES Abono (idAbono)  /*Asi o que el abono guarde vehiculos 1..5*/
);

CREATE TABLE Solicitud(
    fecha datetime,
    estado estadoSolicitud NOT NULL,
    acreditacion char(10000) NOT NULL,
    tipo tipoSolicitud NOT NULL,
    nif char(20) NOT NULL,
    PRIMARY KEY(fecha),
    FOREIGN KEY(usuario) REFERENCES Usuario(numId),
    FOREIGN KEY(nombreAparcamiento) REFERENCES Aparcamiento(nombre)
);

CREATE TABLE Usuario(
    numIdentificacion char[20],
    nombre cahr[20] NOT NULL,
    apellidos char[40] NOT NULL,
    direccion char[30] NOT NULL,
    pmr bit NOT NULL,
    PRIMARY KEY(numIdentificador)
);

CREATE TABLE Empleado(
    numIdentificacion char[20]
    apellidos char[40] NOT NULL,
    direccion char[30] NOT NULL,
    esGestor bit,
    PRIMARY KEY(numIdentificacion),
    FOREIGN KEY(nombreAparcamiento) REFERENCES Aparcamiento(nombre)
);

CREATE TABLE Abono(
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
    FOREIGN KEY(Vehiculo) REFERENCES Aparcamiento(matriculaVehiculo),
    FOREIGN KEY(Plaza) REFERENCES Aparcamiento(numPlaza)
);





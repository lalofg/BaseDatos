CREATE TYPE estadoAparcamiento AS ENUM ('disponible', 'limitado', 'suspendido');
CREATE TYPE tipoPlaza AS ENUM ('rotacional', 'residencial');
CREATE TYPE tipoVehiculo AS ENUM ('motocicleta', 'turismo', 'autocaravana');
CREATE TYPE tipoServicioComplementario AS ENUM ('lavado', 'reparacio', 'sustitucionLunas', 'micrologistica', 'alquilerBicicletas');
CREATE TYPE tipoEmisiones AS ENUM ('ECO', 'CERO', 'B', 'C');

DROP TABLE Aparcamiento;
DROP TABLE 
CREATE TABLE Aparcamiento (                                                     
    nombre char(20),
    localizacion char(23) NOT NULL UNIQUE,
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
    numPlaza int,
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
    precio money,
    PRIMARY KEY (tipo),
    FOREIGN KEY (numPlaza) REFERENCES Plaza (numPlaza),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre)
);

CREATE TABLE ReclamacionesYSugerencias (
    cod char(10),
    texto text NOT NULL,
    primary key (cod),
    foreign key (nombreAparcamiento) references Aparcamiento (nombre)
);

CREATE TABLE Ingresos (
    fecha date,
    dinero money NOT NULL,
    PRIMARY KEY (fecha),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre)
);

CREATE TABLE RegistroEntradaSalida (
    idReg char(10),
    entrada datetime NOT NULL,
    salida datetime,
    importe money,                  /*CHECK si el vehiculo tiene un abolo debe ser 0*/ 
    PRIMARY KEY (idReg),
    FOREIGN KEY (nombreAparcamiento) REFERENCES Aparcamiento (nombre),
    FOREIGN KEY (matrVehiculo) REFERENCES Vehiculo (matricula)
);

CREATE TABLE Vehiculo (
    matricula char(20),
    modelo char(20),
    tipo tipoVehiculo,
    emisiones tipoEmisiones,
    PRIMARY KEY (matricula),
    FOREIGN KEY (abono) REFERENCES Abono (idAbono)  /*Asi o que el abono guarde vehiculos 1..5*/
);


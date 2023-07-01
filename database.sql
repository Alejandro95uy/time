create database proyecto;

use proyecto;

create table persona (

	CI integer (8) primary key ,
	primer_nombre varchar (20) not null,
	segundo_nombre varchar (20),
	primer_apellido varchar (20) not null,
	segundo_apellido varchar (20) not null,
	direccion varchar (70) not null,
	existencia integer (1) not null default 1
);

	create view nepersona as
	select * from persona where existencia='0';

	create view epersona as
	select * from persona where existencia='1';

create table tel_per (

	CI integer (8) not null,
	foreign key (CI) references persona (CI),
	telefono integer (9) not null
);

create table no_docente ( 

	CI int (8)  not null,
	foreign key (CI) references persona (CI),
	cargo enum ('Auxiliar','Administrador','Educadores(UAL)','Adscripto','Laboratorista','Dirección'),
	permiso integer (1) not null default 0

);

	create view admin as
	select persona.*, no_docente.cargo from persona, no_docente 
	where persona.CI=no_docente.CI and no_docente.permiso='1';
	
create table docente (
        
	CI int (8) not null,
	foreign key (CI) references persona (CI),
	caracter enum ('Efectivo','Suplente','Interino')
);
	
create table materia (

	ID_materia integer (50) primary key auto_increment,
	materia varchar (50) not null unique

);

create table grupo (

	ID_grupo integer (50) primary key auto_increment,
	grado varchar (50) not null,
	nombre_grupo varchar (50) not null unique
);

create table dictan (

	CI integer (8) not null,
	foreign key (CI) references persona (CI),
        
	ID_grupo integer (50) not null,
	foreign key (ID_grupo) references grupo (ID_grupo),
        
	ID_materia integer (50)not null,
	foreign key (ID_materia) references materia (ID_materia)
);

create table componen (

	ID_grupo integer (50) not null,
	foreign key (ID_grupo) references grupo (ID_grupo),
        
	ID_materia integer (50) not null,
	foreign key (ID_materia) references materia (ID_materia)
);

create table horarios_docente(

	CI integer (8) not null,
	foreign key (CI) references persona (CI),
        
	ID_grupo integer (50) not null,
	foreign key (ID_grupo) references grupo (ID_grupo),
        
	ID_materia integer (50)not null,
	foreign key (ID_materia) references materia (ID_materia),
        
	entrada time not null,
	salida time not null,
	dia_semana enum ('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'),
	turno enum('Matutino','Vespertino','Nocturno')
);

create table horario_no (

	CI integer (8)  not null,
	foreign key (CI) references persona (CI),
	entrada time,
	salida time,
	dia_semana enum ('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado')
	
);

create table motivo(
	
	ID_motivo integer (10) primary key auto_increment,
	motivo varchar (50) unique
);

create table horarios_marcados (

	CI integer (8),
	foreign key (CI) references persona (CI),
	
	ID_motivo integer (10),
	foreign key (ID_motivo) references motivo (ID_motivo),
	
	fecha date ,
	m_entrada time,
	m_salida time
);


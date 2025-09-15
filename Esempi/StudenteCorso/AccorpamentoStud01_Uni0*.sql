-- opzione 1 senza accorpamento

create table Universita (
    nome varchar primary key
);

create table Studente (
    cf CodiceFiscale not null,
    nome varchar not null,
    genere Genere not null,
    primary key (cf)
);

create table iscritto (
    studente CodiceFiscale,
    universita varchar 
    primary key (studente)
    foreign key (studente) references Studente(cf)
    foreign key (universita) references Universita(nome)
);


-- opzione 2 con accorpamento

create table Universita (
    nome varchar primary key
);

create table Studente (
    cf CodiceFiscale,
    nome varchar not null,
    genere Genere not null,
    foreign key universita references Universita(nome)
    v.ennupla: (universita is null) = (iscritto_da is null)
);


Universita(nome: varchar)
Studente(cf: CodiceFiscale, nome: varchar, genere: Genere, universita*: varchar, iscritto_da: Date)
    foreign key universita references Universita(nome)
    v.ennupla: (universita is null) = (iscritto_da is null)



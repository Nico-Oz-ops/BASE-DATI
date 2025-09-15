-- Accorpamento: la tabella che implementa l’associazione ‘iscritto’ viene accorpata 
-- nella tabella che implementa la classe Studente (nota: corrispondenza delle righe 1-1)


-- opzione 1 con accorpamento
create table Universita (
    nome varchar not null
);

create table Studente (
    matricola integer not null,
    nome varchar not null, 
    genere Genere not null, 
    universita varchar not null,
    iscritto_da date date not null
);


Universita(nome: varchar)
Studente(matricola: integer, nome: varchar, genere: Genere, universita: varchar, iscritto_da: Date)
    foreign key (universita) references Universita(nome)



-- opzione 2 senza accorpamento
create table Universita (
    nome varchar not null
);

create table Studente(
    cf CodiceFiscale not null,
    nome varchar not null,
    genere Genere not null
    foreign key studente references Studente(cf)
);

create table iscritto (
    universita varchar,
    studente CodiceFiscale not null
    primary key (cf)
    foreign key (studente) references Studente(cf)
    foreign key (universita) references Universita(nome)
);


Universita(nome: varchar)

Studente(cf: CodiceFiscale, nome: varchar, genere: Genere)
    -- v.inclusione: Studente(cf) occorre in iscritto(studente)
    foreign key Studente(cf) references iscritto(studente)

iscritto(universita: varchar, studente: CodiceFiscale)
    foreign key universita references Universita(nome)
    foreign key studente references Studente(cf)

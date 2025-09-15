-- invece di avere (studente, corso) come primary key, in questo caso decidiamo
-- quale attributo lasciare come chiave primaria e quale come unique key

create table Studente (
    matricola integer not null,
    nome varchar not null, 
    genere Genere not null,
    primary key (matricola)
);

create table Corso (
    nome varchar not null,
    modalita Modalita not null,
    primary key (nome)
);

create table esame (
    studente integer not null,
    corso varchar not null,
    primary key (studente)
    unique (corso)
);

-- oppure 

create table esame (
    studente integer not null,
    corso varchar not null,
    primary key (corso), 
    unique (studente)
)


Studente(matricola: integer, nome: varchar, genere: Genere)
Corso(nome: varchar, modalita: Modalita)
esame(studente: integer, corso: varchar, voto: Voto)
    primary key studente
    unique key corso 
    foreign key studente references Studente(matricola)
    foreign key corso references Corso(nome)

-- oppure 
esame(studente: integer, corso: varchar, voto: Voto)
    primary key corso 
    unique key studente 
    foreign key studente references Studente(matricola)
    foreign key corso references Corso(nome)


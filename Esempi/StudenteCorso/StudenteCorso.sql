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

Studente(matricola: integer, nome: varchar, genere: Genere)
Corso(nome: varchar, modalita*: Modalita) 
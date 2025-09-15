-- Entrambe le classi hanno vincoli di molteplicità 0..*:
-- ciò significa che andremo a creare una primary key (studente, corso)
-- e due foreign key che comprendano il collegamento studente --> Studente(matricola e corso --> Corso(nome))

-- Ogni studente può sostenere zero o più esami relativi a corsi diversi
-- Ogni corso può essere sostenuto in zero o più esami da studenti diversi

create table studente (
    matricola integer not null,
    nome varchar not null,
    genere Genere not null, 
    primary key (matricola)
);

create table corso (
    nome varchar not null,
    modalita Modalita not null, 
    primary key (nome)
);

create table esame (
    studente integer not null,
    corso varchar not null,
    voto Voto not null, 
    primary key (studente, corso),
    foreign key (studente) references Studente(matricola),
    foreign key (corso) references Corso(nome)
);

Studente(matricola: integer, nome: varchar, genere: Genere)
Corso(nome: varchar, modalita*: Modalita) 
esame(studente: integer, corso: varchar, voto: Voto)
foreign key studente references Studente(matricola)
foreign key corso references Corso(nome) 


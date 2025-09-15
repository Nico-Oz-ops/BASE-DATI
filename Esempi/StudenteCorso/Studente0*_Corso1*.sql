-- quando abbiamo il vincolo di molteplicità a 1..* andiamo a scrivere
-- il vincolo di inclusione direttamente nella classe che ha questo vincolo

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
    primary key (studente, corso)
    foreign key (studente) references Studente(matricola)
    foreign key (corso) references Corso(nome)
);


Studente(matricola: integer, nome: varchar, genere: Genere)
Corso(nome: varchar, modalita: Modalita)
    v.inclusione: Corso(nome) occorre in esame(corso)
esame(studente: integer, corso: varchar, voto: Voto)
    primary key (studente, corso) 
    foreign key studente references Studente(matricola)
    foreign key corso references Corso(nome)
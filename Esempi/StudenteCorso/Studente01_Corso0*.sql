
create table Studente (
    matricola integer primary key,
    nome varchar not null, 
    genere Genere not null
);

create table Corso (
    nome varchar not null,
    modalita Modalita not null
    primary key nome
);

create table esame (
    studente integer not null,
    corso varchar not null,
    primary key (studente),
    foreign key (studente) references Studente(matricola),
    foreign key (corso) references Corso(nome)
);


Studente(matricola: integer, nome: varchar, genere: Genere)
Corso(nome: varchar, modalita: Modalita)
esame(studente: integer, corso: varchar, voto: Voto)
    foreign key studente references Studente(matricola)
    foreign key corso references Corso(nome)

-- si aggiungono in entrambe le tabelle il vincolo di inclusione che stabilisce che 
-- l'oggetto della classe Studente(matricola) occorre almeno una volta in esame(studente)
-- e che l'oggetto Corso(nome) occorre almeno una volta in esame(corso)

-- gli attributi (studente, corso) non formano una chiave


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
    v.inclusione: Studente(matricola) occorre in esame(studente)

Corso(nome: varchar, modalita: Modalita)
    v.inclusione: Corso(nome) occorre in esame(corso)

esame(studente: integer, corso: varchar, voto: Voto)
    foreign key studente references Studente(matricola)
    foreign key corso references Corso(nome)
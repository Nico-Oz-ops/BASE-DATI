
create table Studente (
    matricola integer not null,
    nome varchar not null, 
    genere Genere not null,
    universita varchar not null,
    primary key (matricola, universita)
    foreign key universita references Universita(nome)
);

create table Universita (
    nome varchar primary key
);




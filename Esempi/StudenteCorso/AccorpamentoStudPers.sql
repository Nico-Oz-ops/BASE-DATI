
create table Studente (
    matricola integer not null
);

create table Persona (
    cf CodiceFiscale not null,
    nome varchar not null
);

Persona(cf: CodiceFiscale, nome: varchar)
Studente(persona: CodiceFiscale, matricola: integer)
    unique key (matricola)
    foreign key (persona) references Persona(cf)
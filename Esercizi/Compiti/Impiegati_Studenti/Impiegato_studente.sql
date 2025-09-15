begin transaction;

-- Domini

create domain StringaM as varchar(100);
create domain CodiceFiscale as varchar(16)
    check (value ~ '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');
create domain PosInteger as integer
    check (value >= 0);
create domain Importo as real
    check (value >= 0);

-- Schema relazionale

create table Persona (
    id PosInteger not null,
    nome StringaM not null,
    cognome StringaM not null,
    cf CodiceFiscale not null,
    data_nascita date not null,
    is_uomo boolean not null,
    is_donna boolean not null,
    maternita PosInteger null,
    primary key (id),
    unique (cf, data_nascita)

);

create table PosizioneMilitare (
    nome StringaM not null,
    primary key(nome)
);

create table pos_uomo (
    persona PosInteger not null,
    posizionemilitare StringaM not null,
    primary key (persona),
    foreign key (persona) references Persona(id),
    foreign key (posizionemilitare) references PosizioneMilitare(nome)
);

create table Studente (
    matricola PosInteger not null,
    persona PosInteger not null,
    primary key (persona),
    unique (matricola),
    foreign key (persona) references Persona(id)
);

create table Impiegato (
    id PosInteger not null,
    persona PosInteger not null,
    stipendio Importo not null,
    primary key (persona),
    unique (id),
    foreign key (persona) references Persona(id)
);

create table Direttore (
    id PosInteger not null,
    impiegato PosInteger not null,
    primary key (impiegato),
    unique (id),
    foreign key (impiegato) references Impiegato(id)
);

create table Segretario (
    id PosInteger not null,
    impiegato PosInteger not null,
    primary key (impiegato),
    unique (id),
    foreign key (impiegato) references Impiegato(id)
);

create table Progettista (
    id PosInteger not null,
    impiegato PosInteger not null,
    primary key (impiegato),
    unique (id),
    foreign key (impiegato) references Impiegato(id)
);

create table Progetto (
    id PosInteger not null,
    nome StringaM not null,
    progettista PosInteger not null,
    primary key (id),
    foreign key (progettista) references Progettista(impiegato)
);

commit;

create domain Stringa as varchar(100);
create domain Importo as real
    check (value >= 0);
create domain Telefono as varchar(15);
create domain PosInteger as integer
    check (value >= 0);

--schema relazionale

create table Impiegato(
    id PosInteger not null,
    nome Stringa not null,
    cognome Stringa not null,
    nascita timestamp not null,
    stipendio Importo not null,
    primary key(id)
);

create table Dipartimento(
    id PosInteger not null,
    nome Stringa not null,
    telefono Telefono not null,
    primary key(id),
    unique(nome)
    -- v.inclusione: Dipartimento(id) occorre in dirige(dipartimento)
);

create table ProgettoAziendale(
    id PosInteger not null,
    nome Stringa not null,
    budget Importo not null,
    primary key(id),
    unique(nome)
);

create table afferenza(
    impiegato PosInteger not null,
    dipartimento PosInteger not null,
    dataAfferenza timestamp not null,
    primary key (impiegato),
    foreign key (impiegato) references Impiegato(id),
    foreign key (dipartimento) references Dipartimento(id)
);

create table dirige(
    impiegato PosInteger not null,
    dipartimento PosInteger not null,
    primary key(impiegato),
    unique(dipartimento),
    foreign key (impiegato) references Impiegato(id),
    foreign key (dipartimento) references Dipartimento(id)
);

create table imp_prog(
    impiegato PosInteger not null,
    progettoAziendale PosInteger not null,
    dataProgetto timestamp not null,
    primary key(impiegato, progettoAziendale),
    foreign key (impiegato) references Impiegato(id),
    foreign key (progettoAziendale) references ProgettoAziendale(id)
);

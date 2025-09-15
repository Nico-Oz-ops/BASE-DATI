create domain Stringa as varchar(100);
create domain PosInteger as integer
    check (value >= 0);
create domain PosInteger1900 as integer
    check (value > 1900);
create domain DurataMinuti as integer
    check (value > 0);

create table Nazione(
    id PosInteger not null,
    nome Stringa not null,
    primary key (id)
);

create table Citta(
    id PosInteger not null,
    nome Stringa not null,
    abitanti PosInteger not null,
    nazione PosInteger not null,
    primary key(id),
    foreign key (nazione) references Nazione(id)
);

create table CompagniaAerea(
    id PosInteger not null,
    nome Stringa not null,
    fondazione PosInteger1900 not null,
    citta PosInteger not null,
    primary key (id),
    foreign key (citta) references Citta(id)
);

create table Aeroporto(
    id PosInteger not null,
    codice Stringa not null,
    nome Stringa not null,
    citta PosInteger not null,
    primary key(id),
    unique(codice),
    foreign key (citta) references Citta(id)
);

create table Volo(
    id PosInteger not null,
    codice Stringa not null,
    durata_minuti DurataMinuti not null,
    compagnia_aerea PosInteger not null,
    partenza PosInteger not null,
    arrivo PosInteger not null,
    primary key(id),
    unique (codice),
    foreign key (compagnia_aerea) references CompagniaAerea(id),
    foreign key (partenza) references Aeroporto(id),
    foreign key (arrivo) references Aeroporto(id)
    -- v. inclusione: Volo(id) occorre in partenza(volo) 
);


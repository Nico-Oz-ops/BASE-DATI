begin transaction;

-- Domini

create domain StringaM as varchar(100);
create domain CodiceFiscale as varchar(16)
    check (value ~ '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');
create domain PosInteger as integer
    check (value >= 0);
create domain CAP as char(5)
    check (value ~ '^\d{5}$');
create domain Real_0_1 as real
    check (value between 0 and 1);
create domain PartitaIVA as char(11)
    check (value ~ '^\d{11}$')
create domain Importo as real
    check (value >= 0);
create domain Email as varchar(255)
    check (value ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
create domain Telefono as varchar(15)
    check (value ~ '^\+?[0-9]{6,15}$');

create type Stato as enum ('in preparazione', 'inviato', 'da saldare', 'saldato');
create type Indirizzo as (
    via StringaM,
    civico StringaM,
    CAP CAP
);


-- Schema relazionale

create table Nazione (
    nome StringaM not null,
    primary key(nome)
);

create table Regione (
    nome StringaM not null,
    nazione StringaM not null,
    primary key (nome, nazione),
    foreign key (nazione) references Nazione(nome)
);

create table Citta (
    id PosInteger not null,
    nome StringaM not null,
    regione StringaM not null,
    nazione StringaM not null,
    primary key (id),
    unique (nome, regione, nazione),
    foreign key (regione, nazione) references Regione(nome, nazione)
);

create table Direttore (
    id PosInteger not null,
    cf CodiceFiscale not null,
    nome StringaM not null,
    cognome StringaM not null,
    data_nascita date not null,
    anni_servizio PosInteger not null,
    citta PosInteger not null,
    primary key (id),
    unique (cf),
    foreign key (citta) references Citta(id)
);

create table Dipartimento (
    id PosInteger not null,
    nome StringaM not null,
    indirizzo Indirizzo not null,
    direttore PosInteger not null
    primary key (id),
    unique (nome),
    foreign key (direttore) references Direttore(id)
);

create table Ordine (
    id PosInteger not null,
    data_stipula date not null,
    descrizione StringaM not null,
    imponibile Importo not null,
    aliquota_IVA Real_0_1 not null,
    stato Stato not null,
    dipartimento PosInteger not null,
    fornitore PosInteger not null,
    primary key (id),
    foreign key (dipartimento) references Dipartimento(id)
);

create table Fornitore (
    id PosInteger not null,
    ragione_sociale StringaM not null,
    partita_IVA PartitaIVA not null,
    indirizzo Indirizzo not null,
    telefono Telefono not null,
    email Email not null,
    primary key (id)
);

alter table Ordine
add foreign key (fornitore) references Fornitore(id) deferrable;

commit;


begin transaction;

set constraints all deferred;

create domain Stringa as varchar(100);

create domain IntGEZ as integer check (value >= 0);

create domain IntGZ as integer check (value > 0);

create domain Real_0_10 as real check (value >= 0 and value <= 10);

create type colore as ENUM ('Bianco', 'Nero');

create type Indirizzo as (
    via Stringa, 
    civico Stringa
);



create table nazione (
    nome Stringa primary key
);

create table regione (
    nome Stringa not null,
    -- accorpa reg_naz
    nazione Stringa not null, 
    primary key(nome, nazione),
    foreign key(nazione) references nazione(nome)
);

create table citta (
    id integer primary key,
    nome Stringa not null,
    regione Stringa not null,
    nazione Stringa not null,
    foreign key (regione, nazione) references regione(nome, nazione),
    unique (nome, regione, nazione)
);

create table giocatore (
    nickname Stringa primary key,
    nome Stringa not null,
    cognome Stringa not null,
    indirizzo Indirizzo not null,
    rank IntGZ not null,
    citta integer not null, 
    foreign key (citta) references citta(id)
);

create table torneo (
    id integer primary key,
    nome Stringa not null,
    descrizione Stringa not null,
    edizione integer not null
);

create table partita (
    id integer primary key,
    data date not null,
    indirizzo Indirizzo not null,
    komi Real_0_10 not null, 
    citta integer not null, 
    foreign key (citta) references citta(id),

    -- accorpa bianco 
    bianco Stringa not null,
    foreign key (bianco) references giocatore(nickname),

    torneo integer, 
    foreign key (torneo) references torneo(id)

    -- posticipiano la definizione della foreign key verso nero
    -- perché questa ancora non esiste 
);

create table nero (
    partita integer not null,
    giocatore Stringa not null,
    primary key (partita), -- perché può avere un solo giocatore nero!
    foreign key (giocatore) references giocatore(nickname),
    foreign key (partita) references partita(id) deferrable
);

alter table partita
    add constraint partita_nero_fkey
    -- vincolo di inclusione
    foreign key (id) references nero (partita);

create table regole (
    nome Stringa primary key 
);

insert into regole(nome) values
('Giapponesi'),
('Cinesi');

create table PartitaConRinuncia (
    partita integer primary key,
    rinunciatario colore not null,
    foreign key (partita) references partita(id)
);

create table PartitaConPunteggio (
    punteggio_bianco IntGEZ not null,
    punteggio_nero IntGEZ not null,
    partita integer primary key,
    foreign key (partita) references partita(id),
);


commit; 


begin transaction;
set constraints all deferred;
insert into partita(...)
insert into nero (...)
commit; -- solo adesso vengono effettivamente valutati i vincoli






begin transaction;

set constraints all deferred;


create domain Stringa as varchar(100);

create domain IntGZ as integer check (value > 0);

create domain Real_0_10 as real check (value >= 0 and value <= 10);

create domain InGEZ as integer check (value >= 0);

create domain IntGZ_1900 as integer check (value > 1900);

create domain CAP char(5) check (value ~ '^[0-9]{5}$');

create type Colore as enum ('Bianco', 'Nero');

create type Regole as enum ('Cinesi', 'Giapponesi');

create type Indirizzo as (
    via Stringa,
    civico Stringa,    
    cap CAP
);


create table Nazione (
    nome Stringa primary key
);

create table Regione (
    nome Stringa not null,
    nazione Stringa not null,
    primary key (nome, nazione),
    foreign key (nazione) references Nazione(nome)
);

create table Citta (
    id integer not null,
    nome Stringa not null,
    regione Stringa not null,
    nazione Stringa not null,
    primary key (id), 
    foreign key (regione, nazione) references Regione(nome, nazione),
    unique (nome, regione, nazione)
);

create table Giocatore (
    nickname Stringa not null,
    nome Stringa not null,
    cognome Stringa not null,
    indirizzo Indirizzo not null,
    rank_dichiarato IntGZ not null,
    citta integer not null,
    primary key (nickname),
    foreign key citta references Citta(id)
);

create table Partita (
    id integer not null,
    data_partita timestamp not null,
    indirizzo Indirizzo not null,
    komi Real_0_10 not null,
    regole Regole not null,
    nero Stringa not null,
    bianco Stringa not null,
    primary key (id),
    foreign key (nero) references Giocatore(nickname),
    foreign key (bianco) references Giocatore(nickname)
);

create table Torneo (
    id integer not null,
    nome Stringa not null,
    descrizione Stringa not null,
    edizione IntGZ_1900 not null,
    primary key (id)
);

create table partita_torneo (
    partita integer not null,
    torneo integer not null,
    primary key (partita),
    foreign key (partita) references Partita(id),
    foreign key (torneo) references Torneo(id)
);

create table PartitaConRinuncia (
    partita integer not null,
    rinunciatario Colore not null,
    primary key (partita), 
    foreign key (partita) references Partita(id)
);

create table PartitaConPunteggio (
    partita integer not null,
    punteggio_bianco IntGEZ not null, 
    punteggio_nero IntGEZ not null,
    primary key (partita),
    foreign key (partita) references Partita(id)
);


commit;
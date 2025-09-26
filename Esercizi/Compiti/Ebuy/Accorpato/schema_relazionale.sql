create domain StringaM as varchar(100);
create domain Voto as integer
	check (value BETWEEN 0 and 5);

create domain IntGEZ as integer 
	check (value >= 0);

create domain IntGE2 as integer
	check (value >= 2);

create domain URL as text
  check (value ~ '^https?://[a-zA-Z0-9.-]+(\.[a-zA-Z]{2,6})(/.*)?$');

create domain RealGEZ as real 
	check (value >= 0);

create domain RealGZ as real 
	check (value > 0);

create type Condizione as enum ('Ottimo', 'Buono', 'Discreto', 'Da sistemare');
create type Popolarita as enum ('Bassa', 'Media', 'Alta');


begin transaction;

create table Utente (
    username StringaM not null,
    registrazione timestamp not null,
    primary key(username)    
);

create table VenditoreProfessionale (
    utente StringaM not null,
    vetrina URL not null,
    primary key (utente),
    unique(vetrina),
    foreign key (utente) references Utente(username) deferrable
);

create table Privato (
    utente StringaM not null,
    primary key (utente),
    foreign key (utente) references Utente(username) deferrable
);

create table PostOggetto (
    id serial not null,
    descrizione StringaM not null,
    pubblicazione timestamp not null,
    ha_feedback boolean not null default false,
    voto Voto,
    istante_feedback timestamp,
    commento StringaM,
    pubblica StringaM not null,
    categoria StringaM not null, 
    primary key (id),
    unique (id, pubblica),
    check ((ha_feedback = true) = (voto is not null and istante_commento is not null)),
    check ((commento is null or ha_feedback = true)),
    foreign key (pubblica) references Utente(username) deferrable,
    foreign key (categoria) references Categoria(nome) deferrable
);

create table MetodoDiPagamento (
    nome StringaM not null,
    primary key (nome)
);

create table met_post (
    postoggetto IntGEZ not null,
    metodo StringaM not null,
    primary key (postoggetto, metodo),
    foreign key (postoggetto) references PostOggetto(id) deferrable,
    foreign key (metodo) references MetodoDiPagamento(nome) deferrable
);

create table Categoria (
    nome StringaM not null,
    super StringaM,
    primary key (nome),
    check (nome <> super)
);

alter table Categoria add foreign key (super) references Categoria (nome) deferrable;

create table PostOggettoUsato (
    postoggetto IntGEZ not null,
    condizione Condizione not null,
    anni_garanzia IntGEZ not null,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id) deferrable
);

create table PostOggettoNuovo (
    postoggetto IntGEZ not null,
    anni_garanzia IntGE2 not null,
    pubblica_nuovo StringaM not null,
    primary key (postoggetto),
    foreign key (postoggetto, pubblica_nuovo) references PostOggetto(id, pubblica) deferrable,
    foreign key (pubblica_nuovo) references VenditoreProfessionale(utente) deferrable

);

create table CompraloSubito (
    postoggetto IntGEZ not null,
    prezzo RealGZ not null,
    acquirente StringaM,
    istante_acquisto timestamp,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto (id) deferrable,
    foreign key (acquirente) references Privato(utente) deferrable,
    check ((acquirente is null) = (istante_acquisto is null))
);

create table Asta (
    postoggetto IntGEZ not null,
    prezzo_bid RealGZ not null,
    scadenza timestamp not null,
    prezzo_base RealGEZ not null,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id) deferrable
);

create table Bid (
    codice serial not null,
    istante timestamp not null,
    asta IntGEZ not null,
    privato StringaM not null,
    primary key (codice),
    unique (istante, asta),
    foreign key (asta) references Asta(postoggetto) deferrable,
    foreign key (privato) references Privato(utente) deferrable
);

commit;

-- associazione "cat_post" = "categoria"



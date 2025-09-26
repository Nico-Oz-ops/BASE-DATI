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


-- schema relazionale

begin transaction;

create table Utente (
    username StringaM not null,
    registrazione timestamp not null,
    primary key (username)
);

create table VenditoreProfessionale (
    vetrina URL not null,
    utente StringaM not null,
    primary key (utente),
    unique (vetrina),
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
    ha_feedback boolean not null, 
    voto Voto,
    istante_commento timestamp,
    commento StringaM,
    primary key (id),
    check ((ha_feedback = true) = (voto is not null and istante_commento is not null)),
    check (commento is null or ha_feedback = true)

-- v. inclusione: PostOggetto(id) occorre in met_post(postoggetto)

);

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
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id) deferrable
);

create table pubblica (
    utente StringaM not null,
    postoggetto IntGEZ not null,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id) DEFERRABLE INITIALLY DEFERRED,
    foreign key (utente) references Utente (username) deferrable

);

alter table PostOggetto
add foreign key (id) references pubblica(postoggetto) DEFERRABLE INITIALLY DEFERRED;

create table pubblica_nuovo (
    postoggettonuovo IntGEZ not null,
    venditoreprofessionale StringaM not null,
    primary key (postoggettonuovo),
    foreign key (postoggettonuovo) references PostOggettoNuovo(postoggetto) deferrable,
    foreign key (venditoreprofessionale) references VenditoreProfessionale(utente) deferrable
);

alter table PostOggettoNuovo
add foreign key (postoggetto) references pubblica_nuovo(postoggettonuovo) DEFERRABLE INITIALLY DEFERRED;

create table MetodoDiPagamento (
    nome StringaM not null,
    primary key (nome)
);

create table met_post(
    metodo StringaM not null,
    postoggetto IntGEZ not null,
    primary key (metodo, postoggetto),
    foreign key (metodo) references MetodoDiPagamento(nome) deferrable,
    foreign key (postoggetto) references PostOggetto(id) deferrable
);

create table Categoria (
    nome StringaM not null,
    super StringaM,
    primary key (nome),
    check (nome <> super)
);

alter table Categoria
add foreign key (super) references Categoria(nome) deferrable;

create table cat_post (
    categoria StringaM not null,
    postoggetto IntGEZ not null,
    primary key (postoggetto),
    foreign key (categoria) references Categoria(nome) DEFERRABLE INITIALLY DEFERRED,
    foreign key (postoggetto) references PostOggetto(id) DEFERRABLE INITIALLY DEFERRED
);

alter table PostOggetto
add foreign key (id) references cat_post(postoggetto) DEFERRABLE INITIALLY DEFERRED;

create table Asta (
    postoggetto IntGEZ not null,
    prezzo_bid RealGZ not null,
    scadenza timestamp not null,
    prezzo_base RealGEZ not null,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id) deferrable
);

create table CompraloSubito (
    postoggetto IntGEZ not null,
    prezzo RealGZ not null,
    privato StringaM,
    acquirente_istante timestamp,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id) deferrable,
    foreign key (privato) references Privato(utente) deferrable,
    check ((privato is null) = (acquirente_istante is null))

);

create table Bid (
    codice serial not null,
    istante timestamp not null,
    primary key (codice),
    unique (istante)
);

create table asta_bid (
    bid IntGEZ not null,
    asta IntGEZ not null,
    primary key (bid),
    foreign key (bid) references Bid(codice) DEFERRABLE INITIALLY DEFERRED,
    foreign key (asta) references Asta(postoggetto) DEFERRABLE INITIALLY DEFERRED
);

alter table Bid
add foreign key (codice) references asta_bid(bid) DEFERRABLE INITIALLY DEFERRED;

create table bid_ut (
    privato StringaM not null,
    bid IntGEZ not null,
    primary key (bid),
    foreign key (privato) references Privato(utente) DEFERRABLE INITIALLY DEFERRED,
    foreign key (bid) references Bid(codice) DEFERRABLE INITIALLY DEFERRED
);

alter table Bid
add foreign key (codice) references bid_ut(bid) DEFERRABLE INITIALLY DEFERRED;

commit;

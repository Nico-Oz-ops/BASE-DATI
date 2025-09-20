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
    foreign key (utente) references Utente(username)
);

create table Privato (
    utente StringaM not null,
    primary key (utente),
    foreign key (utente) references Utente(username)
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
    check ((ha_feedback = true) = (voto is not null and istante_commento is not null));
    check (commento is null or ha_feedback = true)

    foreign key (id) references pubblica(postoggetto)

    -- v. inclusione: PostOggetto(id) occorre in met_post(postoggetto)

    foreign key (id) references cat_post(postoggetto)
);

create table PostOggettoUsato (
    postoggetto IntGEZ not null,
    condizione Condizione not null,
    anni_garanzia IntGEZ not null,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id)
);

create table PostOggettoNuovo (
    postoggetto IntGEZ not null,
    anni_garanzia IntGE2 not null,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id)

    foreign key (postoggetto) references pubblica_nuovo(postoggettonuovo)

);

create table pubblica_nuovo (
    postoggettonuovo IntGEZ not null,
    venditoreprofessionale StringaM not null,
    primary key (postoggettonuovo),
    foreign key (postoggettonuovo) references PostOggettoNuovo(postoggetto)
    foreign key (venditoreprofessionale) references VenditoreProfessionale(utente)
);

create table pubblica (
    utente StringaM not null,
    postoggetto IntGEZ not null,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id)
    foreign key (utente) references Utente (username)

);

create table MetodoDiPagamento (
    nome StringaM not null,
    primary key (nome)
);

create table met_post(
    metodo StringaM not null,
    postoggetto IntGEZ not null,
    primary key (metodo, postoggetto),
    foreign key (metodo) references MetodoDiPagamento(nome)
    foreign key (postoggetto) references PostOggetto(id)
);

create table Categoria (
    nome StringaM not null,
    super StringaM,
    check (nome <> super)
);

alter table Categoria
add foreign key (super) references Categoria(nome)

create table cat_post (
    categoria StringaM not null,
    postoggetto IntGEZ not null,
    primary key (postoggetto),
    foreign key (categoria) references Categoria(nome)
    foreign key (postoggetto) references PostOggetto(id)
);
 
commit;




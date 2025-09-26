create table Categoria (
    nome StringaM primary key,
    super StringaM,
    check (nome <> super)
);

-- with recursive --
 
alter table Categoria
add foreign key (super) references Categoria(nome)
 
create table Utente (
    username StringaM primary key, 
    registrazione timestamp not null,
);
 
create table Privato (
    utente StringaM primary key,
    foreign key (utente) references Utente(username) deferrable
);
 
create table VenditoreProfessionale (
    utente StringaM primary key,
    vetrina URL not null,
    unique(vetrina),
    foreign key (utente) references Utente(username)
);
 
 
-- [V.utente.compl] e [V.Utente.disj] non ancora implementati
 
create table PostOggetto (
    id serial primary key,
    pubblica StringaM not null,
    unique(id, pubblica), -- chiave non-minimale (serve solo a far funzionare la FK)
    descrizione StringaM not null,
    pubblicazione timestamp not null,
    ha_feedback boolean not null default false,
    voto Voto, 
    commento StringaM,
    istante_feedback timestamp,
    categoria StringaM not null,
    -- vincoli di ennupla per modellare [V.PostOggetto.feedback]
    check((ha_feedback = true)=(voto is not null and istante is not null)),
    check(commento is null or ha_feedback = true),
    foreign key(categoria) references Categoria(nome),
 
    -- v.incl. (id) occorre in met_post(postoggetto)
 
    -- completare con 'pubblica'
    foreign key (pubblica) references Utente(username),
    check(istante_feedback is null or istante_feedback > pubblicazione) -- non è obbligatorio, così si capisce che l'istante del feedback deve essere maggiore della pubblicazione
);
 
create table PostOggettoNuovo (
    postoggetto integer primary key,
    pubblica_nuovo StringaM not null,
    anni_garanzia IntGZ1 not null, 
    foreign key (postoggetto, pubblica_nuovo) references PostOggetto(id, pubblica) deferrable,
    foreign key (pubblica_nuovo)references VenditoreProfessionale(utente)
);

create table PostoOggettoUsato(
    postoggetto integer primary key,
    anni_garanzia IntGEZ not null,
    condizione Condizione not null,
    foreign key (postoggetto) references PostOggetto(id)
);
-- i vincoli {complete,disjoint} su postoggetto nuovo/usato non sono ancora impletanti
-- i vincoli {complete,disjoint} su postoggetto asta/compralosubito non sono ancora impletanti

create table Metodopagamento(
    nome StringaM primary key
);
 
create table met_post (
    postoggetto integer not null,
    metodo StringaM not null, 
    primary key (postoggetto, metodo),
    foreign key (postoggetto) references PostOggetto(id) deferrable,
    foreign key (metodo) references Metodopagamento(nome)
);

create table PostOggettoCompraloSubito(
    postoggetto integer primary key,
    prezzo RealGZ not null,
    acquirente StringaM,
    istante_acquisto timestamp,
    foreign key (postoggetto) references PostOggetto(id) deferrable,
    foreign key (acquirente) references Privato(utente),
    check ((acquirente is null) = (istante_acquisto is null))
);

create table PostOggettoAsta(
    postoggetto integer primary key,
    prezzo_base RealGEZ not null,
    scadenza timestamp not null,
    foreign key (postoggetto) references PostoOggetto(id) deferrable
);

create table Bid(
    codice serial primary key,
    istante timestamp not null,
    asta integer not null,
    privato StringaM not null,
    foreign key (privato) references Privato(utente),
    foreign key (asta) references PostOggettoAsta(postoggetto),
    unique(istante, asta) -- implemente {id2}
);

 
commit;




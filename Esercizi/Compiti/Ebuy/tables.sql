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
    foreign key (utente) references Utente(username)
);
 
create table VenditoreProfessionale (
    utente StringaM primary key,
    vetrina URL not null,
    unique(vetrina)
    foreign key (utente) references Utente(username)
);
 
 
-- [V.utente.compl] e [V.Utente.disj] non ancora implementati
 
create table PostOggetto (
    id serial primary key,
    pubblica StringaM not null,
    descrizione StringaM not null,
    pubblicazione timestamp not null,
    ha_feedback boolean not null,
    voto Voto, 
    commento StringaM,
    istante_feedback timestamp,
    categoria StringaM not null,
    -- vincoli di ennupla per modellare [V.PostOggetto.feedback]
    check(
        (ha_feedback = true)
        =
        (voto is not null and istante is not null)
        ),
    check(commento is null or ha_feedback = true)
    foreign key(categoria) references Categoria(nome)
 
    -- v.incl. (id) occorre in met_post(postoggetto)
 
    -- completare con 'pubblica'
    foreign key (pubblica) references Utente(username)
);
 
create table PostOggettoNuovo (
    postoggetto integer primary key,
    pubblica_nuovo StringaM not null,
    anni_garanzia IntGZ1 not null, 
    foreign key (postoggetto, pubblica_nuovo) references PostOggetto(id, pubblica),
    foreign key (pubblica_nuovo)references VenditoreProfessionale(utente)
);
 
create table Metodopagamento(
    nome StringaM primary key
);
 
create table met_post (
    postoggetto integer not null,
    metodo StringaM not null, 
    primary key (postoggetto, metodo),
    foreign key (postoggetto) references PostOggetto(id)
    foreign key (metodo) references Metodopagamento(nome)
);

create table pubblica (
    postoggetto integer not null,
    utente StringaM not null,
    primary key (postoggetto),
    foreign key (postoggetto) references PostOggetto(id)
    foreign key (utente)
)
 
 
commit;




BEGIN;

-- TABELLE UTENTI
CREATE TABLE Utente (
    username StringaM NOT NULL,
    registrazione timestamp NOT NULL,
    PRIMARY KEY (username)
);

CREATE TABLE VenditoreProfessionale (
    utente StringaM NOT NULL,
    vetrina URL NOT NULL UNIQUE,
    PRIMARY KEY (utente),
    FOREIGN KEY (utente) REFERENCES Utente(username)
);

CREATE TABLE Privato (
    utente StringaM NOT NULL,
    PRIMARY KEY (utente),
    FOREIGN KEY (utente) REFERENCES Utente(username)
);

-- POST OGGETTO
CREATE TABLE PostOggetto (
    id serial NOT NULL,
    descrizione StringaM NOT NULL,
    pubblicazione timestamp NOT NULL,
    ha_feedback boolean NOT NULL,
    voto Voto,
    istante_commento timestamp,
    commento StringaM,
    PRIMARY KEY (id),
    CHECK ((ha_feedback = true) = (voto IS NOT NULL AND istante_commento IS NOT NULL)),
    CHECK (commento IS NULL OR ha_feedback = true)
);

-- POST OGGETTO USATO / NUOVO
CREATE TABLE PostOggettoUsato (
    postoggetto IntGEZ NOT NULL,
    condizione Condizione NOT NULL,
    anni_garanzia IntGEZ NOT NULL,
    PRIMARY KEY (postoggetto),
    FOREIGN KEY (postoggetto) REFERENCES PostOggetto(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE PostOggettoNuovo (
    postoggetto IntGEZ NOT NULL,
    anni_garanzia IntGE2 NOT NULL,
    PRIMARY KEY (postoggetto),
    FOREIGN KEY (postoggetto) REFERENCES PostOggetto(id) DEFERRABLE INITIALLY DEFERRED
);

-- PUBBLICA
CREATE TABLE pubblica (
    utente StringaM NOT NULL,
    postoggetto IntGEZ NOT NULL,
    PRIMARY KEY (postoggetto),
    FOREIGN KEY (postoggetto) REFERENCES PostOggetto(id),
    FOREIGN KEY (utente) REFERENCES Utente(username)
);

-- PUBBLICA NUOVO
CREATE TABLE pubblica_nuovo (
    postoggettonuovo IntGEZ NOT NULL,
    venditoreprofessionale StringaM NOT NULL,
    PRIMARY KEY (postoggettonuovo),
    FOREIGN KEY (postoggettonuovo) REFERENCES PostOggettoNuovo(postoggetto),
    FOREIGN KEY (venditoreprofessionale) REFERENCES VenditoreProfessionale(utente)
);

-- METODI DI PAGAMENTO
CREATE TABLE MetodoDiPagamento (
    nome StringaM NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE met_post (
    metodo StringaM NOT NULL,
    postoggetto IntGEZ NOT NULL,
    PRIMARY KEY (metodo, postoggetto),
    FOREIGN KEY (metodo) REFERENCES MetodoDiPagamento(nome),
    FOREIGN KEY (postoggetto) REFERENCES PostOggetto(id)
);

-- CATEGORIE
CREATE TABLE Categoria (
    nome StringaM NOT NULL,
    super StringaM,
    CHECK (nome <> super),
    PRIMARY KEY (nome),
    FOREIGN KEY (super) REFERENCES Categoria(nome) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE cat_post (
    categoria StringaM NOT NULL,
    postoggetto IntGEZ NOT NULL,
    PRIMARY KEY (postoggetto),
    FOREIGN KEY (categoria) REFERENCES Categoria(nome),
    FOREIGN KEY (postoggetto) REFERENCES PostOggetto(id)
);

-- ASTA / COMPRA SUBITO
CREATE TABLE Asta (
    postoggetto IntGEZ NOT NULL,
    prezzo_bid RealGZ NOT NULL,
    scadenza timestamp NOT NULL,
    prezzo_base RealGEZ NOT NULL,
    PRIMARY KEY (postoggetto),
    FOREIGN KEY (postoggetto) REFERENCES PostOggetto(id)
);

CREATE TABLE CompraloSubito (
    postoggetto IntGEZ NOT NULL,
    prezzo RealGZ NOT NULL,
    privato StringaM,
    acquirente_istante timestamp,
    PRIMARY KEY (postoggetto),
    FOREIGN KEY (postoggetto) REFERENCES PostOggetto(id),
    FOREIGN KEY (privato) REFERENCES Privato(utente),
    CHECK ((privato IS NULL AND acquirente_istante IS NULL) OR
           (privato IS NOT NULL AND acquirente_istante IS NOT NULL))
);

-- BID
CREATE TABLE Bid (
    codice serial NOT NULL,
    istante timestamp NOT NULL UNIQUE,
    PRIMARY KEY (codice)
);

CREATE TABLE asta_bid (
    bid IntGEZ NOT NULL,
    asta IntGEZ NOT NULL,
    PRIMARY KEY (bid),
    FOREIGN KEY (bid) REFERENCES Bid(codice),
    FOREIGN KEY (asta) REFERENCES Asta(postoggetto)
);

CREATE TABLE bid_ut (
    privato StringaM NOT NULL,
    bid IntGEZ NOT NULL,
    PRIMARY KEY (bid),
    FOREIGN KEY (privato) REFERENCES Privato(utente),
    FOREIGN KEY (bid) REFERENCES Bid(codice)
);

COMMIT;
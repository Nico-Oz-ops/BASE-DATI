begin transaction;
    set constraints all deferred;

insert into Categoria(nome, super)
VALUES
('Elettronica', NULL),
('Informatica', 'Elettronica'),
('Laptop', 'Informatica'),
('Casa e giardino', NULL),
('Arredamento', 'Casa e giardino'),
('Giardinaggio', 'Casa e giardino');

insert into Utente(username, registrazione)
VALUES
('U24001', current_timestamp),
('U24002', current_timestamp),
('U24003', current_timestamp),
('U24004', current_timestamp);

insert into Privato(utente)
VALUES
('U24001'),
('U24002');

insert into VenditoreProfessionale(utente, vetrina)
VALUES
('U24003', 'http://example-site.org/docs/page1'),
('U24004', 'https://www.mystore.it');

insert into MetodoDiPagamento(nome)
VALUES
('Carta'),
('Bonifico'),
('PayPal');

insert into PostOggetto(id, descrizione, pubblicazione, pubblica, categoria)
VALUES
(24001, 'IKEA Kallax 4x4', current_timestamp, 'U24004', 'Arredamento'),
(24002, 'Apple MacBook Pro M4 12 core', current_timestamp, 'U24003', 'Laptop'),
(24003, 'Zappa deluxe', current_timestamp, 'U24002', 'Giardinaggio'),
(24004, 'Annaffiatoio deluxe', current_timestamp, 'U24002', 'Giardinaggio'),
(24005, 'Rastrello semi-nuovo', current_timestamp, 'U24002', 'Giardinaggio'),
(24006, 'Comodino Stockholm', current_timestamp, 'U24004', 'Arredamento');

insert into PostOggettoUsato(postoggetto, condizione, anni_garanzia)
VALUES
(24003, 'Ottimo', 0),
(24004, 'Ottimo', 0),
(24005, 'Buono', 0),
(24006, 'Discreto', 1);

insert into PostOggettoNuovo(postoggetto, anni_garanzia, pubblica_nuovo)
VALUES
(24001, 2, 'U24004'),
(24002, 5, 'U24003');

insert into CompraloSubito(postoggetto, prezzo)
VALUES
(24005, 10),
(24002, 2499.99),
(24001, 174.00);

insert into Asta(postoggetto, prezzo_bid, scadenza, prezzo_base)
VALUES
(24003, 1.00, current_timestamp + interval '7 days', 5.00),
(24004, 0.50, current_timestamp + interval '7 days', 1.00),
(24006, 2.00, current_timestamp + interval '3 days', 10.00);

insert into Utente(username, registrazione)
VALUES
('U24005', current_timestamp);

insert into Privato(utente)
VALUES
('U24005');

insert into Bid(codice, istante, asta, privato)
VALUES
(24001, current_timestamp, 24003, 'U24001');

insert into Bid(codice, istante, asta, privato)
VALUES
(24002, current_timestamp, 24003, 'U24005');

insert into Bid(codice, istante, asta, privato)
VALUES
(24003, current_timestamp, 24003, 'U24001');

insert into Bid(codice, istante, asta, privato)
VALUES
(24004, current_timestamp, 24003, 'U24005');

insert into Bid(codice, istante, asta, privato)
VALUES
(24005, current_timestamp, 24003, 'U24001');

insert into Bid(codice, istante, asta, privato)
VALUES
(24006, current_timestamp, 24003, 'U24005');

insert into Bid(codice, istante, asta, privato)
VALUES
(24007, current_timestamp, 24003, 'U24001');

insert into Bid(codice, istante, asta, privato)
VALUES
(24008, current_timestamp, 24003, 'U24005');

commit;
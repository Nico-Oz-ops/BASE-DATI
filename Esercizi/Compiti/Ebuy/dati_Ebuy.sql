BEGIN;

-- Utenti
INSERT INTO Utente(username, registrazione) VALUES
  ('Alice', '2025-01-10 10:00:00'),
  ('Carlo', '2025-02-15 14:30:00'),
  ('Milena', '2025-03-05 09:45:00'),
  ('Diego', '2025-04-12 11:15:00');

-- Venditori professionali
INSERT INTO VenditoreProfessionale(utente, vetrina) VALUES
  ('Alice', 'https://shop.alice.com'),
  ('Carlo', 'https://carlo-store.example.com');

-- Privati
INSERT INTO Privato(utente) VALUES
  ('Milena'),
  ('Diego');

-- Metodi di pagamento
INSERT INTO MetodoDiPagamento(nome) VALUES
  ('CartaCredito'), ('PayPal'), ('Bonifico');

-- Categorie
INSERT INTO Categoria(nome, super) VALUES
  ('Elettronica', NULL),
  ('Cellulari', 'Elettronica'),
  ('Abbigliamento', NULL),
  ('AbitiUomo', 'Abbigliamento');

-- Post oggetti
INSERT INTO PostOggetto(id, descrizione, pubblicazione, ha_feedback, voto, istante_commento, commento) VALUES
  (1, 'iPhone 12 usato', '2025-08-01 12:00:00', true, 4, '2025-08-05 15:30:00', 'In buone condizioni'),
  (2, 'Samsung Galaxy nuovo', '2025-08-02 13:15:00', false, NULL, NULL, NULL),
  (3, 'Giacca invernale taglia L', '2025-08-03 09:20:00', true, 5, '2025-08-04 10:00:00', 'Perfetta'),
  (4, 'Scarpe sportive uomo', '2025-08-04 18:00:00', false, NULL, NULL, NULL);

-- Post oggetti usati
INSERT INTO PostOggettoUsato(postoggetto, condizione, anni_garanzia) VALUES
  (1, 'Buono', 1),
  (3, 'Ottimo', 2),
  (4, 'Discreto', 0);

-- Post oggetti nuovi
INSERT INTO PostOggettoNuovo(postoggetto, anni_garanzia) VALUES
  (2, 1);

-- Pubblica nuovo
INSERT INTO pubblica_nuovo(postoggettonuovo, venditoreprofessionale) VALUES
  (2, 'Carlo');

-- Pubblica
INSERT INTO pubblica(utente, postoggetto) VALUES
  ('Alice', 1),
  ('Carlo', 2),
  ('Milena', 3),
  ('Diego', 4);

-- Metodi di pagamento collegati a post
INSERT INTO met_post(metodo, postoggetto) VALUES
  ('CartaCredito', 1),
  ('PayPal', 2),
  ('Bonifico', 3),
  ('CartaCredito', 4);

-- Categorie dei post
INSERT INTO cat_post(categoria, postoggetto) VALUES
  ('Cellulari', 1),
  ('Cellulari', 2),
  ('AbitiUomo', 3),
  ('AbitiUomo', 4);

-- Asta (solo su un oggetto usato)
INSERT INTO Asta(postoggetto, prezzo_bid, scadenza, prezzo_base) VALUES
  (1, 120.5, '2025-09-01 12:00:00', 100.0);

-- Compralo Subito (un oggetto acquistabile direttamente, senza acquirente ancora)
INSERT INTO CompraloSubito(postoggetto, prezzo, privato, acquirente_istante) VALUES
  (3, 80.0, NULL, NULL);

-- Bid
INSERT INTO Bid(codice, istante) VALUES
  (1, '2025-08-10 11:00:00'),
  (2, '2025-08-15 16:20:00');

-- Collegamento bid-asta
INSERT INTO asta_bid(bid, asta) VALUES
  (1, 1),
  (2, 1);

-- Collegamento bid-utente (Milena fa due offerte)
INSERT INTO bid_ut(bid, privato) VALUES
  (1, 'Milena'),
  (2, 'Milena');

COMMIT;
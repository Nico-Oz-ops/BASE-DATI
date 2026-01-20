-- Esercizio 1: Quali sono i cognomi distinti di tutti gli strutturati?
SELECT DISTINCT cognome
FROM persona;

-- Esercizio 2: Quali sono i Ricercatori (con nome e cognome)?
SELECT id, nome, cognome
FROM persona
WHERE posizione = 'Ricercatore';

-- Esercizio 3: Quali sono i Professori Associati il cui cognome comincia con la lettera ‘V’ ?
SELECT id, nome, cognome
FROM persona 
WHERE posizione = 'Professore Associato'
    AND cognome LIKE 'V%';

-- Esercizio 4: Quali sono i Professori (sia Associati che Ordinari) il cui cognome comincia con la lettera ‘V’ ?
SELECT id, nome, cognome
FROM persona 
WHERE posizione IN ('Professore Associato', 'Professore Ordinario')
    AND cognome LIKE 'V%';

-- Esercizio 5: Quali sono i Progetti già terminati alla data odierna?
SELECT id, nome 
FROM progetto 
WHERE fine <= CURRENT_DATE; 

-- Esercizio 6: Quali sono i nomi di tutti i Progetti ordinati in ordine crescente di data di inizio?
SELECT nome
FROM progetto 
ORDER BY inizio asc;

-- Esercizio 7: Quali sono i nomi dei WP ordinati in ordine crescente (per nome)?
SELECT nome
FROM wp 
ORDER BY nome asc;

-- Esercizio 8: Quali sono (distinte) le cause di assenza di tutti gli strutturati?
SELECT DISTINCT tipo AS causa_assenza
FROM assenza;

-- Esercizio 9: Quali sono (distinte) le tipologie di attività di progetto di tutti gli strutturati?
SELECT DISTINCT tipo AS attivita_progetto
FROM attivitaprogetto;

-- Esercizio 10: Quali sono i giorni distinti nei quali del personale ha effettuato attività non progettuali 
-- di tipo ‘Didattica’ ? Dare il risultato in ordine crescente.
SELECT DISTINCT giorno
FROM attivitanonprogettuale 
WHERE tipo = 'Didattica'
ORDER BY giorno asc;







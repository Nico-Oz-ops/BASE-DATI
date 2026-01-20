-- 1. Elencare tutti i progetti la cui fine è successiva al
-- 2023-12-31. [2 punti]
SELECT *
FROM progetto 
WHERE fine > '2023-12-31';

-- 2. Contare il numero totale di persone per ciascuna posizione
-- (Ricercatore, Professore Associato, Professore Ordinario).
-- [3 punti]
SELECT posizione, COUNT(*) AS num_totale
FROM persona 
GROUP BY posizione;

-- 3. Restituire gli id e i nomi delle persone che hanno almeno
-- un giorno di assenza per "Malattia". [2 punti]
SELECT p.id, p.nome, p.cognome
FROM persona p 
WHERE EXISTS (
    SELECT 1 
    FROM assenza a 
    WHERE a.tipo = 'Malattia'
        AND a.persona = p.id
);

-- 4. Per ogni tipo di assenza, restituire il numero complessivo
-- di occorrenze. [3 punti]
SELECT tipo, COUNT(*) AS num_occorrenze
FROM assenza 
GROUP BY tipo; 

-- 5. Calcolare lo stipendio massimo tra tutti i "Professori
-- Ordinari". [2 punti]
SELECT MAX(stipendio) AS stipendio_max
FROM persona 
WHERE posizione = 'Professore Ordinario';

-- 6. Quali sono le attività e le ore spese dalla persona con id 1
-- nelle attività del progetto con id 4, ordinate in ordine
-- decrescente. Per ogni attività, restituire l’id, il tipo e il
-- numero di ore. [3 punti]
SELECT id, tipo, oreDurata AS num_ore
FROM attivitaprogetto
WHERE persona = 1 AND progetto = 4
ORDER BY oreDurata DESC;

-- 7. Quanti sono i giorni di assenza per tipo e per persona. Per
-- ogni persona e tipo di assenza, restituire nome, cognome,
-- tipo assenza e giorni totali. [4 punti]
SELECT p.id, p.nome, p.cognome, a.tipo, COUNT(a.giorno) AS giorni_totali
FROM persona p 
JOIN assenza a ON p.id = a.persona; 
GROUP BY p.id, p.nome, p.cognome, a.tipo

-- 8. Restituire tutti i “Professori Ordinari” che hanno lo
-- stipendio massimo. Per ognuno, restituire id, nome e
-- cognome [4 punti]
SELECT p.id, p.nome, p.cognome
FROM persona 
WHERE posizione = 'Professore Ordinario'
    AND stipendio = (
        SELECT MAX(stipendio)
        FROM persona 
        WHERE posizione = 'Professore Ordinario'
    );

-- 9. Restituire la somma totale delle ore relative alle attività
-- progettuali svolte dalla persona con id = 3 e con durata
-- minore o uguale a 3 ore. [3 punti]
SELECT SUM(oreDurata) AS ore_totali
FROM attivitaprogetto 
WHERE persona = 3 AND oreDurata <= 3;

-- 10. Restituire gli id e i nomi delle persone che non hanno
-- mai avuto assenze di tipo "Chiusura Universitaria" [4
-- punti]
SELECT p.id, p.nome
FROM persona p 
WHERE NOT EXISTS (
    SELECT 1
    FROM assenza a 
    WHERE a.persona = p.id
        AND a.tipo = 'Chiusura Universitaria'
);

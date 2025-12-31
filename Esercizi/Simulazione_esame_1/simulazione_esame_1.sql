-- 1.​Elencare tutti i progetti la cui fine è successiva al
-- 2023-12-31. [2 punti]​
SELECT *
FROM progetto 
WHERE fine > '2023-12-31';

-- 2.​Contare il numero totale di persone per ciascuna posizione
-- (Ricercatore, Professore Associato, Professore Ordinario).
-- [3 punti]
SELECT posizione, COUNT(*) AS Totale_Posizione
FROM persona
GROUP BY posizione;

-- 3.​Restituire gli id e i nomi delle persone che hanno almeno
-- un giorno di assenza per "Malattia". [2 punti]​
SELECT p.id, p.nome, COUNT(*) AS giorni_malattia
FROM persona p
JOIN assenza a ON a.persona = p.id
WHERE a.tipo = 'Malattia'
GROUP BY p.id, p.nome
HAVING COUNT(*) >= 1;  '''<------questa opzione mi piace'''

-- opzione 2
-- SELECT DISTINCT p.id, p.nome
-- FROM persona p
-- JOIN assenza a ON a.persona = p.id
-- WHERE a.tipo = 'Malattia';   

--opzione 3
-- SELECT p.id, p.nome, COUNT(*) AS giorni_malattia
-- FROM persona p
-- JOIN assenza a ON a.persona = p.id
-- WHERE a.tipo = 'Malattia'
-- GROUP BY p.id, p.nome

-- 4.​Per ogni tipo di assenza, restituire il numero complessivo
-- di occorrenze. [3 punti]
SELECT tipo, COUNT(*) AS occorrenze
FROM assenza 
GROUP BY tipo;

-- 5.​Calcolare lo stipendio massimo tra tutti i "Professori
-- Ordinari". [2 punti]
SELECT MAX(stipendio) AS stipendio_massimo
FROM persona p
WHERE posizione = 'Professore Ordinario';

-- 6.​Quali sono le attività e le ore spese dalla persona con id 1
-- nelle attività del progetto con id 4, ordinate in ordine
-- decrescente. Per ogni attività, restituire l’id, il tipo e il
-- numero di ore. [3 punti]
SELECT id, tipo, oreDurata
FROM AttivitaProgetto
WHERE persona = 1 AND progetto = 4
ORDER BY oreDurata DESC;

-- 7.​Quanti sono i giorni di assenza per tipo e per persona. Per
-- ogni persona e tipo di assenza, restituire nome, cognome,
-- tipo assenza e giorni totali. [4 punti]
SELECT p.nome, p.cognome, a.tipo, COUNT(a.giorno) AS giorni_totali
FROM assenza a
JOIN persona p ON p.id = a.persona
GROUP BY p.nome, p.cognome, a.tipo;

-- 8.​Restituire tutti i “Professori Ordinari” che hanno lo
-- stipendio massimo. Per ognuno, restituire id, nome e
-- cognome [4 punti]​

--opzione 1: subquery
SELECT id, nome, cognome
FROM persona
WHERE posizione = 'Professore Ordinario'
    AND stipendio = (
        SELECT max(stipendio)
        FROM persona
        WHERE posizione = 'Professore Ordinario'
    );

--opzione 2: WITH
WITH mspo AS (
    SELECT MAX(stipendio) AS max_stipendio_PO
    FROM persona p 
    WHERE posizione = 'Professore Ordinario')

SELECT id AS persona_id, nome, cognome
FROM persona, mspo
WHERE posizione = 'Professore Ordinario' 
    AND stipendio = mspo.max_stipendio_PO;

-- versione codice python
-- max_stipendio = float('-inf')
-- persone_max = []
-- for p in persona:
--     if p.stipendio > max_stipendio:
--         max_stipendio = p.stipendio
--         persone_max = [p]
--     elif p.stipendio = max_stipendio:
--         persone_max.append(p)

--opzione 3: GROUP BY + HAVING
SELECT id, nome, cognome
FROM persona
WHERE posizione = 'Professore Ordinario'
GROUP BY id, nome, cognome
HAVING stipendio = (
    SELECT MAX(stipendio) AS max_stipendio_PO
    FROM persona p 
    WHERE posizione = 'Professore Ordinario'
)

--opzione 4 - ALL
SELECT id, nome, cognome
FROM persona
WHERE posizione = 'Professore Ordinario'
    AND stipendio >= ALL (
        SELECT stipendio
        FROM persona
        WHERE posizione = 'Professore Ordinario'
    );

--opzione 5 - NOT EXISTS
SELECT p.id, p.nome, p.cognome
FROM persona p
WHERE posizione = 'Professore Ordinario'
    AND NOT EXISTS (
        SELECT *
        FROM persona P1
        WHERE p1.posizione = 'Professore Ordinario'
            AND p1.stipendio > p.stipendio
    );

-- 9.​Restituire la somma totale delle ore relative alle attività
-- progettuali svolte dalla persona con id = 3 e con durata
-- minore o uguale a 3 ore. [3 punti]​
SELECT SUM(oreDurata) AS ore_totale
FROM AttivitaProgetto
WHERE persona = 3 AND oreDurata <= 3;

-- 10.​ Restituire gli id e i nomi delle persone che non hanno
-- mai avuto assenze di tipo "Chiusura Universitaria" [4
-- punti]

-- opzione 1 - not in
-- SELECT p.id, p.nome
-- FROM persona p
-- WHERE id NOT IN (
--     SELECT persona
--     FROM assenza
--     WHERE tipo = "Chiusura Universitaria"
-- );

-- opzione 2 - left join
SELECT p.id, p.nome
FROM persona p
LEFT JOIN assenza a ON p.id = a.persona AND a.tipo = 'Chiusura Universitaria'
WHERE a.id IS NULL  '''<----mi piace di più'''
/*1. Sottoquery semplice: trovare docenti che hanno più di un progetto*/
SELECT p.id, p.nome, p.cognome
FROM persona p
WHERE p.id IN (
    SELECT ap.persona
    FROM attivitaprogetto ap
    GROUP BY ap.persona 
    HAVING COUNT (DISTINCT ap.progetto) > 1
);

/*2. CTE semplice: ore totali per docente su Pegasus*/
WITH PegasusActivities AS (
    SELECT persona, oreDurata
    FROM attivitaprogetto ap
    JOIN progetto pr ON ap.progetto = pr.id
    WHERE pr.nome = 'Pegasus'
)
SELECT persona, SUM(oreDurata) AS ore_totali
FROM PegasusActivities
GROUP BY persona;

/*3. Sottoquery per filtro condizionale: trovare docenti che hanno dedicato più
di 20 ore alla didattica*/
SELECT p.nome, p.cognome
FROM persona p 
WHERE p.id IN (
    SELECT ap.persona
    FROM attivitanonprogettuale ap 
    WHERE ap.tipo = 'Didattica'
    GROUP BY ap.persona
    HAVING SUM(ap.oreDurata) > 20
);

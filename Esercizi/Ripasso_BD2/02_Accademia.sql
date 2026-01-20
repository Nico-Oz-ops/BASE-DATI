/*1. Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome
‘Pegasus’ ?*/
SELECT wp.nome, wp.inizio, wp.fine
FROM wp 
JOIN progetto pr ON  wp.progetto = pr.id 
WHERE pr.nome = 'Pegasus';

/*2. Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno
una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?*/
SELECT DISTINCT p.nome, p.cognome, p.posizione 
FROM persona p
JOIN attivitaprogetto ap ON p.id = ap.persona 
JOIN progetto pr ON pr.id = ap.progetto 
WHERE pr.nome = 'Pegasus'
ORDER BY p.cognome DESC;

/*3. Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di
una attività nel progetto ‘Pegasus’ ?*/
SELECT p.nome, p.cognome, p.posizione
FROM persona p 
JOIN attivitaprogetto ap ON ap.persona = p.id 
JOIN progetto pr ON pr.id = ap.progetto 
WHERE pr.nome = 'Pegasus'
GROUP BY p.nome, p.cognome, p.posizione
HAVING COUNT(*) > 1;

/*4. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
fatto almeno una assenza per malattia?*/
SELECT p.nome, p.cognome, p.posizione
FROM persona p 
WHERE p.posizione = 'Professore Ordinario'
    AND EXISTS(
        SELECT 1
        FROM assenza a 
        WHERE a.tipo = 'Malattia'
    );

/*5. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
fatto più di una assenza per malattia?*/
SELECT p.nome, p.cognome, p.posizione
FROM persona p 
JOIN assenza a ON a.persona = p.id 
WHERE p.posizione = 'Professore Ordinario'
    AND a.tipo = 'Malattia'
GROUP BY p.nome, p.cognome, p.posizione 
HAVING COUNT(*) > 1;

/*6. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno almeno
un impegno per didattica?*/
SELECT p.nome, p.cognome, p.posizione
FROM persona p 
WHERE p.posizione = 'Ricercatore'
    AND EXISTS (
        SELECT 1
        FROM attivitanonprogettuale anp 
        WHERE anp.tipo = 'Didattica'
    );

/*7. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno più di un
impegno per didattica?*/
SELECT p.nome, p.cognome, p.posizione
FROM persona p 
JOIN attivitanonprogettuale anp ON p.id = anp.persona 
WHERE p.posizione = 'Ricercatore'
    AND anp.tipo = 'Didattica'
GROUP BY p.nome, p.cognome, p.posizione
HAVING COUNT(*) > 1;

/*8. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
attività progettuali che attività non progettuali?*/
SELECT DISTINCT p.nome, p.cognome
FROM persona p 
JOIN attivitanonprogettuale anp ON anp.persona = p.id 
JOIN attivitaprogetto ap ON ap.persona = p.id 
WHERE anp.giorno = ap.giorno;

/*9. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
attività progettuali che attività non progettuali? Si richiede anche di proiettare il
giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di
entrambe le attività.*/
SELECT DISTINCT p.nome, p.cognome, 
    ap.giorno AS giorno_ap,
    pr.nome AS nome_progetto,
    anp.tipo AS tipo_anp,
    anp.oreDurata AS durata_anp,
    ap.oreDurata AS durata_ap 
FROM persona p 
JOIN attivitaprogetto ap ON ap.persona = p.id 
JOIN attivitanonprogettuale anp ON anp.persona = p.id 
JOIN progetto pr ON pr.id = ap.progetto 
WHERE anp.giorno = ap.giorno; 

/*10. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
assenti e hanno attività progettuali?*/
SELECT DISTINCT p.nome, p.cognome
FROM persona p 
JOIN assenza a ON a.persona = p.id 
JOIN attivitaprogetto ap ON ap.persona = p.id 
WHERE ap.giorno = a.giorno 

/*11. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il
nome del progetto, la causa di assenza e la durata in ore della attività progettuale.*/
SELECT DISTINCT p.nome, p.cognome, 
    ap.giorno AS giorno_ap,
    pr.nome AS progetto,
    a.tipo AS causa_assenza,
    ap.oreDurata AS durata_ap
FROM persona p 
JOIN assenza a ON p.id = a.persona 
JOIN attivitaprogetto ap ON ap.persona = p.id 
JOIN progetto pr ON pr.id = ap.progetto 
WHERE a.giorno = ap.giorno;

/*12. Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?*/ 
SELECT wp1.nome 
FROM wp AS wp1
JOIN wp AS wp2 ON wp1.nome = wp2.nome 
WHERE wp1.progetto <> wp2.progetto 

-- Qual è la media e la deviazione standard degli stipendi per ogni categoria di strutturati?
SELECT
    posizione,
    ROUND(AVG(stipendio)::NUMERIC, 2) AS media_stipendio,
    ROUND(STDDEV(stipendio)::NUMERIC, 2) AS deviazione_standard
FROM persona 
GROUP BY posizione;

-- progetti con wp >= 3 attività 
SELECT pr.id, pr.nome 
FROM progetto pr 
JOIN wp on wp.progetto = pr.id 
JOIN attivitaprogetto ap on ap.progetto = pr.id 
    and ap.wp = wp.id 
group by pr.id, pr.nome 
having count(ap.progetto) >= 3

-- progetti senza attività < 4 ore 
SELECT pr.id, pr.nome 
FROM progetto pr 
WHERE NOT EXISTS (
    SELECT 1
    FROM attivitaprogetto ap 
    WHERE ap.progetto = pr.id 
        AND ap.oreDurata < 4
)
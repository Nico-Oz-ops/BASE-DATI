-- 1. Quali sono le persone con stipendio di al massimo 40000
-- euro [2 punti]
SELECT id, nome, cognome
FROM persona 
WHERE stipendio <= 40000;

-- 2. Quali sono i ricercatori che lavorano ad almeno un
-- progetto e hanno uno stipendio di al massimo 40000 [2
-- punti]
SELECT p.id, p.nome, p.cognome
FROM persona p 
WHERE p.stipendio <= 40000
    AND p.posizione = 'Ricercatore'
    AND EXISTS (
        SELECT 1 
        FROM attivitaprogetto ap 
        WHERE ap.persona = p.id
    );

-- 3. Qual è il budget totale dei progetti nel db [2 punti]
SELECT SUM(budget) AS budget_totale
FROM progetto; 

-- 4. Qual è il budget totale dei progetti a cui lavora ogni
-- persona. Per ogni persona restituire nome, cognome e
-- budget totale dei progetti nei quali è coinvolto. [3 punti]
SELECT p.id, p.nome, p.cognome, SUM(pr.budget) AS budget_totale
FROM persona p 
JOIN attivitaprogetto ap ON p.id = ap.persona 
JOIN progetto pr ON pr.id = ap.progetto 
GROUP BY p.id, p.nome, p.cognome;

-- 5. Qual è il numero di progetti a cui partecipa ogni
-- professore ordinario. Per ogni professore ordinario,
-- restituire nome, cognome, numero di progetti nei quali è
-- coinvolto [3 punti]
SELECT p.id, p.nome, p.cognome, COUNT(*) AS num_progetti
FROM persona p 
JOIN attivitaprogetto ap ON p.id = ap.persona 
WHERE p.posizione = 'Professore Ordinario'
GROUP BY p.id, p.nome, p.cognome;

-- 6. Qual è il numero di assenze per malattia di ogni
-- professore associato. Per ogni professore associato,
-- restituire nome, cognome e numero di assenze per
-- malattia [3 punti]
SELECT p.id, p.nome, p.cognome, COUNT(*) AS num_assenze_malattia
FROM persona p 
JOIN assenza a ON p.id = a.persona 
WHERE p.posizione = 'Professore Associato' 
    AND a.tipo = 'Malattia'
GROUP BY p.id, p.nome, p.cognome;

-- 7. Qual è il numero totale di ore, per ogni persona, dedicate
-- al progetto con id ‘5’. Per ogni persona che lavora al
-- progetto, restituire nome, cognome e numero di ore totali
-- dedicate ad attività progettuali relative al progetto [4
-- punti]
SELECT p.id, p.nome, p.cognome, SUM(ap.oreDurata) AS ore_totali
FROM persona p 
JOIN attivitaprogetto ap ON p.id = ap.persona
WHERE ap.progetto = 5
GROUP BY p.id, p.nome, p.cognome;

-- 8. Qual è il numero medio di ore delle attività progettuali
-- svolte da ogni persona. Per ogni persona, restituire nome,
-- cognome e numero medio di ore delle sue attività
-- progettuali (in qualsivoglia progetto) [3 punti]
SELECT p.id, p.nome, p.cognome, ROUND(AVG(ap.oreDurata)::NUMERIC, 2) AS num_medio_ore
FROM persona p 
JOIN attivitaprogetto ap ON p.id = ap.persona 
GROUP BY p.id, p.nome, p.cognome;

-- 9. Qual è il numero totale di ore, per ogni persona, dedicate
-- alla didattica. Per ogni persona che ha svolto attività
-- didattica, restituire nome, cognome e numero di ore totali
-- dedicate alla didattica [4 punti]
SELECT p.id, p.nome, p.cognome, SUM(anp.oreDurata) AS num_ore_totali
FROM persona p 
JOIN attivitanonprogettuale anp ON p.id = anp.persona 
WHERE anp.tipo = 'Didattica'
GROUP BY p.id, p.nome, p.cognome;

-- 10. Quali sono le persone che hanno svolto attività nel WP
-- di id ‘5’ del progetto con id ‘3’. Per ogni persona, restituire
-- il numero totale di ore svolte in attività progettuali per il
-- WP in questione [4 punti]
SELECT p.id, p.nome, p.cognome, SUM(ap.oreDurata) AS ore_totali
FROM persona p 
JOIN attivitaprogetto ap ON p.id = ap.persona 
JOIN wp ON ap.wp = wp.id 
WHERE wp.id = 5 AND ap.progetto = 3
GROUP BY p.id, p.nome, p.cognome;
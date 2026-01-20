/*1. Quanti sono gli strutturati di ogni fascia(posizione)?*/
SELECT posizione, COUNT(*) AS num_strutturati
FROM persona
GROUP BY posizione;

/*2. Quanti sono gli strutturati con stipendio ≥ 40000?*/
SELECT COUNT(*) num_strutturati
FROM persona 
WHERE stipendio >= 40000;

/*3. Quanti sono i progetti già finiti che superano il budget di 50000?*/
SELECT COUNT(*) AS num_progetti
FROM progetto 
WHERE CURRENT_DATE > fine 
	AND budget > 50000;

/*4. Qual è la media, il massimo e il minimo delle ore delle attività relative al progetto
‘Pegasus’ ?*/
SELECT 
	ROUND(AVG(ap.oreDurata)::NUMERIC, 2) AS ore_media,
	MAX(ap.oreDurata) AS ore_max,
	MIN(ap.oreDurata) AS ore_min
FROM progetto pr 
JOIN attivitaprogetto ap ON pr.id = ap.progetto 
WHERE pr.nome = 'Pegasus';

/*5. Quali sono le medie, i massimi e i minimi delle ore giornaliere dedicate al progetto
‘Pegasus’ da ogni singolo docente?*/
SELECT
	p.id,
	p.nome,
	p.cognome,
	ROUND(AVG(ap.oreDurata)::NUMERIC, 2) AS durata_media,
	MAX(ap.oreDurata) AS durata_max,
	MIN(ap.oreDurata) AS durata_min
FROM progetto pr 
JOIN attivitaprogetto ap ON pr.id = ap.progetto 
JOIN persona p ON p.id = ap.persona
WHERE pr.nome = 'Pegasus'
GROUP BY p.id, p.nome, p.cognome; 

/*6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?*/
SELECT p.id, p.nome, p.cognome, SUM(anp.oreDurata) AS ore_totale_didattica
FROM persona p 
JOIN attivitanonprogettuale anp ON p.id = anp.persona
WHERE anp.tipo = 'Didattica'
GROUP BY p.id, p.nome, p.cognome;

/*7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?*/
SELECT
	ROUND(AVG(stipendio)::NUMERIC, 2) AS stipendio_medio,
	MAX(stipendio) AS stipendio_max,
	MIN(stipendio) AS stipendio_min
FROM persona 
WHERE posizione = 'Ricercatore';

/*8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, dei professori
associati e dei professori ordinari?*/
SELECT 
	posizione, 
	ROUND(AVG(stipendio)::NUMERIC, 2) AS stipendio_medio,
	MAX(stipendio) AS stipendio_max,
	MIN(stipendio) AS stipendio_min
FROM persona 
GROUP BY posizione;

/*9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?*/
SELECT pr.nome, SUM(ap.oreDurata)
FROM persona p 
JOIN attivitaprogetto ap ON p.id = ap.persona
JOIN progetto pr ON ap.progetto = pr.id
WHERE p.nome = 'Ginevra' AND p.cognome = 'Riva'
GROUP BY pr.nome;

/*10. Qual è il nome dei progetti su cui lavorano più di due strutturati?*/
SELECT p.nome
FROM progetto p 
JOIN attivitaprogetto ap ON p.id = ap.progetto 
GROUP BY p.nome 
HAVING COUNT (DISTINCT ap.persona) > 2;

/*11. Quali sono i professori associati che hanno lavorato su più di un progetto?*/
SELECT p.id, p.nome, p.cognome
FROM persona p 
JOIN attivitaprogetto ap ON p.id = ap.persona 
WHERE p.posizione = 'Professore Associato'
GROUP BY p.id, p.nome, p.cognome
HAVING COUNT(DISTINCT ap.progetto) > 1;











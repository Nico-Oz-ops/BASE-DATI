/*1. Quanti sono gli strutturati di ogni fascia?*/
SELECT posizione, COUNT(*) as numero
FROM persona
GROUP BY posizione;

/*2. Quanti sono gli strutturati con stipendio ≥ 40000?*/
SELECT COUNT(*) as numero
FROM persona
WHERE stipendio >= 40000;

/*3. Quanti sono i progetti già finiti che superano il budget di 50000?*/
SELECT COUNT(*) as numero
FROM progetto
WHERE budget > 50000
AND CURRENT_DATE > fine;

/*4. Qual è la media, il massimo e il minimo delle ore delle attività relative al progetto
‘Pegasus’ ?*/
SELECT 	AVG(ap.oredurata) as media, 
		MIN(ap.oredurata) as minimo, 
		MAX(ap.oredurata) as massimo 
FROM attivitaprogetto ap
JOIN progetto p ON ap.progetto = p.id
WHERE p.nome = 'Pegasus';

/*5. Quali sono le medie, i massimi e i minimi delle ore giornaliere dedicate al progetto
‘Pegasus’ da ogni singolo docente?*/
SELECT per.id as id_persona, per.nome, per.cognome, 
	AVG(ap.oredurata) as media,
	MIN(ap.oredurata) as minimo,
	MAX(ap.oredurata) as massimo
FROM attivitaprogetto ap
JOIN progetto p ON ap.progetto = p.id
JOIN persona per ON ap.persona = per.id
WHERE p.nome = 'Pegasus'
GROUP BY per.id, per.nome, per.cognome
ORDER BY media DESC;

/*6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?*/
SELECT p.id as id_persona, p.nome, p.cognome, SUM(anp.oreDurata) as ore_didattica
FROM attivitanonprogettuale anp
JOIN persona p ON anp.persona = p.id
WHERE anp.tipo = 'Didattica'
GROUP BY p.id, p.nome, p.cognome
ORDER BY p.id ASC;

/*7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?*/
SELECT 
	AVG(stipendio) as media, 
	MIN(stipendio) as minimo,
	MAX(stipendio) as massimo
FROM persona
WHERE posizione = 'Ricercatore';

/*8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, dei professori
associati e dei professori ordinari?*/
SELECT posizione,
	AVG(stipendio) as media, 
	MIN(stipendio) as minimo,
	MAX(stipendio) as massimo
FROM persona
GROUP BY posizione;

/*9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?*/
SELECT pr.id as id_progetto, pr.nome, SUM(ap.oreDurata) as totale_ore
FROM attivitaprogetto ap
JOIN persona p ON ap.persona = p.id
JOIN progetto pr ON ap.progetto = pr.id
WHERE p.nome = 'Ginevra' AND p.cognome = 'Riva'
GROUP BY pr.id, pr.nome;

/*10. Qual è il nome dei progetti su cui lavorano più di due strutturati?*/
SELECT pr.id as id_progetto, pr.nome as progetto
FROM attivitaprogetto ap
JOIN progetto pr ON ap.progetto = pr.id
GROUP BY pr.id, pr.nome
HAVING COUNT(DISTINCT ap.persona) > 2;

/*11. Quali sono i professori associati che hanno lavorato su più di un progetto?*/
SELECT p.id as id_professore, p.nome, p.cognome
FROM persona p
JOIN attivitaprogetto ap ON ap.persona = p.id
WHERE p.posizione = 'Professore Associato'
GROUP BY p.id, p.nome, p.cognome
HAVING COUNT(DISTINCT ap.progetto) > 1;







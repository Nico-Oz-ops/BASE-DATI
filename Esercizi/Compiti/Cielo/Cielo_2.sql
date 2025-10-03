/*1. Quante sono le compagnie che operano (sia in arrivo che in partenza) nei diversi
aeroporti?*/
SELECT a.codice, a.nome, COUNT(DISTINCT ap.comp) as num_compagnie
FROM aeroporto a
JOIN arrpart ap ON ap.arrivo = a.codice OR ap.partenza = a.codice
GROUP BY a.codice, a.nome;

/*2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ e hanno una durata di almeno
100 minuti?*/
SELECT COUNT(*) as num_voli
FROM volo v
JOIN arrpart ap ON v.codice = ap.codice AND v.comp = ap.comp
WHERE ap.partenza = 'HTR' AND v.durataMinuti >= 100;

/*3. Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, per ogni nazione
nella quale opera?*/
SELECT la.nazione, COUNT(DISTINCT a.codice) as num_aeroporto
FROM aeroporto a
JOIN luogoaeroporto la ON a.codice = la.aeroporto
JOIN arrpart ap ON a.codice = ap.partenza OR a.codice = ap.arrivo
WHERE ap.comp = 'Apitalia'
GROUP BY la.nazione;

/*4. Qual è la media, il massimo e il minimo della durata dei voli effettuati dalla
compagnia ‘MagicFly’ ?*/
SELECT 
	round(AVG(durataminuti)::numeric, 2) as media, 
	MIN(durataminuti) as minimo,
	MAX(durataminuti) as massimo
FROM volo
WHERE comp = 'MagicFly';

/*5. Qual è l’anno di fondazione della compagnia più vecchia che opera in ognuno degli
aeroporti?*/
SELECT a.codice, a.nome, MIN(c.annoFondaz) as anno
FROM aeroporto a
JOIN arrpart ap ON a.codice = ap.arrivo OR a.codice = ap.partenza
JOIN compagnia c ON c.nome = ap.comp
GROUP BY a.codice, a.nome;

/*6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione tramite uno o più
voli?*/
SELECT la1.nazione, COUNT(DISTINCT la2.nazione) as raggiungibili
FROM arrpart ap
JOIN luogoaeroporto la1 ON ap.partenza = la1.aeroporto
JOIN luogoaeroporto la2 ON ap.arrivo = la2.aeroporto
WHERE la1.nazione <> la2.nazione
GROUP BY la1.nazione;

/*7. Qual è la durata media dei voli che partono da ognuno degli aeroporti?*/
SELECT a.codice, a.nome, round(AVG(v.durataminuti)::numeric, 2) as media_durata
FROM aeroporto a
JOIN arrpart ap ON a.codice = ap.partenza 
JOIN volo v ON v.codice = ap.codice AND v.comp = ap.comp
GROUP BY a.codice, a.nome;

/*8. Qual è la durata complessiva dei voli operati da ognuna delle compagnie fondate
a partire dal 1950?*/
SELECT c.nome, SUM(v.durataMinuti) as durata_totale
FROM volo v
JOIN compagnia c ON v.comp = c.nome
WHERE c.annoFondaz >= 1950
GROUP BY c.nome;

/*9. Quali sono gli aeroporti nei quali operano esattamente due compagnie?*/
SELECT a.codice, a.nome
FROM aeroporto a
JOIN arrpart ap ON a.codice = ap.partenza OR a.codice = ap.arrivo
GROUP BY a.codice, a.nome
HAVING COUNT(DISTINCT ap.comp) = 2;

/*10. Quali sono le città con almeno due aeroporti?*/
SELECT citta
FROM luogoaeroporto
GROUP BY citta
HAVING COUNT(aeroporto) >= 2;

/*11. Qual è il nome delle compagnie i cui voli hanno una durata media maggiore di 6
ore?*/
SELECT comp as compagnia
FROM volo
GROUP BY comp
HAVING AVG(durataminuti) > 360;

/*12. Qual è il nome delle compagnie i cui voli hanno tutti una durata maggiore di 100
minuti?*/
SELECT comp as compagnia
FROM volo
GROUP BY comp
HAVING MIN(durataminuti) > 100;




/*BONUS. Quante sono le nazioni (diverse) raggiungibili da ogni nazione tramite uno o più
voli? Bisogna considerare Portogallo nonostante il risultato sia 0*/
SELECT la1.nazione, COUNT(DISTINCT la2.nazione) filter(WHERE la1.nazione<>la2.nazione) as raggiungibili 
FROM arrpart ap
JOIN luogoaeroporto la1 ON ap.partenza = la1.aeroporto
JOIN luogoaeroporto la2 ON ap.arrivo = la2.aeroporto
GROUP BY la1.nazione
ORDER BY raggiungibili ASC;


/*
TROVARE GLI AEROPORTI DAI QUALI NON PARTE NESSUN VOLO
*/
SELECT a.codice, a.nome
FROM aeroporto a
WHERE a.codice NOT IN (
	SELECT DISTINCT ap.partenza
	FROM arrpart ap
);
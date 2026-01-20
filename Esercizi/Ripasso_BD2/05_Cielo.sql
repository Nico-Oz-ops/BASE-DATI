/*1. Quante sono le compagnie che operano (sia in arrivo che in partenza) nei diversi
aeroporti?*/
SELECT COUNT (DISTINCT comp) AS num_compagnie
FROM arrpart;

/*2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ e hanno una durata di almeno
100 minuti?*/
SELECT COUNT(*) AS num_voli
FROM volo v 
JOIN arrpart ap ON ap.comp = v.comp AND v.codice = ap.codice 
WHERE ap.partenza = 'HTR' 
    AND v.durataMinuti >= 100;

/*3. Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, per ogni nazione
nella quale opera?*/
SELECT la.nazione, COUNT(DISTINCT a.codice)
FROM aeroporto a 
JOIN luogoaeroporto la ON a.codice = la.aeroporto 
JOIN arrpart ap ON la.aeroporto = ap.partenza OR la.aeroporto = ap.arrivo
WHERE ap.comp = 'Apitalia'
GROUP BY la.nazione;

/*4. Qual è la media, il massimo e il minimo della durata dei voli effettuati dalla
compagnia ‘MagicFly’ ?*/
SELECT
    ROUND(AVG(durataMinuti)::NUMERIC, 2) AS durata_media,
    MAX(durataMinuti) AS max_durata,
    MIN(durataMinuti) AS min_durata
FROM volo 
WHERE comp = 'MagicFly';

/*5. Qual è l’anno di fondazione della compagnia più vecchia che opera in ognuno degli
aeroporti?*/
SELECT a.codice, a.nome, MIN(c.annoFondaz) AS anno_fondazione
FROM aeroporto a 
JOIN arrpart ap ON a.codice = ap.arrivo OR a.codice = ap.partenza
JOIN compagnia c ON c.nome = ap.comp 
GROUP BY a.codice, a.nome;

/*6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione tramite uno o più
voli?*/
SELECT lp.nazione, COUNT(DISTINCT la.nazione)
FROM arrpart ap 
JOIN luogoaeroporto lp ON lp.aeroporto = ap.partenza
JOIN luogoaeroporto la ON la.aeroporto = ap.arrivo 
WHERE lp.nazione <> la.nazione
GROUP BY lp.nazione;

/*7. Qual è la durata media dei voli che partono da ognuno degli aeroporti?*/
SELECT 
    a.codice,
    a.nome,
    ROUND(AVG(v.durataMinuti)::NUMERIC,2) AS durata_media
FROM volo v 
JOIN arrpart ap ON v.codice = ap.codice AND v.comp = ap.comp 
JOIN aeroporto a ON ap.partenza = a.codice 
GROUP BY a.codice, a.nome
ORDER BY a.codice;

/*8. Qual è la durata complessiva dei voli operati da ognuna delle 
compagnie fondate a partire dal 1950?*/
SELECT c.nome, SUM(v.durataMinuti NOT NULL) AS durata_complessiva
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
SELECT citta, COUNT(aeroporto) AS num_aeroporti 
FROM luogoaeroporto
GROUP BY citta
HAVING COUNT(aeroporto) >= 2;

/*11. Qual è il nome delle compagnie i cui voli hanno una durata media 
maggiore di 6 ore?*/
SELECT comp AS compagnia
FROM volo 
GROUP BY comp 
HAVING AVG(durataMinuti) > 360;

/*12. Qual è il nome delle compagnie i cui voli hanno tutti una durata 
maggiore di 100 minuti?*/
SELECT comp AS compagnia
FROM volo 
GROUP BY comp
HAVING MIN(durataMinuti) > 100;

/*BONUS. Quante sono le nazioni (diverse) raggiungibili da ogni nazione 
tramite uno o più voli? Bisogna considerare Portogallo nonostante il 
risultato sia 0*/
SELECT 
    lp.nazione AS nazione_partenza, 
    COUNT(DISTINCT la.nazione) AS nazioni_raggiungibili
FROM luogoaeroporto lp 
LEFT JOIN arrpart ap 
    ON lp.aeroporto = ap.partenza
LEFT JOIN luogoaeroporto la 
    ON la.aeroporto = ap.arrivo 
    AND lp.nazione <> la.nazione 
GROUP BY lp.nazione;

/*
TROVARE GLI AEROPORTI DAI QUALI NON PARTE NESSUN VOLO
*/
-- Opzione: left join
SELECT a.codice, a.nome
FROM aeroporto a
LEFT JOIN arrpart ap 
    ON a.codice = ap.partenza
WHERE ap.partenza IS NULL;

-- Opzione: sottoquery
SELECT codice, nome
FROM aeroporto 
WHERE codice NOT IN(
    SELECT partenza 
    FROM arrpart 
);

--13. Aeroporti senza voli in arrivo: Trova tutti gli aeroporti nei quali non atterra 
-- alcun volo. Restituisci codice e nome dell’aeroporto.
SELECT a.codice, a.nome
FROM aeroporto a 
LEFT JOIN arrpart ap ON a.codice = ap.arrivo 
WHERE ap.arrivo IS NULL;

--14. Compagnie senza voli: Elenca i nomi delle compagnie che non hanno ancora 
--operato alcun volo.
SELECT c.nome
FROM compagnia c 
LEFT JOIN volo v ON c.nome = v.comp
WHERE v.codice IS NULL;

--15. Aeroporti senza voli della compagnia ‘MagicFly’: Trova tutti gli aeroporti dai quali 
-- non parte nessun volo di MagicFly, mostrando codice e nome aeroporto.
SELECT a.codice, a.nome
FROM aeroporto a 
LEFT JOIN arrpart ap ON a.codice = ap.partenza 
    AND ap.comp = 'MagicFly'
WHERE ap.codice IS NULL;

--16. Aeroporti italiani senza voli verso l’estero: Trova tutti gli aeroporti situati 
-- in Italia dai quali non parte alcun volo verso nazioni diverse dall’Italia. 
-- Restituisci codice, nome e città.
SELECT 
FROM luogoaeroporto la
LEFT JOIN arrpart ap ON la.aeroporto = ap.partenza
    AND la.nazione = 'Italia'
WHERE la.nazione IS NULL


--17. Voli mancanti da città specifiche: Elenca le città in cui ci sono aeroporti ma 
-- non parte nessun volo. Restituisci il nome della città e il numero di aeroporti senza voli.



--18. Compagnie con voli mancanti verso un aeroporto specifico: Trova tutte le compagnie 
-- che non hanno voli in arrivo all’aeroporto ‘JFK’. Restituisci il nome della compagnia.



-- 19. Aeroporti senza voli diretti tra coppie di città: Trova tutti gli aeroporti dalla città 
-- di Roma da cui non parte alcun volo diretto verso New York.



--20. Aeroporti senza voli in partenza: Trova tutti gli aeroporti dai quali non parte alcun volo. 
-- Restituisci codice e nome aeroporto.



--21. Compagnie senza voli: Elenca i nomi delle compagnie che non hanno ancora 
-- operato alcun volo.



--22. Aeroporti senza voli della compagnia ‘MagicFly’: Trova tutti gli aeroporti dai 
-- quali non parte alcun volo della compagnia MagicFly, mostrando codice e nome aeroporto.



--23. Aeroporti italiani senza voli verso l’estero: Trova tutti gli aeroporti in Italia 
-- dai quali non parte alcun volo verso nazioni diverse dall’Italia. 
-- Restituisci codice, nome e città.



--24. Compagnie che non operano su JFK: Elenca tutte le compagnie che non hanno 
-- voli in arrivo all’aeroporto ‘JFK’.
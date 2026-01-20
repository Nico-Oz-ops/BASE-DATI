--Definire in SQL le seguenti interrogazioni, in cui si chiedono tutti risultati distinti:

--1. Quali sono i voli (codice e nome della compagnia) la cui durata supera le 3 ore?
SELECT codice AS codice_volo, comp AS compagnia
FROM volo 
WHERE durataMinuti > 180;

--2. Quali sono le compagnie che hanno voli che superano le 3 ore?
SELECT DISTINCT comp AS compagnia
FROM volo 
WHERE durataMinuti > 180; 

--3. Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto con codice ‘CIA’ ?
SELECT v.codice AS codice_volo, v.comp AS compagnie
FROM volo v 
JOIN arrpart ap ON v.codice = ap.codice AND v.comp = ap.comp 
WHERE ap.partenza = 'CIA';

--4. Quali sono le compagnie che hanno voli che arrivano all’aeroporto con codice ‘FCO’ ?
SELECT DISTINCT v.comp AS compagnie
FROM volo v 
JOIN arrpart ap ON v.codice = ap.codice AND v.comp = ap.comp 
WHERE ap.arrivo = 'FCO';

--5. Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto ‘FCO’ e arrivano all’aeroporto ‘JFK’ ?
SELECT v.codice AS codice_volo, v.comp AS compagnie
FROM volo v 
JOIN arrpart ap ON v.codice = ap.codice AND v.comp = ap.comp 
WHERE ap.partenza = 'FCO'
    AND ap.arrivo = 'JFK';

--6. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’ e atterrano all’aeroporto ‘JFK’ ?
SELECT DISTINCT v.comp AS compagnie
FROM volo v 
JOIN arrpart ap ON v.codice = ap.codice AND v.comp = ap.comp
WHERE ap.partenza = 'FCO'
    AND ap.arrivo = 'JFK';

--7. Quali sono i nomi delle compagnie che hanno voli diretti dalla città di ‘Roma’ alla città di ‘New York’ ?
SELECT DISTINCT ap.comp  
FROM arrpart ap 
JOIN luogoaeroporto lp ON ap.partenza = lp.aeroporto
JOIN luogoaeroporto la ON ap.arrivo = la.aeroporto
WHERE lp.citta = 'Roma'
    AND la.citta = 'New York';

--8. Quali sono gli aeroporti (con codice IATA, nome e luogo) nei quali partono voli della compagnia di nome ‘MagicFly’ ?
SELECT DISTINCT a.codice, a.nome, lp.citta
FROM aeroporto a
JOIN luogoaeroporto lp ON lp.aeroporto = a.codice 
JOIN arrpart ap ON ap.partenza = lp.aeroporto 
WHERE ap.comp = 'MagicFly';

--9. Quali sono i voli che partono da un qualunque aeroporto della città di ‘Roma’ e 
--atterrano ad un qualunque aeroporto della città di ‘New York’ ? Restituire: codice
--del volo, nome della compagnia, e aeroporti di partenza e arrivo.
SELECT 
    v.codice, 
    v.comp AS compagnia, 
    ap.partenza AS partenza, 
    ap.arrivo AS arrivo
FROM volo v 
JOIN arrpart ap ON v.codice = ap.codice AND v.comp = ap.comp 
JOIN luogoaeroporto lp ON lp.aeroporto = ap.partenza
JOIN luogoaeroporto la ON la.aeroporto = ap.arrivo
WHERE lp.citta = 'Roma'
    AND la.citta = 'New York';

--10. Quali sono i possibili piani di volo con esattamente un cambio (utilizzando solo voli 
--della stessa compagnia) da un qualunque aeroporto della città di ‘Roma’ ad un qualunque 
--aeroporto della città di ‘New York’ ? Restituire: nome della compagnia, codici dei voli, 
--e aeroporti di partenza, scalo e arrivo.
SELECT DISTINCT 
    ap1.comp, 
    ap1.codice AS codice_volo_1, 
    ap1.partenza AS partenza,
    ap1.arrivo AS scalo,
    ap2.codice AS codice_volo_2,
    ap2.arrivo AS arrivo
FROM arrpart ap1
JOIN arrpart ap2 ON ap1.arrivo = ap2.partenza 
    AND ap1.comp = ap2.comp 
JOIN luogoaeroporto lp ON lp.aeroporto = ap1.partenza 
JOIN luogoaeroporto ls ON ls.aeroporto = ap1.arrivo
JOIN luogoaeroporto la ON la.aeroporto = ap2.arrivo 
WHERE lp.citta = 'Roma'
    AND la.citta = 'New York'
    AND ls.citta <> lp.citta 
    AND ls.citta <> la.citta;

--11. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’, atterrano 
--all’aeroporto ‘JFK’, e di cui si conosce l’anno di fondazione?
SELECT DISTINCT c.nome
FROM compagnia c 
JOIN volo v ON c.nome = v.comp
JOIN arrpart ap ON v.comp = ap.comp AND v.codice = ap.codice 
WHERE ap.partenza = 'FCO'
    AND ap.arrivo = 'JFK'
    AND c.annoFondaz IS NOT NULL;


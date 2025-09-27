--Definire in SQL le seguenti interrogazioni, in cui si chiedono tutti risultati distinti:


--1. Quali sono i voli (codice e nome della compagnia) la cui durata supera le 3 ore?

select codice, comp
from volo
where durataminuti > 180

--2. Quali sono le compagnie che hanno voli che superano le 3 ore?

select distinct comp
from volo
where durataminuti > 180

--3. Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto con codice ‘CIA’ ?

select codice, comp
from arrpart
where partenza = 'CIA'

--4. Quali sono le compagnie che hanno voli che arrivano all’aeroporto con codice ‘FCO’ ?

select distinct comp
from arrpart
where arrivo = 'FCO'

--5. Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto ‘FCO’ e arrivano all’aeroporto ‘JFK’ ?

select codice, comp
from arrpart
where partenza = 'FCO'
and arrivo = 'JFK'

--6. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’ e atterrano all’aeroporto ‘JFK’ ?

select distinct comp
from arrpart
where partenza = 'FCO'
and arrivo = 'JFK'

--7. Quali sono i nomi delle compagnie che hanno voli diretti dalla città di ‘Roma’ alla città di ‘New York’ ?

select distinct comp
from arrpart a
join luogoaeroporto l1 on a.partenza = l1.aeroporto
join luogoaeroporto l2 on a.arrivo = l2.aeroporto
where l1.citta = 'Roma'
and l2.citta = 'New York'

--8. Quali sono gli aeroporti (con codice IATA, nome e luogo) nei quali partono voli della compagnia di nome ‘MagicFly’ ?

select a.codice, a.nome, l.citta
from arrpart ar
join luogoaeroporto l on ar.partenza = l.aeroporto
join aeroporto a on ar.partenza = a.codice
where ar.comp = 'MagicFly'

--9. Quali sono i voli che partono da un qualunque aeroporto della città di ‘Roma’ e atterrano ad un qualunque aeroporto 
--della città di ‘New York’ ? Restituire: codice
--del volo, nome della compagnia, e aeroporti di partenza e arrivo.

select ar.codice, ar.comp, ar.partenza, ar.arrivo
from arrpart ar
join luogoaeroporto l1 on ar.partenza = l1.aeroporto
join luogoaeroporto l2 on ar.arrivo = l2.aeroporto
where l1.citta = 'Roma'
and l2.citta = 'New York'

--10. Quali sono i possibili piani di volo con esattamente un cambio (utilizzando solo voli della stessa compagnia) 
--da un qualunque aeroporto della città di ‘Roma’ ad un qualunque aeroporto della città di ‘New York’ ? 
--Restituire: nome della compagnia, codici dei voli, e aeroporti di partenza, scalo e arrivo.

select ar1.comp as compagnia, ar1.codice as codice_volo_1, ar1.partenza as partenza, 
ar1.arrivo as scalo, ar2.codice as codice_volo_2, ar2.partenza as arrivo
from arrpart ar1
join arrpart ar2 on ar1.comp = ar2.comp and ar1.arrivo = ar2.partenza
join luogoaeroporto l1 on ar1.partenza = l1.aeroporto
join luogoaeroporto l2 on ar2.arrivo = l2.aeroporto
where l1.citta = 'Roma'
and l2.citta = 'New York'

--11. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’, atterrano all’aeroporto ‘JFK’, 
--e di cui si conosce l’anno di fondazione?

select distinct nome
from arrpart a, compagnia c
where a.partenza = 'FCO'
and a.arrivo = 'JFK'
and a.comp = c.nome
and c.annoFondaz is not null

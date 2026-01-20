-- 1. Gli operatori devono
-- poter calcolare l’insieme delle aree verdi fruibili che hanno almeno un soggetto verde
-- della specie 'Pinus pinea' e piantata almeno 5 anni fa.
SELECT DISTINCT av.id, av.lat, av.lon
FROM areaverde av
JOIN soggettoverde sv ON sv.area = av.id
WHERE av.is_fruibile = true AND
    sv.specie = 'Pinus pinea' AND
    sv.data <= CURRENT_DATE - INTERVAL '5 years';

-- 2. Il management deve poter calcolare, l’insieme delle aree verdi sensibili che non sono state 
-- oggetto di alcun intervento nel periodo '2023-10-9' - '2023-10-13'

-- SOLUZIONE 1: NOT EXISTS
SELECT av.id, av.lat, av.lon
FROM areaverde av
WHERE av.is_sensibile = true
    AND NOT EXISTS (
        SELECT i.id
        FROM intervento i
        JOIN interventoassegnato ia on ia.id_intervento = i.id 
        WHERE i.area = av.id
            AND (i.inizio, ia.fine)  OVERLAPS  ('2023-10-9' , '2023-10-13')
    );

-- SOLUZIONE 2: NOT IN (più efficente questa opzione) -- vdersione prof
SELECT av.id, av.lat, av.lon
FROM areaverde av
WHERE av.is_sensibile = true
    AND av.id NOT IN (
        SELECT i.id
        FROM intervento i
        JOIN interventoassegnato ia on ia.id_intervento = i.id 
        WHERE (i.inizio, ia.fine)  OVERLAPS  ('2023-10-9' , '2023-10-13')
    );

-- SOLUZIONE 3: OUTER JOIN -- versione prof 
SELECT a.id AS area, i.id AS id_interv, i.inizio, ia.fine
FROM areaverde a 
LEFT JOIN intervento i ON a.id = i.area 
LEFT JOIN interventoassegnato ia ON a.id = ia.id_intervento
    AND (i.inizio, ia.fine)  OVERLAPS  ('2023-10-9' , '2023-10-13')
WHERE i.id is null;

-- 3. I dipendenti
-- comunali devono poter ottenere dal sistema gli operatori ai quali è stato assegnato il
-- minor numero di interventi con priorità maggiore o uguale a 5 nell'anno 2023.
WITH conteggi AS (
    SELECT a.operatore, COUNT(DISTINCT i.id) AS num_interventi
    FROM assegna a
    JOIN interventoassegnato ia ON ia.id_intervento = a.interventoassegnato
    JOIN intervento i ON i.id = ia.id_intervento
    WHERE i.priorita >= 5
        i.inizio = 2023
    GROUP BY a.operatore
)

SELECT o.*
FROM conteggi c 
JOIN operatore o ON o.cf = c.operatore
WHERE c.num_interventi = (
    SELECT MIN(num_interventi)
    FROM conteggi
);

-- Bonus - tutti gli operatori ai quali sono stati  assegnati
-- al massimo due interventi
SELECT o.cf, o.nome, o.cognome
FROM operatore o, intervento i, assegna a
WHERE a.operatore = o.cf
    AND a.interventoassegnato = i.id
    AND i.priorita >= 5
    AND EXTRACT(YEAR FROM a.istante) = 2023
GROUP BY o.cf
HAVING COUNT(*) <= 2;

-- 4. restituire tutte le aree verdi con almeno 10 soggetti verdi
SELECT av.id, av.lat, av.lon, av.is_fruibile, av.is_sensibile
FROM areaverde av
JOIN soggettoverde sv ON sv.area = av.id
GROUP BY av.id, av.lat, av.lon, av.is_fruibile, av.is_sensibile
HAVING COUNT(*) >= 10;

-- 5. il numero di operatori che sono stati assegnati almeno una volta ad interventi con priorità < 4
SELECT COUNT(*) AS num_operatori
FROM operatore o
WHERE EXISTS (
    SELECT 1
    FROM assegna a
    JOIN interventoassegnato ia ON ia.id_intervento = a.interventoassegnato
    JOIN intervento i ON i.id = ia.id_intervento
    WHERE a.operatore = o.cf
      AND i.priorita < 4
);

-- 6. la durata prevista media e la durata effettiva media degli interventi completati.
SELECT
    AVG(i.durata) AS durata_prevista_media,
    AVG(ia.fine - i.inizio) AS durata_effettiva_media
FROM intervento i
JOIN interventoassegnato ia ON ia.id_intervento = i.id
WHERE EXISTS (
    SELECT 1
    FROM interventoassegnato ia2
    WHERE ia2.id_intervento = i.id
      AND ia2.fine IS NOT NULL
);

-- 7. gli operatori assegnati all'intervento più lungo
SELECT DISTINCT o.cf, o.nome, o.cognome
FROM operatore o
JOIN assegna a ON a.operatore = o.cf
JOIN intervento i ON i.id = a.interventoassegnato
WHERE i.durata = (
    SELECT MAX(durata)
    FROM intervento
);

-- 8. il numero degli interventi non terminati assegnati ad aree verdi non sensibili
SELECT COUNT(*) AS num_interventi
FROM intervento i
JOIN interventoassegnato ia ON ia.id_intervento = i.id
JOIN areaverde av ON av.id = i.area
WHERE ia.fine IS NULL
  AND av.is_sensibile = false;

-- 9. le aree verdi senza nessun soggetto verde.
SELECT av.id, av.lat, av.lon, av.is_fruibile, av.is_sensibile
FROM areaverde av
WHERE NOT EXISTS (
    SELECT 1
    FROM soggettoverde sv
    WHERE sv.area = av.id
);



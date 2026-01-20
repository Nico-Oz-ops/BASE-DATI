--Elencare tutti i progetti la cui fine è successiva al 2023-12-31
SELECT *
FROM progetto
WHERE fine > '2023-12-31';

-- Contare il numero totale di persone per ciascuna posizione (Ricercatore, 
--Professore Associato, Professore Ordinario).


-- Restituire gli id e i nomi delle persone che hanno almeno un giorno 
--di assenza per "Malattia".


-- Per ogni tipo di assenza, restituire il numero complessivo di occorrenze


-- Calcolare lo stipendio massimo tra tutti i "Professori Ordinari"


-- Quali sono le attività e le ore spese dalla persona con id 1 nelle  attività
--del  progetto  con  id  4,  ordinate  in  ordine decrescente.
--Per  ogni  attività,  restituire  l’id,  il  tipo  e  il numero di ore


-- Quanti sono i giorni di assenza per tipo e per persona. Per ogni persona 
--e tipo di assenza, restituire nome, cognome, tipo assenza e giorni totali.


-- Restituire tutti i “Professori Ordinari” che hanno lo stipendio massimo. 
--Per ognuno, restituire id, nome e cognome


-- Restituire la somma totale delle ore relative alle attività progettuali 
--svolte dalla persona con id = 3 e con durata minore o uguale a 3 ore


-- Restituire gli id e i nomi delle persone che non hanno mai avuto 
--assenze di tipo "Chiusura Universitaria" 

/*1. Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome
‘Pegasus’ ?*/

select w.id, w.nome, w.inizio, w.fine
from wp w
join progetto p on w.progetto = p.id
where p.nome = 'Pegasus'

/*2. Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno
una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?*/

select distinct p.id, p.nome, p.cognome, p.posizione
from persona p
join attivitaprogetto ap on p.id = ap.persona
join progetto pr on ap.progetto = pr.id
where pr.nome = 'Pegasus'
order by p.cognome desc

/*3. Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di
una attività nel progetto ‘Pegasus’ ?*/

select p.id, p.nome, p.cognome, p.posizione
from persona p
join attivitaprogetto ap on p.id = ap.persona
join progetto pr on ap.progetto = pr.id
where pr.nome = 'Pegasus'
group by p.id, p.nome, p.cognome, p.posizione
having count (p.nome) > 1

/*4. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
fatto almeno una assenza per malattia?*/

select distinct p.id, p.nome, p.cognome
from persona p
join assenza a on p.id = a.persona
where a.tipo = 'Malattia' and p.posizione = 'Professore Ordinario'
group by p.id, p.nome, p.cognome, p.posizione
having count (p.nome) >= 1

/*5. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
fatto più di una assenza per malattia?*/

select distinct p.id, p.nome, p.cognome
from persona p
join assenza a on p.id = a.persona
where a.tipo = 'Malattia' and p.posizione = 'Professore Ordinario'
group by p.id, p.nome, p.cognome, p.posizione
having count (p.nome) > 1

/*6. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno almeno
un impegno per didattica?*/

select distinct p.id, p.nome, p.cognome
from persona p
join attivitanonprogettuale ap on p.id = ap.persona
where ap.tipo = 'Didattica' and p.posizione = 'Ricercatore'
group by p.id, p.nome, p.cognome, p.posizione
having count (p.nome) >= 1

/*7. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno più di un
impegno per didattica?*/

select distinct p.id, p.nome, p.cognome
from persona p
join attivitanonprogettuale ap on p.id = ap.persona
where ap.tipo = 'Didattica' and p.posizione = 'Ricercatore'
group by p.id, p.nome, p.cognome, p.posizione
having count (p.nome) > 1

/*8. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
attività progettuali che attività non progettuali?*/

select p.id, p.nome, p.cognome
from persona p
join attivitaprogetto ap on p.id = ap.persona
join attivitanonprogettuale anp on p.id = anp.persona
where ap.giorno = anp.giorno

/*9. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
attività progettuali che attività non progettuali? Si richiede anche di proiettare il
giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di
entrambe le attività.*/

select p.id, p.nome, p.cognome, ap.giorno, pr.nome as prj, ap.oreDurata as h_prj, 
anp.tipo as att_noproj, anp.oreDurata as h_noproj
from persona p
join attivitaprogetto ap on p.id = ap.persona
join progetto pr on ap.progetto = pr.id
join attivitanonprogettuale anp on p.id = anp.persona
where ap.giorno = anp.giorno

/*10. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
assenti e hanno attività progettuali?*/

select p.id, p.nome, p.cognome
from persona p
join attivitaprogetto ap on p.id = ap.persona
join assenza a on p.id = a.persona
where ap.giorno = a.giorno

/*11. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il
nome del progetto, la causa di assenza e la durata in ore della attività progettuale.*/

select p.id, p.nome, p.cognome, a.giorno as giorno, a.tipo as causa_ass,
pr.nome as progetto, ap.oreDurata as ore_att_prj
from persona p
join attivitaprogetto ap on p.id = ap.persona
join progetto pr on ap.progetto = pr.id
join assenza a on p.id = a.persona
where ap.giorno = a.giorno

/*12. Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?*/ 

select distinct w1.nome
from wp w1
join wp w2 on w1.nome = w2.nome
and w1.progetto <> w2.progetto

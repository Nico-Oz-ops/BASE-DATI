create type Strutturato as
	enum ('Ricercatore', 'Professore Associato', 'Professore Ordinato');
create type LavoroProgetto as
	enum ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');
create type LavoroNonProgettuale as
	enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');
create type CausaAssenza as
	enum ('Chiusura Universitaria', 'Maternita', 'Malattia');
create domain PosInteger as integer
	check (value >= 0);
create domain StringaM as varchar(100);
create domain NumeroOre as integer 
	check (value >= 0 and value <= 8);
create domain Denaro as real
	check (value >= 0);


--schema relazionale

create table Persona(
	id PosInteger not null,
	nome StringaM not null,
	cognome StringaM not null,
	posizione Strutturato not null,
	stipendio Denaro not null,
	primary key (id)
);
create table Progetto(
	id PosInteger not null,
	nome StringaM not null,
	inizio date not null,
	fine date not null,
	budget Denaro not null,
	primary key (id),
	unique (nome),
	check (inizio < fine)
);
create table WP(
	progetto PosInteger not null,
	id PosInteger not null,
	nome StringaM not null,
	inizio date not null,
	fine date not null,
	primary key (progetto, id),
	check (inizio < fine),
	unique (progetto, nome),
	foreign key (progetto) references Progetto(id)
);
create table AttivitaProgetto(
	id PosInteger not null,
	persona PosInteger not null,
	progetto PosInteger not null,
	wp PosInteger not null,
	giorno date not null,
	tipo LavoroProgetto not null,
	oreDurata NumeroOre not null,
	primary key (id),
	foreign key (persona) references Persona(id),
	foreign key (progetto, wp) references WP(progetto, id)
);
create table AttivitaNonProgettuale(
	id PosInteger not null,
	persona PosInteger not null,
	tipo LavoroNonProgettuale not null,
	giorno date not null,
	oreDurata NumeroOre not null,
	primary key (id),
	foreign key (persona) references Persona(id)
);
create table Assenza(
	id PosInteger not null,
	persona PosInteger not null,
	tipo CausaAssenza not null,
	giorno date not null,
	primary key (id),
	unique (persona, giorno),
	foreign key (persona) references Persona(id)
);

insert into Persona(id, nome, cognome, posizione, stipendio)
values 
(1, 'Larry', 'Chong', 'Ricercatore', 2000),
(2, 'Mario', 'Rossi', 'Professore Ordinato', 1600),
insert into Persona(id, nome, cognome, posizione, stipendio)
values 
(3, 'Jerry', 'Ventura', 'Professore Ordinato', 1600),
(4, 'Nicolò', 'Bianchi', 'Ricercatore', 2250),
(5, 'Mariano', 'Mela', 'Professore Associato', 1500);

insert into Persona(id, nome, cognome, posizione, stipendio) 
values
(355590, 'Luca', 'Bianchi', 'Ricercatore', 41134),
(166385, 'Maria', 'Rossi', 'Professore Associato', 87507),
(442255, 'Andrea', 'Esposito', 'Professore Associato', 51735),
(357534, 'Giulia', 'Romano', 'Ricercatore', 59141),
(343530, 'Marco', 'Conti', 'Professore Ordinario', 82565),
(987004, 'Lolo', 'Panda', 'Professore Associato', 82631),
(823734, 'Matteo', 'De Luca', 'Ricercatore', 35173),
(550963, 'Chiara', 'Ferri', 'Ricercatore', 80499),
(873295, 'Elisa', 'Greco', 'Professore Associato', 47759),
(567352, 'Sara', 'Moretti', 'Professore Associato', 92108),
(534852, 'Alessandro', 'Galli', 'Ricercatore', 54616),
(240126, 'Francesca', 'Parisi', 'Professore Ordinario', 37539),
(146121, 'Davide', 'Rinaldi', 'Professore Ordinario', 71601),
(353376, 'Nicolò', 'Gattò', 'Professore Associato', 77731),
(405727, 'Lorenzo', 'Marchetti', 'Ricercatore', 31877),
(350426, 'Martina', 'Leone', 'Ricercatore', 68485),
(174656, 'Laura', 'Costa', 'Professore Associato', 41053),
(475313, 'Alice', 'Ricci', 'Professore Associato', 34159),
(947510, 'Nicola', 'Fontana', 'Professore Ordinario', 48285),
(486087, 'Simone', 'Barbieri', 'Professore Ordinario', 27423),
(777840, 'Ilaria', 'Cattaneo', 'Ricercatore', 85185),
(45611, 'Giovanni', 'Sartori', 'Professore Ordinario', 77630),
(747623, 'Valentina', 'Fabbri', 'Ricercatore', 93640),
(914242, 'Beatrice', 'Pellegrini', 'Professore Associato', 73630),
(795821, 'Riccardo', 'Vitale', 'Professore Ordinario', 88270);

insert into Progetto(id, nome, inizio, fine, budget) values 
(47889, 'Security', '02/11/2025', '09/03/2026', 25000),
(42163, 'R3', '18/05/2025', '16/10/2025', 14000),
(49631, 'Tor93', '17/07/2025', '19/09/2026', 18000),
(49648, 'Roma69', '01/01/2025', '03/07/2025', 16000),
(47846, 'Giga71', '20/10/2024', '18/04/2025', 22000);

insert into WP(progetto, id, nome, inizio, fine) values
(47889, 2, 'Dissemination', '29/01/2023', '15/07/2025'),
(42163, 1, 'Main Activity', '15/02/2024', '10/06/2024'),
(49631, 3, 'Main Research', '10/08/2024', '11/03/2025'),
(49648, 4, 'WP1', '08/02/2025', '10/04/2025'),
(47846, 5, 'WP2', '04/01/2024', '07/07/2024');

insert into Assenza(id, persona, tipo, giorno) values
(1, 355590, 'Malattia', '14/02/2025'),
(2, 987004, 'Chiusura Universitaria', '09/01/2025'),
(3, 166385, 'Maternita', '18/03/2025'),
(4, 947510, 'Malattia', '01/04/2025'),
(5, 795821, 'Chiusura Universitaria', '25/12/2024');

insert into AttivitaProgetto(id, persona, progetto, wp, giorno, tipo, oreDurata) values
(14785, 1, 47889, 2, '18/06/2025', 'Ricerca e Sviluppo', 8),
(13577, 2, 47889, 2, '14/04/2025', 'Dimostrazione', 6),
(17587, 3, 42163, 1, '13/03/2024', 'Management', 4),
(18546, 4, 42163, 1, '01/04/2024', 'Altro', 5),
(14587, 5, 49648, 4, '01/04/2024', 'Ricerca e Sviluppo', 8);

insert into AttivitaNonProgettuale(id, persona, tipo, giorno, oreDurata) values
(15975, 350426, 'Didattica', '14/11/2024', 3),
(17531, 174656, 'Ricerca', '03/03/2025', 4),
(16547, 475313, 'Didattica', '10/12/2024', 2),
(13698, 486087, 'Missione', '19/05/2025', 5),
(16924, 405727, 'Incontro Accademico', '01/04/2025', 4);

('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');




--ALTER TABLE Persona
	--ALTER COLUMN posizione TYPE Strutturato
	--USING
		--CASE 
			--WHEN posizione = 'Professore Ordinato' THEN 'Professore Ordinario'::Strutturato
			--ELSE posizione::text::Strutturato
		--END;
		
create domain StringaM as varchar(100);

create domain Voto as integer
	check (value BETWEEN 0 and 5);

create domain IntGEZ as integer 
	check (value >= 0);

create domain IntGE2 as integer
	check (value >= 2);

create domain URL as varchar
	check (value ~ '^https?:\\/\\/(?:www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b(?:[-a-zA-Z0-9()@:%_\\+.~#?&\\/=]*)$');

create domain RealGEZ as real 
	check (value >= 0);

create domain RealGZ as real 
	check (value > 0);

create type Condizione as enum
	('Ottimo', 'Buono', 'Discreto', 'Da sistemare');

create type Popolarita as enum
	('Bassa', 'Media', 'Alta');

/*Airplanes*/ 
insert into airplane
	(plane_type, capacity)
	values
	('Cessna', 4),
	('B 737', 200),
	('B 747', 225),
	('B 767', 155),
	('Hot air balloon', 5);

/*Destinations */
insert into city 
	(_name)
	values
	('Stockholm'),
	('New York'),
	('Singapore'),
	('Boston'),
	('Toronto'),
	('Houston'),
	('Zanzibar'),
	('Sydney');

/*Routes */

insert into route
	(base_price, _year, from_city_id, to_city_id)
	values
	(4000, 2014, 1, 2),
	(2000, 2015, 1, 2),
	(3500, 2014, 2, 1),
	(2600, 2015, 2, 1),
	(8900, 2014, 1, 3),
	(1750, 2015, 1, 3),
	(3250, 2014, 3, 1),
	(2300, 2015, 3, 1),
	(4400, 2014, 1, 4),
	(2300, 2015, 1, 4),
	(1750, 2014, 4, 1),
	(3300, 2015, 4, 1),
	(4040, 2014, 4, 5),
	(4540, 2015, 4, 5),
	(5540, 2014, 5, 4),
	(3410, 2015, 5, 4),
	(2340, 2014, 5, 6),
	(1540, 2015, 5, 6),
	(840, 2014, 6, 7),
	(2340, 2015, 6, 7),
	(7840, 2014, 8, 7),
	(1240, 2015, 8, 7),
	(1240, 2014, 1, 8),
	(6640, 2015, 1, 8);

INSERT INTO passenger_factor(_year, passenger_factor) VALUES
	(2010, 50),
	(2011, 60),
	(2012, 70),
	(2013, 80),
	(2014, 90);

/* Airplane */
insert into airplane
	(plane_type, capacity)
	values
	('Cessna', 4),
	('B 737', 200),
	('B 747', 225),
	('B 767', 155),
	('Hot air balloon', 5);

INSERT INTO _weekday(_name, day_factor, _year) VALUES
		('MONDAY', 1, 2010),
		('TUESDAY', 1, 2010),
		('WEDNESDAY', 2, 2010),
		('THURSDAY', 3, 2010),
		('FRIDAY', 5, 2010),
		('SATURDAY', 4, 2010),
		('SUNDAY', 5, 2010),
		('MONDAY', 2, 2011),
		('TUESDAY', 2, 2011),
		('WEDNESDAY', 3, 2011),
		('THURSDAY', 4, 2011),
		('FRIDAY', 6, 2011),
		('SATURDAY', 5, 2011),
		('SUNDAY', 6, 2011),
		('MONDAY', 3, 2012),
		('TUESDAY', 3, 2012),
		('WEDNESDAY', 4, 2012),
		('THURSDAY', 5, 2012),
		('FRIDAY', 7, 2012),
		('SATURDAY', 6, 2012),
		('SUNDAY', 7, 2012),
		('MONDAY', 4, 2013),
		('TUESDAY', 4, 2013),
		('WEDNESDAY', 5, 2013),
		('THURSDAY', 6, 2013),
		('FRIDAY', 8, 2013),
		('SATURDAY', 7, 2013),
		('SUNDAY', 8, 2013),
		('MONDAY', 5, 2014),
		('TUESDAY', 5, 2014),
		('WEDNESDAY', 6, 2014),
		('THURSDAY', 7, 2014),
		('FRIDAY', 9, 2014),
		('SATURDAY', 8, 2014),
		('SUNDAY', 9, 2014);

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

/*Sätter in rutter i Routes */
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

/* Sätter in data i weekly_flights*/
insert into weekly_flights(_time, route_id, _year, weekday_name, airplane_id) 
values 
	('12:00', 1, 2014, 'MONDAY', 3),
	('13:37', 1, 2014, 'MONDAY', 5),
	('07:00', 5, 2014, 'TUESDAY', 2),
	('19:00', 18, 2014, 'WEDNESDAY', 1),
	('15:00', 14, 2014, 'THURSDAY', 3),
	('17:00', 20, 2014, 'FRIDAY', 2),
	('11:00', 17, 2014, 'SATURDAY', 4),
	('09:00', 16, 2014, 'SUNDAY', 5);

/* Sätter in data i flights*/
insert into flights(booked_seats, flight_date, weekly_flights_id)
values	
	(0, '2014-03-30', 7),
	(0, '2014-03-29', 6),
	(0, '2014-03-28', 5),
	(0, '2014-03-27', 4),
	(0, '2014-03-26', 3),
	(0, '2014-03-25', 2),
	(0, '2014-03-24', 1),
	(2, '2014-04-06', 7), -- New values 2014-05-03
	(0, '2014-03-24', 2),
	(4, '2014-04-13', 7);

select 'Populated the database successfully' as 'message';
	
	

/*
Procedure for creating a reservation on a specific flight
		1. Check if its possible to book the flight
		2. Create a reservation
*/

drop procedure if exists `create_reservation`;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_reservation`(in flight_id int, in participants int, 
																	in email varchar(20), in phone_number int,
																	out booking_id int)
begin
-- Variables

-- 1. Checks [TODO check if there are enough unpaid seats]

-- 2. Create a reservation
	-- Increment the booked seats
	update flights 
		set booked_seats = booked_seats + participants
		where flights.id = flight_id;

	-- Calculate price
	call calculate_price(flight_id, @base_price);
	select @base_price * participants into @price;

	-- Create new booking tuple
	insert into bookings 
		(price, phone_number, email, flight_id)
		values
		(@price, participants, email, flight_id);
	
	select last_insert_id()
		into @booking_id;
	set booking_id := @booking_id;
end
$$ DELIMITER ;

/*
Procedure that adds passenger details to a specific reservation
*/
drop procedure if exists `add_passenger_details`;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_passenger_details`(in booking_id int, in SSN varchar(25), 
																	in first_name varchar(25), in surname varchar(25))
begin
-- Create passenger tuples [TODO needs to check if the SSN already exists or not]
	-- Check if the passenger already exists in our database and if not: create a new passenger tuple

	if (not exists(select * from passengers where passengers.ssn = SSN)) then 
		insert into passengers
			(ssn, first_name, surname)
			values
			(SSN, first_name, surname);
	end if;

-- Update the participates relation [TODO should include some error handling]
	insert into participates
		(booking_id, ssn) -- Not handing out a ticket_number since the booking might not be paid yet
		values
		(booking_id, SSN);
	
end
$$ DELIMITER ;

/*
Procedure for calculating the price of a seat on a specific flight
*/
drop procedure if exists calculate_price;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_price`(in flight_id int, out price int)
begin
	
	-- fetch the number of passengers on the flight [Completed]
	select booked_seats 
		from flights 
		where id = flight_id
		into @passenger_on_flight;

	-- fetch the passenger factor [Completed]	
	select passenger_factor
			from weekly_flights w
			inner join (select f.weekly_flights_id 
							from flights f
							where f.id = flight_id) f
			on w.id = f.weekly_flights_id
			left join passenger_factor
			on passenger_factor._year = w._year
				into @passenger_factor;
	
	-- fetch the price for this route [Completed]
	select base_price
		from weekly_flights w
		inner join (select f.weekly_flights_id 
						from flights f
						where f.id = flight_id) f
		on w.id = f.weekly_flights_id
		left join route
		on route.id = w.route_id
			into @route_price;

	-- fetch the airplane size [Completed]
	select capacity, weekday_name
			from weekly_flights w
			inner join (select f.weekly_flights_id 
							from flights f
							where f.id = flight_id) f
			on w.id = f.weekly_flights_id
			left join airplane
			on airplane.id = w.airplane_id
				into @airplane_size, @weekday;

	-- fetch the weekday factor [Completed]
	select day_factor
			from weekly_flights w
			inner join (select f.weekly_flights_id 
							from flights f
							where f.id = flight_id) f
			on w.id = f.weekly_flights_id
			left join (select * 
							from _weekday
							where _weekday._name = @weekday) wd
			on wd._year = w._year
				into @weekdayfactor;

	-- Calculate price
	select (@route_price * @weekdayfactor * (@passenger_on_flight + 1)/@airplane_size * @passenger_factor) 
		into price;

	-- Tests
	-- select @route_price, @weekdayfactor, @passenger_on_flight, @airplane_size, @passenger_factor;
	
end
$$ DELIMITER ;

/* 
	TESTS
*/
set @b_id = 0;
call create_reservation(3, 3, 'mail', 073, @booking_id);
select @booking_id;
call add_passenger_details(@booking_id, '2', 'Tobias', 'Genborg');
call add_passenger_details(@booking_id, '123412', 'ExampleName', 'Surname');
call add_passenger_details(@booking_id, '1111111', 'Test', 'test');

select * from bookings;
select * from passengers;
select * from participates;

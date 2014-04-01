/*
Procedure for creating a reservation on a specific flight
		1. Check if its possible to book the flight
		2. Create a reservation
*/

drop procedure if exists `create_reservation`;

/*Check if a specific  */ 
DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_reservation`(in flight_id int, in participants int, 
																	in email varchar(20), in phone_number int)
begin
-- Variables

-- 1. Checks

-- 2. Create a reservation
	-- Increment the booked seats
	update flights 
		set booked_seats = booked_seats + participants
		where flights.id = flight_id;

	-- Calculate price
	call calculate_price(flight_id, @base_price);

	select @base_price * participants into @price;
	select @price;

	-- Create new booking tuple
	insert into bookings 
		(price, phone_number, email, flight_id)
		values
		(@price, participants, email, flight_id);

	-- Create passengers


	-- Update the participates tuple
	
end
$$ DELIMITER ;


/*
Procedure for calculating the price of a seat on a specific flight
	--Not completed!!
*/
drop procedure if exists calculate_price;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_price`(in @flight_id int, out price int)
begin
	-- variables
	set @airplane_size = 60;
	set @routeprice = 2500;
	set @weekdayfactor = 4.7;
	
	-- fetch the number of passengers on the flight
	set @booked := 1; 
	select booked_seats 
		from flights 
		where id = flight_id
		into @passenger_on_flight;

	-- fetch the passenger factor
	set @flight_year := 2014; -- Needs to be fetched!
	select passenger_factor
		from passenger_factor
		where _year = @flight_year
		into @passenger_factor;
	
	-- fetch the price for this route
	select base_price
		from weekly_flights w
		inner join (select f.weekly_flights_id 
						from flights f
						where f.id = @flight_id) f
		on w.id = f.weekly_flights_id
		left join route
		on route.id = w.route_id
			into @route_price;

	-- fetch the 

	-- Calculate price
	select (@routeprice * @weekdayfactor * (@passenger_on_flight + 1)/@airplane_size * @passenger_factor) 
		into price;
	
end
$$ DELIMITER ;

/* 
	TESTS
*/

call create_reservation(2, 2, 'mail', 073);

select * from flights;


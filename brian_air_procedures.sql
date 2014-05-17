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
	-- [TODO] DISCUSS: Should this be done here at all? Should you be able to reserve even if a flight is full?

-- 2. Create a reservation

	-- Calculate price 
		-- [TODO] DISCUSS: Should this be placed here? Should price be determined on when you reserve or when you book a flight?
		-- The Lab PM isn't completely clear regarding this
		-- Adams åsikt: 
		-- Jag tycker att priset ska bestämmas vid bokning, 
		-- reservationen är för att man ska slippa komma ihåg alla ifyllda uppgifter tänker jag

	-- Create new booking tuple
	insert into bookings 
		(phone_number, email, flight_id, participants_num)
		values
		(phone_number, email, flight_id, participants);
	
	select last_insert_id()
		into @booking_id;
	set booking_id := @booking_id;
end
$$ DELIMITER ;

Select 'Succesfully created procedure create_reservation' as Message;

/*
Procedure that adds passenger details to a specific reservation
*/
drop procedure if exists `add_passenger_details`;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_passenger_details`(in booking_id int, in SSN varchar(25), 
																	in first_name varchar(25), in surname varchar(25))
begin
	-- Check if the booking is full or not
	select count(*)
		from participates p
		where p.booking_id = booking_id
		into @participants;

	select participants_num
		from bookings b
		where b.id = booking_id
		into @number_of_participants;

	if (@participants + 1 <= @number_of_participants) then -- End Check
		if (not exists(select * from passengers where passengers.ssn = SSN)) then 
			insert into passengers
				(ssn, first_name, surname)
				values
				(SSN, first_name, surname);
		end if;

		-- Update the participates relation 
		insert into participates
			(booking_id, ssn)
			values
			(booking_id, SSN);
	else
		select 'The booking is full' as 'Error message';
	end if;
	
end
$$ DELIMITER ;
Select 'Succesfully created procedure add_passenger_details' as Message;

/*
 Function for calculating the price of a seat on a specific flight
*/
drop function if exists calculate_price;
DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_price`( flight_id INT)
	RETURNS INT
BEGIN 
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

	-- Calculate and return the price
	 RETURN (@route_price * @weekdayfactor * (@passenger_on_flight + 1)/@airplane_size * @passenger_factor);
END;
$$ DELIMITER ; 
Select 'Succesfully created function calculate_price' as Message;


/* 
Procedure to add payment details to the database.
*/
drop procedure if exists add_payment_details;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_payment_details`(in booking_id int, in name_of_holder varchar(20), 
																	in _type varchar(20), in expiry_month varchar(20), 
																	in expiry_year varchar(20), in card_number varchar(20))																	
proc_label : begin
	-- Variables
	declare available_seats int default 0;
	declare e_mail varchar(20);
	declare phone_number varchar(20);
	declare number_of_participants int;
	declare amount int;

	/* Queries that checks if the reservation is ready to be payed STARTS*/
	-- Check if the booking already been payed (if its a booking or a reservation)
	select credit_card
		from bookings b
		where b.id = booking_id
		into @booking_control;	

	if (@booking_control is not null) then 
		select 'Booking is already payed for.' as 'Error message';
		leave proc_label;
	end if;

	-- Checks if the booking have a contact person
	select email, phone_number
		from bookings b
		where b.id = booking_id
		into e_mail, phone_number;

	if (e_mail = null or phone_number = null) then
		select 'No contact details added!' as 'Error message';
		leave proc_label;
	end if;

	-- Check if the number of passengers added to the booking matches the number that was specified 
	-- during the booking creation.
	select count(*)
		from participates p
		where p.booking_id = booking_id
		into @participants;

	select participants_num
		from bookings b
		where b.id = booking_id
		into number_of_participants;

	if (@participants != number_of_participants) then
		select 'Not the correct number of participants added to the booking.' as 'Error message';
		leave proc_label;
	end if;

	-- Makes sure there are enough seats on the plane before adding the payment info to the database
	select flight_id
		from (select * 
				from bookings 
				where id = booking_id) b
		inner join flights f
		on f.id = b.flight_id
		into @flight_id;

	if (SELECT get_available_seats(@flight_id)) < @participants then
		select 'Not enough seats left on the flight.' as 'Error message';
		leave proc_label;
	end if;

	/* Queries that checks if the reservation is ready to be payed ENDS*/

	-- [Completed (or is it?)] Do some controls of the credit card info (Check if exactly this card exists in the database)
	/* Check if the credit card already exists */
	select count(*)
		from credit_card
		where credit_card_number = card_number
		into @tuple;
	
	-- Fetch the price of the booking
	select price
		from bookings b
		where b.id = booking_id
		into amount;

	if @tuple = 0 then
		/* Create a new tuple in the credit_card table */
		insert into credit_card
		(credit_card_number, name_of_holder, _type, expiry_month, expiry_year, amount)
		values
		(card_number, name_of_holder, _type, expiry_month, expiry_year, amount);
	else -- The credit card exists in the database. Update the amount (Or even better create new transaction tuple!)
		update credit_card c
			set c.amount = c.amount + amount
			where c.credit_card_number = card_number;
	end if;
	
	/* Update the corresponding booking table*/
	update bookings b
		set credit_card = card_number, price = calculate_price(@flight_id)
		where b.id = booking_id;
end
$$ DELIMITER ;
Select 'Succesfully created procedure add_payment_details' as Message;

/* 
Generates a new ticket number that is unique for each flight 
*/
drop procedure if exists generate_ticket_number;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_ticket_number`(in booking_id int, in flight_id int, out ticket_number varchar(40))
begin
	-- Variables
	declare booked int;
	declare temp1 varchar(20);
	declare temp2 varchar(20);

	select booked_seats
		from flights
		where flights.id = flight_id
		into booked;
	
	set temp1 := concat(booking_id, 'Delimiter');
	set temp1 := concat(temp1, booked);
	
	set ticket_number = sha1(temp1);
	
end
$$ DELIMITER ;
Select 'Succesfully created procedure generate_ticket_number' as Message;

/* 
Assigns tickets to all passengers in a booking.
*/
drop procedure if exists assign_tickets_to_passengers;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_tickets_to_passengers`(in booking_id int, in flight_id int)
begin
	-- variables
	declare finished integer default 0;
	declare temp_ssn varchar(25) default "";
	declare temp_booking_id integer default 0;
	-- declare cursor
	declare cur1 cursor for select p.ssn
							from participates p
							where p.booking_id = booking_id;
	
	declare continue handler for not found set finished = 1;
	-- fetch results using the cursor
	open cur1;
	
	generate_tickets : loop
		fetch cur1 into temp_ssn;
		if finished = 1 then
			leave generate_tickets;
		end if;

		call generate_ticket_number(booking_id, flight_id, @ticket_num);
		-- Update participates
		update participates p
			set p.ticket_number =  @ticket_num
			where p.ssn = temp_ssn and p.booking_id = booking_id;
		-- Increment the booked seats for the specific flight
		update flights 
			set booked_seats = booked_seats + 1
			where flights.id = flight_id;
		
	end loop generate_tickets;
end
$$ DELIMITER ;
Select 'Succesfully created procedure assign_ticket_to_passengers' as Message;

/* 
Procedure to check how many available seats a given flight have
*/
DROP FUNCTION IF EXISTS get_available_seats;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_available_seats`(flight_id int)
RETURNS INT
begin
	-- Fetch the booked seats on this flight
	select booked_seats
	from flights
	where id = flight_id
	into @booked_seats;

	-- Fetch the size of the airplane
	select capacity
	from (select weekly_flights_id
		  from flights
		  where flights.id = flight_id) f
	inner join weekly_flights w on w.id = f.weekly_flights_id
	inner join airplane a on a.id = w.airplane_id
	into @capacity;
	
	-- Calculate the available seats
	RETURN (@capacity - @booked_seats);
end
$$ DELIMITER ;
Select 'Succesfully created function get_available_seats' as Message;


/* 
Procedure that returns available flights. A flight is available if:
											- It has more seats available than number_of_passengers [completed]
											- It flies on the specified date [completed]
											- It has the correct departure and destination [completed]
*/
drop procedure if exists get_flights;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_flights`(in departure varchar(25), in destination varchar(25), 
															in number_of_passengers int, in desired_flight_date date)
begin


	SELECT flights.id as 'Flight id', flight_date as 'Flight date', _time as 'Time of departure', ((SELECT calculate_price(flights.id)) * number_of_passengers) as 'Price'
	FROM flights
			INNER JOIN weekly_flights
				ON flights.weekly_flights_id = weekly_flights.id
			WHERE weekly_flights.route_id = get_route(departure, destination) AND flights.flight_date = desired_flight_date AND (number_of_passengers <= get_available_seats(flights.id)); 
													
end
$$ DELIMITER ;
Select 'Succesfully created procedure get_flights' as Message;


/*
Procedure that returns the route id for a given departure and destination [varchar's]	
*/
drop FUNCTION if exists get_route;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_route`(departure varchar(25), destination varchar(25))
RETURNS INT

begin 

RETURN (SELECT id
		FROM route 
		WHERE from_city_id = (SELECT id 
							  FROM city 
							  WHERE city._name = departure)
		AND to_city_id = (SELECT id 
						  FROM city
						  WHERE city._name = destination) AND _year = (select get_year()));
end
$$ DELIMITER ;
Select 'Succesfully created function get_route' as Message;



/*
Returns the current year
*/
drop FUNCTION if exists get_year;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_year`()
RETURNS INT
begin
RETURN 2014;
end
$$ DELIMITER ;
select 'Successfully created procedure get_year' as Message;



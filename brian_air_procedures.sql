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
	call calculate_price(flight_id, @base_price);
	select @base_price * participants into @price;

	-- Create new booking tuple
	insert into bookings 
		(price, phone_number, email, flight_id, participants_num)
		values
		(@price, phone_number, email, flight_id, participants);
	
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
			(booking_id, ssn) -- Not handing out a ticket_number since the booking might not be paid yet
			values
			(booking_id, SSN);
	else
		select 'The booking is full' as 'Error message';
	end if;
	
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
end
$$ DELIMITER ;

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

	call get_available_seats(@flight_id, available_seats);

	if available_seats < @participants then
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
		set credit_card = card_number
		where b.id = booking_id;
end
$$ DELIMITER ;

/* 
Generates a new ticket number that is unique for each flight 
				[TODO]: Do something smart!
*/
drop procedure if exists generate_ticket_number;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_ticket_number`(in flight_id int, out ticket_number varchar(20))
begin
	-- Increment the booked seats for the specific flight
	update flights 
		set booked_seats = booked_seats + 1
		where flights.id = flight_id;
	-- Generate a ticket id that is unique for each flight [i.e the booked seats variable][TODO: do something smarter]
	select booked_seats
		from flights
		where flights.id = flight_id
		into ticket_number;
end
$$ DELIMITER ;

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

		call generate_ticket_number(@flight_id, @ticket_num);
		update participates p
			set p.ticket_number =  @ticket_num
			where p.ssn = temp_ssn and p.booking_id = booking_id;
	end loop generate_tickets;

end
$$ DELIMITER ;

/* 
Procedure to check how many available seats a given flight have
*/
drop procedure if exists get_available_seats;

DELIMITER $$
USE `brian_air`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_available_seats`(in flight_id int, out available_seats int)
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
	left join weekly_flights w on w.id = f.weekly_flights_id
	left join airplane a on a.id = w.airplane_id
	into @capacity;
	
	-- Calculate the available seats
	set available_seats = @capacity - @booked_seats;
end
$$ DELIMITER ;


select 'Successfully created procedures' as 'message'


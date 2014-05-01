/*Collection of tests for the brian_air_procedures file */

set @b_id = 0;
set @flight_id := 1;
set @card_number := '123131313113';
set @amount := 12500;

-- Test if we can add same passengers to two bookings

call create_reservation(@flight_id, 3, 'mymail@domain.com', 073, @booking_id);
	call add_passenger_details(@booking_id, '441126XXXX', 'Richard', 'F');
	call add_passenger_details(@booking_id, '761201XXXX', 'Albert', 'E');
	call add_passenger_details(@booking_id, '500203XXXX', 'Leonard', 'E');


call create_reservation(@flight_id, 3, 'mail', 073, @booking_id);
	call add_passenger_details(@booking_id, '441126XXXX', 'Richard', 'F');
	call add_passenger_details(@booking_id, '761201XXXX', 'Albert', 'E');
	call add_passenger_details(@booking_id, '500203XXXX', 'Leonard', 'E');
-- select 'Managed to add several passengers with same info' as 'message';

-- Test if we can add payment details to a booking
call add_payment_details(@booking_id, "Albert E", "Visa", "3", "2018", @card_number, @amount);
call add_payment_details(1, "Albert E", "Visa", "3", "2018", @card_number, @amount); 

-- Test if the available seats on a given flight can be fetched and is non-negative [@available_seats should be 2]
-- call get_available_seats(@flight_id, @available_seats); select @available_seats;

/*select * from bookings;
select * from passengers;
select * from participates;
select * from credit_card;
*/

-- select 'Test file completed without errors' as 'message';


/* Temp tests*/
-- select * from credit_card;
-- select * from participates;
-- set @booking_id = 1;
/* select p.ssn, p.booking_id
		from participates p
		where p.booking_id = @booking_id; */
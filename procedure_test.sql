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
select 'Managed to add several passengers with same info' as 'message';

-- Test if we can add payment details to a booking
call add_payment_details(@flight_id, "Albert E", "Visa", "3", "2018", @card_number, @amount);
select 'Managed to add several passengers with same info' as 'message';

/*select * from bookings;
select * from passengers;
select * from participates;
select * from credit_card;*/
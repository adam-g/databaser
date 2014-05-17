/*Collection of tests for the brian_air_procedures file */

set @b_id = 0;
set @flight_id := 1;
set @card_number := '123131313113';

-- Test if we can add same passengers to two bookings

call create_reservation(@flight_id, 3, 'mymail@domain.com', 073, @booking_id);
	call add_passenger_details(@booking_id, '441126XXXX', 'Richard', 'F');
	call add_passenger_details(@booking_id, '761201XXXX', 'Albert', 'E');
	call add_passenger_details(@booking_id, '500203XXXX', 'Leonard', 'E');


call create_reservation(@flight_id, 2, 'mail', 073, @booking_id);
	call add_passenger_details(@booking_id, '441126XXXX', 'Richard', 'F');
	call add_passenger_details(@booking_id, '761201XXXX', 'Albert', 'E');
	call add_passenger_details(@booking_id, '500203XXXX', 'Leonard', 'E');

select * from bookings;
select * from passengers;

-- select 'Managed to add several passengers with same info' as 'message';

-- Test if we can add payment details to a booking
call add_payment_details(2, "Albert E", "Visa", "3", "2018", @card_number);
call add_payment_details(1, "Albert E", "Visa", "3", "2018", @card_number); 

-- Test if the available seats on a given flight can be fetched and is non-negative [@available_seats should be 2]
-- call get_available_seats(@flight_id, @available_seats); select @available_seats;

/*select * from bookings;
select * from passengers;
select * from participates;
select * from credit_card;
*/

-- select 'Test file completed without errors' as 'message';

call create_reservation(4, 2, 'mail', 073, @booking_id);
	call add_passenger_details(@booking_id, '441126XXXX', 'Richard', 'F');
	call add_passenger_details(@booking_id, '761201XXXX', 'Albert', 'E');
	call add_passenger_details(@booking_id, '500203XXXX', 'Leonard', 'E');

call add_payment_details(@booking_id, "Albert E", "Visa", "3", "2018", @card_number); 

/* Temp tests*/
-- select * from credit_card;
-- select * from participates;
-- set @booking_id = 1;
/* select p.ssn, p.booking_id
		from participates p
		where p.booking_id = @booking_id; */

call create_reservation(4, 100, 'Adam', 073, @booking_id);
call add_passenger_details(@booking_id, '1', 'Leonard', 'E');
call add_passenger_details(@booking_id, '2', 'Leonard', 'E');
call add_passenger_details(@booking_id, '3', 'Leonard', 'E');
call add_passenger_details(@booking_id, '4', 'Leonard', 'E');
call add_passenger_details(@booking_id, '5', 'Leonard', 'E');
call add_passenger_details(@booking_id, '6', 'Leonard', 'E');
call add_passenger_details(@booking_id, '7', 'Leonard', 'E');
call add_passenger_details(@booking_id, '8', 'Leonard', 'E');
call add_passenger_details(@booking_id, '9', 'Leonard', 'E');
call add_passenger_details(@booking_id, '10', 'Leonard', 'E');
call add_passenger_details(@booking_id, '11', 'Leonard', 'E');
call add_passenger_details(@booking_id, '12', 'Leonard', 'E');
call add_passenger_details(@booking_id, '13', 'Leonard', 'E');
call add_passenger_details(@booking_id, '14', 'Leonard', 'E');
call add_passenger_details(@booking_id, '15', 'Leonard', 'E');
call add_passenger_details(@booking_id, '16', 'Leonard', 'E');
call add_passenger_details(@booking_id, '17', 'Leonard', 'E');
call add_passenger_details(@booking_id, '18', 'Leonard', 'E');
call add_passenger_details(@booking_id, '19', 'Leonard', 'E');
call add_passenger_details(@booking_id, '20', 'Leonard', 'E');
call add_passenger_details(@booking_id, '30', 'Leonard', 'E');
call add_passenger_details(@booking_id, '31', 'Leonard', 'E');
call add_passenger_details(@booking_id, '32', 'Leonard', 'E');
call add_passenger_details(@booking_id, '33', 'Leonard', 'E');
call add_passenger_details(@booking_id, '34', 'Leonard', 'E');
call add_passenger_details(@booking_id, '35', 'Leonard', 'E');
call add_passenger_details(@booking_id, '36', 'Leonard', 'E');
call add_passenger_details(@booking_id, '37', 'Leonard', 'E');
call add_passenger_details(@booking_id, '38', 'Leonard', 'E');
call add_passenger_details(@booking_id, '39', 'Leonard', 'E');
call add_passenger_details(@booking_id, '40', 'Leonard', 'E');
call add_passenger_details(@booking_id, '41', 'Leonard', 'E');
call add_passenger_details(@booking_id, '51', 'Leonard', 'E');
call add_passenger_details(@booking_id, '52', 'Leonard', 'E');
call add_passenger_details(@booking_id, '53', 'Leonard', 'E');
call add_passenger_details(@booking_id, '54', 'Leonard', 'E');
call add_passenger_details(@booking_id, '155', 'Leonard', 'E');
call add_passenger_details(@booking_id, '156', 'Leonard', 'E');
call add_passenger_details(@booking_id, '157', 'Leonard', 'E');
call add_passenger_details(@booking_id, '158', 'Leonard', 'E');
call add_passenger_details(@booking_id, '159', 'Leonard', 'E');
call add_passenger_details(@booking_id, '160', 'Leonard', 'E');
call add_passenger_details(@booking_id, '161', 'Leonard', 'E');
call add_passenger_details(@booking_id, '162', 'Leonard', 'E');
call add_passenger_details(@booking_id, '163', 'Leonard', 'E');
call add_passenger_details(@booking_id, '164', 'Leonard', 'E');
call add_passenger_details(@booking_id, '165', 'Leonard', 'E');
call add_passenger_details(@booking_id, '166', 'Leonard', 'E');
call add_passenger_details(@booking_id, '167', 'Leonard', 'E');
call add_passenger_details(@booking_id, '168', 'Leonard', 'E');
call add_passenger_details(@booking_id, '169', 'Leonard', 'E');
call add_passenger_details(@booking_id, '170', 'Leonard', 'E');
call add_passenger_details(@booking_id, '171', 'Leonard', 'E');
call add_passenger_details(@booking_id, '172', 'Leonard', 'E');
call add_passenger_details(@booking_id, '173', 'Leonard', 'E');
call add_passenger_details(@booking_id, '174', 'Leonard', 'E');
call add_passenger_details(@booking_id, '175', 'Leonard', 'E');
call add_passenger_details(@booking_id, '176', 'Leonard', 'E');
call add_passenger_details(@booking_id, '177', 'Leonard', 'E');
call add_passenger_details(@booking_id, '178', 'Leonard', 'E');
call add_passenger_details(@booking_id, '179', 'Leonard', 'E');
call add_passenger_details(@booking_id, '180', 'Leonard', 'E');
call add_passenger_details(@booking_id, '181', 'Leonard', 'E');
call add_passenger_details(@booking_id, '182', 'Leonard', 'E');
call add_passenger_details(@booking_id, '183', 'Leonard', 'E');
call add_passenger_details(@booking_id, '184', 'Leonard', 'E');
call add_passenger_details(@booking_id, '185', 'Leonard', 'E');
call add_passenger_details(@booking_id, '186', 'Leonard', 'E');
call add_passenger_details(@booking_id, '187', 'Leonard', 'E');
call add_passenger_details(@booking_id, '188', 'Leonard', 'E');
call add_passenger_details(@booking_id, '189', 'Leonard', 'E');
call add_passenger_details(@booking_id, '190', 'Leonard', 'E');
call add_passenger_details(@booking_id, '191', 'Leonard', 'E');
call add_passenger_details(@booking_id, '192', 'Leonard', 'E');
call add_passenger_details(@booking_id, '193', 'Leonard', 'E');
call add_passenger_details(@booking_id, '194', 'Leonard', 'E');
call add_passenger_details(@booking_id, '195', 'Leonard', 'E');
call add_passenger_details(@booking_id, '196', 'Leonard', 'E');
call add_passenger_details(@booking_id, '197', 'Leonard', 'E');
call add_passenger_details(@booking_id, '198', 'Leonard', 'E');
call add_passenger_details(@booking_id, '199', 'Leonard', 'E');
call add_passenger_details(@booking_id, '1100', 'Leonard', 'E');
call add_passenger_details(@booking_id, '42', 'Leonard', 'E');
call add_passenger_details(@booking_id, '43', 'Leonard', 'E');
call add_passenger_details(@booking_id, '44', 'Leonard', 'E');
call add_passenger_details(@booking_id, '45', 'Leonard', 'E');
call add_passenger_details(@booking_id, '46', 'Leonard', 'E');
call add_passenger_details(@booking_id, '47', 'Leonard', 'E');
call add_passenger_details(@booking_id, '48', 'Leonard', 'E');
call add_passenger_details(@booking_id, '49', 'Leonard', 'E');
call add_passenger_details(@booking_id, '50', 'Leonard', 'E');
call add_passenger_details(@booking_id, '55', 'Leonard', 'E');
call add_passenger_details(@booking_id, '56', 'Leonard', 'E');
call add_passenger_details(@booking_id, '57', 'Leonard', 'E');
call add_passenger_details(@booking_id, '58', 'Leonard', 'E');
call add_passenger_details(@booking_id, '59', 'Leonard', 'E');
call add_passenger_details(@booking_id, '60', 'Leonard', 'E');
call add_passenger_details(@booking_id, '61', 'Leonard', 'E');
call add_passenger_details(@booking_id, '62', 'Leonard', 'E');
call add_passenger_details(@booking_id, '63', 'Leonard', 'E');
call add_payment_details(@booking_id, 'Adde G', 'Visa', 1, '2014', '42');	

select * from bookings;
select * from passengers;
select * from participates;
select * from credit_card;

Select get_available_seats(1);

call get_flights('Stockholm', 'New York', 50, '2014-03-24');

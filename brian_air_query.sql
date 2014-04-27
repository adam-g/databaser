/*
Query to check if a booking includes a contact 
Used in the add_payment_details procedure
*/
-- set @booking_id = 1;
select email, phone_number
	from bookings b
	where b.id = @booking_id;

/*Query to check if the booking has the correct number of passengers */


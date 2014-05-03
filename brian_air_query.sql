/*
Query to check if a booking includes a contact 
Used in the add_payment_details procedure
*/
-- set @booking_id = 1;
select email, phone_number
	from bookings b
	where b.id = @booking_id;

/*Query to check if the booking has the correct number of passengers */


/*Query to generate view for exercise 8 */
declare destination varchar(25);

set departure := 'Stockholm';
set destination := 'Boston';

select *
	from route r, city c1
	join c1 on r.to_city_id = c1.id
	join c2 on r.to_city_id = c1.id
	where c1._name = departure and c2._name = destination;

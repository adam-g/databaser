/* Testar att göra lite queries för att se att inte allt är trasigt*/

select route.id, route.base_price
from route, weekly_flights
where route.id = weekly_flights.route_id;
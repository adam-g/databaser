/* Drop existing tables */

DROP TABLE IF EXISTS participates CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;

DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS weekly_flights CASCADE;
DROP TABLE IF EXISTS passenger_factor CASCADE;
DROP TABLE IF EXISTS _weekday CASCADE;
DROP TABLE IF EXISTS airplane CASCADE;
DROP TABLE IF EXISTS route CASCADE;
DROP TABLE IF EXISTS city CASCADE;

/*Variables */
set @text_length = 20;

/* Create the tables */

SELECT 'Creating tables' AS 'Message';

create table airplane(
		id INT not null auto_increment,
		plane_type varchar(25),
		capacity int,
		constraint pk_airplane primary key(id));

create table bookings(
		id INT not null auto_increment,
		credit_card varchar(20),
		price int,
		phone_number int,
		email varchar(25),
		flight_id int,
		constraint pk_bookings primary key(id));

create table city(
		id INT not null auto_increment,
		_name varchar(25),
		constraint pk_city primary key(id));

create table credit_card(
		credit_card_number varchar(20) not null,
		name_of_holder varchar(20),
		_type varchar(20),
		expiry_month int,
		expiry_year int,
		amount int,
		constraint pk_credit_card primary key(credit_card_number));

create table flights(
		id INT not null auto_increment,
		booked_seats int, 
		flight_date date, 
		weekly_flights_id int, 
		constraint pk_flights primary key(id));

create table participates(
		booking_id int,
		ssn varchar(25),
		ticket_number int,
		constraint pk_participates primary key(booking_id, ssn));

create table passenger_factor(
		_year int,
		passenger_factor int,
		constraint pk_passenger_factor primary key(_year));

create table passengers(
		ssn varchar(25),
		first_name varchar(25),
		surname varchar(25),
		constraint pk_passenger primary key(ssn));

create table route(
		id INT not null auto_increment,
		base_price int,
		_year int,
		from_city_id int,
		to_city_id int,
		constraint pk_route primary key(id));

create table _weekday(
		_name varchar(25),
		day_factor int,
		_year int,
		constraint pk_weekday primary key(_name, _year));

create table weekly_flights(
		id int not null auto_increment,
		_time time,
		route_id int,
		_year int,
		weekday_name varchar(25),
		airplane_id int,
		constraint pk_weekly_flights primary key(id));

/* Setting up foreign keys */
select 'Setting up foreign keys' as 'message';

alter table flights add constraint fk_weekly_flights foreign key (weekly_flights_id) references weekly_flights(id);

alter table route add constraint fk_from_city foreign key (from_city_id) references city(id);
alter table route add constraint fk_to_city foreign key (to_city_id) references city(id);

alter table bookings add constraint fk_flight_id foreign key (flight_id) references flights(id);
alter table bookings add constraint fk_credit_card foreign key (credit_card) references credit_card(credit_card_number);

alter table weekly_flights add constraint fk_route foreign key (route_id) references route(id);
alter table weekly_flights add constraint fk_weekday foreign key (weekday_name, _year) references _weekday(_name, _year);
alter table weekly_flights add constraint fk_airplane_id foreign key (airplane_id) references airplane(id);
alter table weekly_flights add constraint fk_year foreign key (_year) references passenger_factor(_year);

alter table participates add constraint fk_booking_id foreign key (booking_id) references bookings(id);

/* Creating triggers */
select 'Creating triggers' as 'message';
-- After insertion in the bookings table: Assign tickets
drop trigger if exists `bookings_update`;

DELIMITER $$ 
create trigger `bookings_update` 
after update on `bookings`
for each row
begin
    select new.id, new.flight_id
		into @booking_id, @flight_id;

	call assign_tickets_to_passengers(@booking_id, @flight_id);
end
$$ DELIMITER ;

/* Done! */
select 'Successful table setup' as 'message';
 






















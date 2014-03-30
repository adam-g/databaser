/* Drop existing tables */
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS route CASCADE;
DROP TABLE IF EXISTS city CASCADE;
DROP TABLE IF EXISTS airplane CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;
DROP TABLE IF EXISTS weekday CASCADE;
DROP TABLE IF EXISTS passenger_factor CASCADE;
DROP TABLE IF EXISTS weekly_flights CASCADE;
DROP TABLE IF EXISTS particaptes CASCADE;

/*Variables */
set @text_lenght = '20';

/* Create the tables */

SELECT 'Creating tables' AS 'Message';

create table flights(
		id int, 
		booked_seats int, 
		flight_date date, 
		weekly_flights_id int, 
		constraint pk_flights primary key(id));

create table route(
		id int,
		base_price int,
		year int,
		from_city_id int,
		to_city_id int,
		constraint pk_route primary key(id));

create table city(
		id int,
		name varchar(@text_lenght));

create table airplane(
		id int,
		plane_type varchar(@text_lenght),
		capacity int,
		constraint pk_airplane primary key(id));

create table bookings(
		id int,
		credit_card int,
		price int,
		phone_number int,
		email varchar(@text_lenght),
		flight_id int,
		constraint pk_bookings primary key(id));

create table passengers(
		ssn int,
		name varchar(@text_lenght),
		constraint pk_passenger primary key(id));

create table weekday(
		name varchar(@text_lenght),
		dayfactor int,
		_year int,
		constraint pk_weekday primary key(name, year));

create table weekly_flights(
		id int,
		_time time,
		route_id int,
		_year int,
		weekday_name varchar(@text_lenght),
		airplane_id int,
		constraint pk_weekly_flights primary key(id));

create table participates(
		booking_id int,
		ssn int,
		ticket_number int,
		constraint pk_participates primary key(booking_id));



























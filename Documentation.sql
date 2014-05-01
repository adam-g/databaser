/*
Documentation file
	Contents:
		1.1 Format of the statuses
		1.2 Status of the exercises 
		2.1 TODO.
 */

/*	1
	----------------------------------------------------------------------------------- 
		1.1 
		Format:
			-- The Excersise status is written on this format:

		Excercise #:
			-- Description: <Description of the excersise>
			-- Comments: <Comments (e.g. what is left to do, problems )>
			-- Status: 														[Completion status]
	

	----------------------------------------------------------------------------------- 

		1.2

		Excercise 1:
			-- Description: EER modeling
			-- Status: 	[a-j]												[DONE]

		Excercise 2:
			-- Description: Translate to tables
			-- Comments: Do we need to normalise?
			-- Status: 														[?]

		Excercise 3:
			-- Description: Set up the database, populate database
			-- Status: 	[a-b]												[DONE]

		Excercise 4:
			-- Description: Write procedures
			-- Comments: Mostly done. Might need to do some error control.
							See completion status.
			-- Status: 	[a] 												[DONE]
						[b]													[DONE]
						[c]													[DONE. Questions: NOT DONE]
						[d]													[DONE. 'Smart' formula: NOT DONE]
						[e]													[NOT DONE]
						[Check if the above is enough; are we missing 
							any necessary queries to complete a booking]	[NOT DONE]
						
		Excercise 5:
			-- Description: Create queries that confirm that a reservation is ready to be paid.
			-- Status: 	[Do a contact exists?]								[DONE]
						[Correct # of passengers?]							[DONE]

		Excercise 6:
			-- Description: Query for show the available seats
			-- Status: 	[Create query]										[DONE]					
						[Implemention]										[DONE]

		Excercise 7:
			-- Description: Calculate price query
			-- Status: 	[Create query]										[DONE]
						[Implemention]										[DONE]

		Excercise 8:
			-- Description: Create search query
			-- Status: 	[Create query]										[NOT DONE]

		--- PART 2: multiple users

		Excercise 9:
			-- Description: Two simultaneous MySQL sessions
			-- Status: 														[NOT DONE]

		Excercise 10:
			-- Description: Transaction scheduling
			-- Status: 														[NOT DONE]

	----------------------------------------------------------------------------------- 

	2.	TODO

		2.1 Necessary TODOs
			[TODO] Remove amount as an in parameter for add_payment_details. Instead fetch the amout from the booking tuple.

		2.1 Desirable TODOs
			[TODO] Cut down on the use of global variables. Change global variables to local by declaring them inside the procedures.
			[Completed] Make sure that the sure can't add more people to a booking than was specified originally 
					(i.e check the booking tuple's participants and compare with the count() from participates; can another passenger be
						added or is the booking full?)


*/

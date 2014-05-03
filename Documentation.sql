/*
Documentation file
	Contents:
		1.1 Format of the statuses
		1.2 Status of the exercises 
		2.1 About the TODO section
		2.2 TODO section
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
		The status of the exercises from a broad perspective. For a more detailed view check the procedures file and
		the TODO section below.

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
			-- Status: 	[a]													[DONE]
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

	2.2. TODO
		2.1
			Try to keep the TODOs sorted; keep the most important TODOs at the top. Keep completed TODOs in the list but place
			them at end of the list. Place completed items ahead of previously completed items (thus making sure that the first
			completed item was the last completed one)

		2.2.1 Necessary TODOs
			[TODO] Discuss how the credit card was implemented. Right now the amount drawn from a credit card is aggregated 
					which means that it will be impossible to do refunds. A transaction table would be necessary, but is this in the scope
					of this project?
			[Completed] Re-write the generate_ticket_number method. Create a proper ticket generation.
			[Completed] Remove amount as an in parameter for add_payment_details. Instead fetch the amout from the booking tuple.
			[Completed] Include some error handling: One passenger shouldn't be able to participate on a flight x2 [Comment: Allowed this]
			[Completed] If the same credit card is used: aggregate the billed amount (Results in new problems, see TODO in 2.1)
			[Completed] Make sure that a booking can't be payed several times (leads to passengers getting new ticket_numbers)

		2.2.2 Desirable TODOs
			[TODO] Aggregate similiar queries to minimize accesses. (Several queries accessing the same table is unnesessary).
			[TODO] Write a proper test file (that checks results from queries)
			[TODO] Cut down on the use of global variables. Change global variables to local by declaring them inside the procedures.
			[Completed] Make sure that the sure can't add more people to a booking than was specified originally 
					(i.e check the booking tuple's participants and compare with the count() from participates; can another passenger be
						added or is the booking full?)
			

*/

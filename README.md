# messy-imdb-sql-clean
Cleaning a messy imdb dataset from Kaggle with only 101 rows.

I only removed a blank row from the original CSV, so that the data would be ingested into the PostgreSQL database. I imported everything as a text type to start.

Then, I did an initial clean up using SQL and output that intitial clean table as clean1.csv. I commented out any intermediate queries I used to explore the data during my cleaning.

For the first round of cleaning I:
* I left the first 2 rows alone for now. imdb_title is fine as is, but there are some special character errors and casing inconsistencies in original_title.
* release_year had multiple formats of full dates. I pulled out the years when I was certain what the year was and left the row NULL where it's ambiguous. There are only 2 NULL values that can be reconcilled with the IMDB site later.
* There are between 1 and 3 genres per film, so I split these into 3 separate columns. Any empty spaces have been set as NULL. Originally, I had them set to N/A, but switched to NULL for consistency with the NULLS in the duration column.
* For the duration, I standardized all non-number values to NULL, and removed any characters in any numeric rows.
* For the content_rating column I standardized "Unrated", "Not Rated", AND "#N/A" to "Unrated", and I left "Approved" alone since it is an older rating system option.
* I noticed that there were at most 2 names in the director column, so I split that into 2 columns and set the blanks to NULL.
* I removed the character o from a number in the income row and removed all of the non-numeric characters to prep for conversion to a numeric type. Line 8 still seems off at only 576.
* I intially changed the '.' in votes to ',' for normal numeric formating, but I removed them instead so it can be prepped for numeric conversion.
* I cleaned up the score column to prep for conversion to a decimal type with 1 place of precision.

Things I can still do
* Fix the original_title column
* See if I can add in those 2 missing release years (rows 6 and 45)
* See if I can get any of the missing durations and include what the time unit is
* Check if there's an rating in the current rating system for the row set to "Approved" (row 13)
* See if director2 needs to be renamed to another title
* Convert the the last 3 columns to numeric types
* Check the income number for row 8 

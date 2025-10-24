# messy-imdb-sql-clean
Cleaning a messy imdb dataset from Kaggle with only 101 rows: https://www.kaggle.com/datasets/davidfuenteherraiz/messy-imdb-dataset

---

### The imdb_mess Table (ingested)
| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| imdb_title [PK]  | text          | Unique ID for each movie                                                                      |
| original_title   | text          | The full title of the movie                                                                   |
| release_year     | text          | The year in which the movie came out                                                          |
| genre            | text          | The genres of the movie (can have 1, 2, or 3)                                                 |
| duration         | text          | The length of the movie in minutes                                                            |
| country          | text          | The movie's country of origin                                                                 |
| content_rating   | text          | The movie's MPA (Motion Picture Rating)                                                       |
| director         | text          | The name of the movie's director                                                              |
| column1          | text          | A completely empty column                                                                     |
| income           | text          | Total Box Office revenue (money from ticket sales during theatrical release)                  |
| votes            | text          | Not entirely sure, but possibly related to user stars/reviews                                 |
| score            | text          | The movies average total star rating (out of 10 stars)                                        |

---

I only removed a blank row from the original CSV, so that the data would be ingested into the PostgreSQL database. I imported everything as a text type to start.

Then, I did an initial clean up using SQL and output that intitial clean table as clean1.csv. I commented out any intermediate queries I used to explore the data during my cleaning.

For the first round of cleaning:
* I left the first 2 rows alone for now. imdb_title is fine as is, but there are some special character errors and casing inconsistencies in original_title.
* release_year had multiple formats of full dates. I pulled out the years when I was certain what the year was and left the row NULL where it's ambiguous. There are only 2 NULL values that can be reconcilled with the IMDB site later.
* There are between 1 and 3 genres per film, so I split these into 3 separate columns. Any empty spaces have been set as NULL. Originally, I had them set to N/A, but switched to NULL for consistency with the NULLS in the duration column.
* For the duration, I standardized all non-number values to NULL and removed any characters in any numeric rows.
* I standardized the country column to 2 character country codes or NULL.
* For the content_rating column I standardized "Unrated", "Not Rated", AND "#N/A" to "Unrated", and I left "Approved" alone since it is an older rating system option.
* I noticed that there were at most 2 names in the director column, so I split that into 2 columns and set the blanks to NULL.
* I removed the character 'o' instead of a 0 in one of the numbers in the income row and removed all of the non-numeric characters to prep for conversion to a numeric type. Line 8 still seems off at only 576.
* I intially changed the '.' in votes to ',' for normal numeric formating, but I removed them instead so it can be prepped for numeric conversion.
* I cleaned up the score column to prep for conversion to a decimal type with 1 place of precision.

---

### The clean1 Table (initial cleaning)
| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| imdb_title [PK]  | text          | Unique ID for each movie                                                                      |
| original_title   | text          | The full title of the movie                                                                   |
| release_year     | text          | The year in which the movie came out                                                          |
| genre1           | text          | The first listed genre of the movie                                                           |
| genre2           | text          | The second listed genre of the movie (if it exists)                                           |
| genre3           | text          | The third listed genre of the movie (if it exists)                                            |
| duration         | text          | The length of the movie in minutes                                                            |
| country          | text          | The movie's country of origin                                                                 |
| content_rating   | text          | The movie's MPA (Motion Picture Rating)                                                       |
| director1        | text          | The first name that was in the original director column                                       |
| director2        | text          | The second name that was in the original director column                                      |
| income           | text          | Total Box Office revenue (money from ticket sales during theatrical release)                  |
| votes            | text          | Not entirely sure, but possibly related to user stars/reviews                                 |
| score            | text          | The movies average total star rating (out of 10 stars)                                        |

---

Things I can still do
* Fix the original_title column
* See if I can add in those 2 missing release years (rows 6 and 45)
* See if I can get any of the missing durations and include what the time unit is for certain (still think it's minutes)
* Check if there's any rating in the current rating system for the row set to "Approved" (row 13)
* See if director2 needs to be renamed to another title (like 'Writer')
* Convert the the last 3 columns to numeric types
* Check the income number for row 8 (the 576 number is way too low to be correct)
* I can also see if there's a way for me to refactor any of the case statements/regular expressions

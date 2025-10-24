WITH cleaning AS
	(SELECT
		-- No problem here
		imdb_title,
		-- problem with special characters and casing
		original_title,
		-- year needs to be separated but there's diff formats
		CASE -- 2 values as null, hard to tell year from format, can reconcile with IMDB search later
			WHEN release_year NOT LIKE '%-%' OR
				 release_year LIKE ' __ -__-____' THEN RIGHT(TRIM(release_year), 4) 
			WHEN release_year LIKE '____-__-__' THEN LEFT(TRIM(release_year), 4) END AS release_year,
		-- Split up the genre column
		SPLIT_PART(genre, ',' , 1) AS genre1,
		SPLIT_PART(genre, ',' , 2) AS genre2,
		SPLIT_PART(genre, ',' , 3) AS genre3,
		-- some weird values in here
		CASE
			WHEN duration IN('-', 'Not Applicable', 'Inf', 'NULL', ' ', 'Nan') THEN NULL
			WHEN duration LIKE '%c' THEN LEFT(duration, 3)
			ELSE duration END AS duration,
		-- standardize the country column to country code or 'N/A'
		CASE
			WHEN country IN ('US.', 'US', 'USA') THEN 'US'
			WHEN country IN ('Italy', 'Italy1') THEN 'IT'
			WHEN country IN ('New Zeland', 'New Zealand', 'New Zesland') THEN 'NZ'
			WHEN country IN ('West Germany', 'Germany') THEN 'DE'
			WHEN country = 'India' THEN 'IN'
			WHEN country = 'Iran' THEN 'IR'
			WHEN country = 'France' THEN 'FR'
			WHEN country = 'Brazil' THEN 'BR'
			WHEN country = 'Japan' THEN 'JP'
			WHEN country = 'Denmark' THEN 'DK'
			WHEN country = 'South Korea' THEN 'KR'
			ELSE NULL END AS country,
		-- standardize movies without a rating
		CASE
			WHEN content_rating IN ('Not Rated', 'Unrated', '#N/A') THEN 'Unrated'
			ELSE content_rating END AS content_rating,
		-- some have two director names
		SPLIT_PART(director, ',' , 1) AS director1,
		SPLIT_PART(director, ',' , 2) AS director2,
		-- lines 4 and 8 look off, prep for cast to numeric
		REPLACE(REPLACE(REPLACE(income, 'o', '0'), '$', ''), ',', '') AS income,
		-- Prep for cast to numberic
		REPLACE(votes, '.', '') AS votes,
		-- Get score into format that can be converted to decimal
		CASE 
			WHEN score LIKE '_,_' THEN REPLACE(score, ',', '.')
			WHEN score LIKE '_:0_' THEN REPLACE(score, ':0', '.')
			WHEN score LIKE '_.._' THEN REPLACE(score, '..', '.')
			WHEN score LIKE '_,._' THEN REPLACE(score, ',.', '.')
			WHEN score LIKE '_,_f' THEN REPLACE(LEFT(score, 3), ',', '.')
			WHEN score LIKE '_._.' THEN LEFT(score, 3)
			WHEN score LIKE '0%' THEN RIGHT(score, LENGTH(score) - 1)
			WHEN score LIKE '%e%' THEN REPLACE(LEFT(score, 3), ',', '.') 
			ELSE score END AS score
	FROM imdb_mess)

SELECT
	imdb_title,
	original_title,
	release_year,
	genre1,
	CASE
		WHEN genre2 = '' THEN NULL ELSE genre2 END AS genre2,
	CASE
		WHEN genre3 = '' THEN NULL ELSE genre3 END AS genre3,
	duration,
	country,
	content_rating,
	director1,
	CASE
		WHEN director2 = '' THEN NULL ELSE director2 END AS director2,
	income,
	votes,
	score
FROM cleaning;

/*Select DISTINCT -- Get all distinct country column values before clean
	country
FROM imdb_mess;*/

/*Select DISTINCT -- Get all distinct content_rating column values before clean
	content_rating
FROM imdb_mess;*/
-- Note: Approved is from an old movie rating system, Not Rated and Unrated are the same

/*Select DISTINCT -- Get all distinct score column values before clean
score,
	CASE
		WHEN score LIKE '_,_' THEN REPLACE(score, ',', '.')
		WHEN score LIKE '_:0_' THEN REPLACE(score, ':0', '.')
		WHEN score LIKE '_.._' THEN REPLACE(score, '..', '.')
		WHEN score LIKE '_,._' THEN REPLACE(score, ',.', '.')
		WHEN score LIKE '_,_f' THEN REPLACE(LEFT(score, 3), ',', '.')
		WHEN score LIKE '_._.' THEN LEFT(score, 3)
		WHEN score LIKE '0%' THEN RIGHT(score, LENGTH(score) - 1)
		WHEN score LIKE '%e%' THEN REPLACE(LEFT(score, 3), ',', '.') 
		ELSE score END AS cleaned_score
FROM imdb_mess;*/

/*Select DISTINCT -- Get all distinct release_year column values before clean
	release_year,
	CASE
		WHEN release_year NOT LIKE '%-%' OR
			 release_year LIKE ' __ -__-____' THEN RIGHT(TRIM(release_year), 4) 
		WHEN release_year LIKE '____-__-__' THEN LEFT(TRIM(release_year), 4) END AS cleaned_year
FROM imdb_mess;*/

/*Select DISTINCT -- Get all distinct duration column values before clean
	duration,
	CASE
		WHEN duration IN('-', 'Not Applicable', 'Inf', 'NULL', ' ', 'Nan') THEN NULL
		WHEN duration LIKE '%c' THEN LEFT(duration, 3)
		ELSE duration END AS duration_clean
FROM imdb_mess;*/
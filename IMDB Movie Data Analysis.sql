USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT count(*) FROM movie; 
SELECT count(*) FROM genre;
SELECT count(*) FROM director_mapping;
SELECT count(*) FROM role_mapping;
SELECT count(*) FROM names;
SELECT count(*) FROM ratings; 

/* Observations
Total 7997 rows present in movie table
Total 14,662 rows present in genre table
Total 3867 rows present in director_mapping table
Total 15,615 rows present in role_mapping table
Total 25,735 rows present in names table
Total 7997 rows present in ratings table
*/


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	sum(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
	sum(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS TITLE_NULL,
	sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS YEAR_NULL,
	sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS DATE_PUBLISHED_NULL,
	sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS DURATION_NULL,
	sum(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS COUNTRY_NULL,
	sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS WORLWIDE_GROSS_INCOME_NULL,
	sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS LANGUAGES_NULL,
	sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS PRODUCTION_COMPANY_NULL
FROM movie;

/* Observations:
Columns having NULL Values: "country", "worlwide_gross_income", "languages", "production_company"
Columns not having NULL Values: "id", "title", "year", "date_published", "duration"
Total 20 null values present in "country" column
Total 3724 null values present in "worlwide_gross_income" column
Total 194 null values present in "languages" column
Total 528 null values present in "production_company" column
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+




Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Code for first part of question

SELECT year,
	count(id) AS number_of_movies 
FROM movie 
GROUP BY year 
ORDER BY year;

/* Observations:
Max no. of movies produced in year 2017
Min no. of movies produced in year 2019
*/

-- Code for second part of question

SELECT month(date_published) AS month_num ,
	count(id) AS number_of_movies 
FROM movie 
GROUP BY month_num 
ORDER BY month_num;

/* Observations:
Max no. of movies produced in the month of March
Min no. of movies produced in the month of December
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT count(id) AS number_of_movies 
FROM movie 
WHERE (country like '%USA%' OR country like '%INDIA%')
	AND year = 2019;

/* Observations:
Total 1059 movies were produced in the USA or India in the year 2019
*/


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre FROM genre;

/* Observations:
Total 13 genres are present in the genre table
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
	count(movie_id) AS number_of_movies  FROM genre 
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;

/* Observations:
Total 4285 movies produced under "Drama" genre
*/


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT count(*) AS num_of_movie_with_one_genre 
FROM genre 
WHERE movie_id in (SELECT movie_id FROM genre GROUP BY movie_id HAVING count(genre)=1);

/* Observations:
Total 3289 movies belongs to only one genre
*/


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre as genre,
	round(avg(m.duration), 2) AS avg_duration
FROM  movie m 
INNER JOIN genre g
ON  m.id =g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC;

/* Observations:
Action genre movies has highest average duration(112.88)
Horror genre movies has lowest average duration(92.72)
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH genre_rank_summary AS
(SELECT genre,
	count(movie_id) AS movie_count,
	rank() over (ORDER BY count(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre)
SELECT * 
FROM genre_rank_summary
WHERE genre =  "Thriller";

/* Observations:
Thriller genre comes at 3rd rank among all genres in terms of number of movies
*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	min(avg_rating)AS min_avg_rating,
	max(avg_rating) AS max_avg_rating,
	min(total_votes) AS min_total_votes,
	max(total_votes) AS max_total_votes,
	min(median_rating) AS min_median_rating,
	max(median_rating) AS max_median_rating
FROM ratings;

/* Observations:
Average rating is ranging from 1.0 to 10.0
Total votes are in range from 100 to 725138
Median rating is ranging from 1 to 10
*/


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

/* Assumption:
We are considering only 10 movies for top 10 (i.e. not necessarily till rank 10, it can be less then or equals to rank 10 but not more than rank 10)
*/

WITH movie_rank_summary  AS 
(SELECT m.title AS title,
	r.avg_rating AS avg_rating,
	dense_rank() OVER (order by r.avg_rating desc) AS movie_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id)
SELECT * 
FROM movie_rank_summary 
WHERE movie_rank <=10 order by avg_rating desc
limit 10;

/* Observations:
"Kirket" & "Love in Kilnerry" are having highest average rating
*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
	count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count;

/* Observations:
Movies with 1 median rating is lowest in number.
Movies with 7 median rating is highest in number.
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_rank_summary AS
(SELECT m.production_company,
	count(m.id) AS movie_count,
	dense_rank() over (ORDER BY count(m.id ) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE r.avg_rating>8
	AND m.production_company IS NOT NULL
GROUP BY m.production_company)
SELECT *
FROM  production_rank_summary
WHERE prod_company_rank=1;

/* Observations:
Below two production houses has proceduced highest number (3 movies each) of hit movies 
1. Dream Warrior Pictures
2. National Theatre Live
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
	count(m.id) AS movie_count
FROM genre g
INNER JOIN movie m
ON m.id=g.movie_id
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE m.year = 2017
	AND month(m.date_published) = 3
	AND m.country like '%USA%'
	AND r.total_votes>1000
GROUP BY g.genre
ORDER BY movie_count DESC ;

/* Observations:
Drama genre having highest movie count in movies with 1000+ total votes in country USA
*/


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title,
	r.avg_rating,
	g.genre
FROM genre g
INNER JOIN movie m
ON m.id=g.movie_id
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE m.title LIKE 'The%'
	AND r.avg_rating>8
ORDER BY avg_rating;

/* Observations:
Total 15 movies exists that starts with "The" and have average rating greater than 8
*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(r.movie_id) AS Num_of_Movies 
FROM movie m
INNER JOIN ratings r 
ON m.id=r.movie_id
WHERE r.median_rating = 8
	AND (m.date_published between '2018-04-01' AND '2019-04-01');

/* Observations:
Total 361 movies release in b/w 1 April, 2018 and 1 April, 2019 and have median rating of 8
*/


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH GermanMovieSummary AS 
(SELECT sum(r.total_votes) AS Total_Votes_Of_German_Movies
FROM movie m 
INNER JOIN ratings r
ON m.id =r.movie_id
WHERE (languages like '%German%' AND languages NOT LIKE '%Italian%')),
ItalianMovieSummary AS 
(SELECT sum(r.total_votes) AS Total_Votes_Of_Italian_Movies
FROM movie m 
INNER JOIN ratings r
ON m.id =r.movie_id
WHERE (languages like '%Italian%'  AND languages NOT LIKE '%German%' ))
SELECT *, 
CASE 
WHEN Total_Votes_Of_German_Movies > Total_Votes_Of_Italian_Movies 
	THEN 'German movies are more popular than Italian movies'
ELSE 'Italian movies are more popular than German movies'
END AS Popular_movie 
FROM GermanMovieSummary JOIN ItalianMovieSummary; 

/* Observations:
German movies are more popular than Italian movies based on total votes
*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
	SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
	SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
	SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* Observations:
Columns having null values: "height","date_of_birth","known_for_movies"
Columns not having null values: "id","name"
Total 17335 null values are present in "height" column
Total 13431 null values are present in "date_of_birth" column
Total 15226 null values are present in "known_for_movies" column
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with topThreeGenre AS 
(SELECT genre, 
	count(g.movie_id) AS movie_count
FROM genre g 
INNER JOIN ratings r 
ON g.movie_id = r.movie_id
WHERE r.avg_rating >8.0
GROUP BY g.genre
ORDER BY count(g.movie_id) DESC
LIMIT 3)
SELECT n.name AS Director_Name,
	count(dm.movie_id) AS movie_count
FROM names AS n
INNER JOIN director_mapping dm 
ON dm.name_id=n.id
INNER JOIN ratings r 
ON dm.movie_id =r.movie_id
INNER JOIN genre g
ON dm.movie_id =g.movie_id
WHERE r.avg_rating>8.0
	AND g.genre IN (SELECT genre FROM TopThreeGenre)
GROUP BY n.name
ORDER BY movie_count desc
LIMIT 3;

/* Observations:
Director James Mangold having highes number of hits in top 3 genres
*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name AS actor_name,
	count(rm.movie_id) AS movie_count
FROM names AS n
INNER JOIN role_mapping rm
ON rm.name_id=n.id
INNER JOIN ratings r 
ON rm.movie_id =r.movie_id
WHERE r.median_rating>=8.0
	AND category= 'Actor'
GROUP BY n.name
ORDER BY movie_count desc
LIMIT 2;

/* Observations:
Mammootty is on 1st rank with highest number(8) of hit movies 
And Mohanlal is on 2nd rank with 5 hit movies among all actors.
*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
	sum(r.total_votes) as vote_count,
	dense_rank() over (ORDER BY sum(r.total_votes) DESC) as prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id= r.movie_id
GROUP BY m.production_company
ORDER BY vote_count DESC
LIMIT 3;

/* Observations:
Marvel Studios has the highest number of votes for their movies.
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ActorSummary AS 
(SELECT n.name AS actor_name,
	sum(r.total_votes) AS total_votes,
	count(rm.movie_id) AS movie_count,
	round(sum(r.total_votes*r.avg_rating)/sum(r.total_votes ),2) AS actor_avg_rating
FROM names n 
INNER JOIN role_mapping rm
ON rm.name_id = n.id
INNER JOIN ratings r 
ON rm.movie_id = r.movie_id
INNER JOIN movie m
ON rm.movie_id = m.id
WHERE country = "India"
	AND category = 'Actor'
GROUP BY n.name
HAVING count(rm.movie_id)>=5
ORDER BY actor_avg_rating DESC)
SELECT * , 
	dense_rank() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank 
FROM ActorSummary;

/* Observations:
Vijay Sethupathi is the best Indian actor  among all the indian actor who has acted in at least 5 movies.
This rating is based on average ratings. 
*/


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ActressSummary AS 
(SELECT n.name AS actress_name, sum(r.total_votes) AS total_votes,
	count(rm.movie_id) AS movie_count,
	round(sum(r.total_votes*r.avg_rating)/sum(r.total_votes),2) AS actress_avg_rating
FROM names n 
INNER JOIN role_mapping rm
ON rm.name_id = n.id
INNER JOIN ratings r 
ON rm.movie_id = r.movie_id
INNER JOIN movie m
ON rm.movie_id = m.id
WHERE country = 'India'
	AND category = 'Actress'
GROUP BY n.name
HAVING count(rm.movie_id)>=5
ORDER BY actress_avg_rating DESC)
select * ,
	dense_rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM ActressSummary;

/* Observations:
Taapsee Pannu is the best Indian actress among all the indian actress who has acted in at least 5 movies.
This rating is based on average ratings. 
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH ThrillerRatingSummary AS
(SELECT m.title AS Title,
	r.avg_rating AS Rating
FROM genre g 
INNER JOIN ratings r 
USING (movie_id) 
INNER JOIN movie m 
ON m.id = g.movie_id
WHERE genre = 'Thriller')
SELECT *,
CASE 
	WHEN Rating >8 THEN 'Superhit movies'
	WHEN Rating between 7 and 8  THEN 'Hit movies'
    WHEN Rating between 5 and 7 THEN 'One-time-watch movies'
    ELSE 'Flop movies'
END AS Movie_Category 
FROM ThrillerRatingSummary;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT g.genre,
	round(avg(m.duration),2) AS avg_duration,
	sum(round(avg(m.duration),2)) OVER (ORDER BY g.genre ROWS UNBOUNDED PRECEDING ) AS running_total_duration,
	avg(round(avg(m.duration),2)) OVER (ORDER BY g.genre ROWS UNBOUNDED PRECEDING ) AS moving_avg_duration
FROM genre g
INNER JOIN movie m 
ON g.movie_id =m.id
GROUP BY g.genre
ORDER BY g.genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

/* Assumptions:
We are replacing INR with $ by assuming it ws written INR instead of $.
We are not changing income to $ by divinding INR by 82 (INR 82 is current value of one $).
*/

WITH topThreeGenre AS (
SELECT genre,
	count(g.movie_id) AS movie_count
FROM genre g 
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3), topMovie AS
(SELECT g.genre,
	m.year,
	m.title AS movie_name,
	CASE
		WHEN m.worlwide_gross_income like 'INR%' THEN concat('$',substr(m.worlwide_gross_income, 4))
		Else m.worlwide_gross_income
	END AS worldwide_gross_income,
	dense_rank() OVER (PARTITION BY m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
FROM genre g 
INNER JOIN movie m 
ON g.movie_id = m.id
WHERE g.genre IN (SELECT genre FROM topThreeGenre ))
SELECT * 
FROM topMovie
WHERE movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
	count(m.id) AS movie_count,
	row_number() OVER (ORDER BY count(m.id) DESC) AS prod_comp_rank
FROM movie m 
INNER JOIN ratings r
ON m.id=r.movie_id
WHERE POSITION(',' IN m.languages)>0 
AND r.median_rating >=8
AND m.production_company is not null
GROUP BY m.production_company
ORDER BY movie_count DESC
LIMIT 2;


/* Observations:
Production house "Star Cinema" have produced highest number of hit movies among multilingual movies
Production house "Twentieth Century Fox" have produced second highest number of hit movies among multilingual movies
*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH WorldActressSummary AS 
(SELECT n.name AS actress_name, 
	sum(r.total_votes) AS total_votes,
	count(rm.movie_id) AS movie_count,
	round(sum(r.total_votes*r.avg_rating)/sum(r.total_votes),2) AS actress_avg_rating, 
	row_number() over(ORDER BY count(rm.movie_id) DESC) AS actress_rank 
FROM names n 
INNER JOIN role_mapping rm
ON rm.name_id = n.id
INNER JOIN ratings r 
ON rm.movie_id = r.movie_id
INNER JOIN genre g
ON rm.movie_id = g.movie_id
WHERE category = 'Actress'
AND g.genre = 'Drama'
AND r.avg_rating>8
GROUP BY n.name
)
SELECT * FROM WorldActressSummary
WHERE actress_rank<=3 ;

/* Observations:
Parvathy Thiruvothu, Susan Brown and Amanda Lawrence are top three actress for super hit movies
*/


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH DirectorSummary AS 
(SELECT dm.name_id,
	n.name,
	dm.movie_id,
	r.avg_rating,
	r.total_votes,
	m.date_published,
	m.duration,
	LEAD(m.date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY m.date_published, dm.movie_id) AS nextDatePublished
FROM director_mapping dm
INNER JOIN names n 
ON dm.name_id = n.id
INNER JOIN ratings r
ON dm.movie_id = r.movie_id
INNER JOIN movie m 
ON dm.movie_id=m.id)
SELECT name_id AS director_id,
	name AS director_name,
	count(movie_id) AS number_of_movies,
	round(avg(datediff(nextDatePublished,date_published))) AS avg_inter_movie_days,
	round(avg(avg_rating),2) AS avg_rating ,
	sum(total_votes) AS total_votes,
	min(avg_rating) AS min_rating,
	max(avg_rating) AS max_rating,
	sum(duration)  AS total_duration
FROM DirectorSummary
GROUP BY name_id 
ORDER BY number_of_movies DESC
LIMIT 9;

/* Observations:
Andrew Jones & A.L. Vijay has directed most number of movies
*/

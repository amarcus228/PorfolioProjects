-- What years does this data cover?
SELECT
  MIN(year),
  MAX(year)
FROM FilmProject.MovieData

-- Which actors have been in the most films?
SELECT star, COUNT(name) as FilmCount
FROM FilmProject.MovieData
GROUP BY star
ORDER BY FilmCount DESC

-- What are the top 10 shortest films with the biggest budgets?
SELECT name, runtime, budget
FROM FilmProject.MovieData
WHERE budget is not null and runtime is not null
ORDER BY runtime, budget DESC
LIMIT 10

-- What are the top 10 longest films with the biggest budgets?
SELECT name, runtime, budget
FROM FilmProject.MovieData
WHERE budget is not null and runtime is not null
ORDER BY runtime DESC, budget DESC
LIMIT 10

-- Which years had the most films released?
SELECT year, count(name) as NumberofFilms
FROM FilmProject.MovieData
GROUP BY year
ORDER by NumberofFilms DESC

-- What were the highest and lowest grossing years for movies?
SELECT year, SUM(gross) as TotalGross
FROM FilmProject.MovieData
GROUP BY year
ORDER by TotalGross DESC

-- Which genres have the highest average IMDB score?
WITH AvgIMDBScore as
(
  SELECT
  genre, AVG(score) as AvgScore
  FROM FilmProject.MovieData 
  GROUP BY genre
)
SELECT *
FROM AvgIMDBScore
ORDER BY AvgScore DESC

-- Which directors have the highest average IMDB score?
WITH AvgIMDBScore as
(
  SELECT
  director, AVG(score) as AvgScore
  FROM FilmProject.MovieData 
  GROUP BY director
)
SELECT *
FROM AvgIMDBScore
ORDER BY AvgScore DESC



ALTER TABLE Project..CovidDeaths
ADD ConvertedDate DATE;

UPDATE Project..CovidDeaths
SET ConvertedDate = CONVERT(DATE, date, 104);

ALTER TABLE Project..CovidDeaths
DROP COLUMN date;

ALTER TABLE Project..CovidDeaths
ALTER COLUMN ConvertedDate DATE;




ALTER TABLE Project..CovidVaccinations
ADD ConvertedDate DATE;

UPDATE Project..CovidVaccinations
SET ConvertedDate = CONVERT(DATE, date, 104);

ALTER TABLE Project..CovidVaccinations
DROP COLUMN date;

ALTER TABLE Project..CovidVaccinations
ALTER COLUMN ConvertedDate DATE;



UPDATE Project..CovidDeaths
SET total_deaths = CAST(total_deaths as bigint);

ALTER TABLE Project..CovidDeaths
ALTER COLUMN total_deaths bigint;


UPDATE Project..CovidDeaths
SET total_cases = CAST(total_cases as bigint);

ALTER TABLE Project..CovidDeaths
ALTER COLUMN total_cases bigint;


UPDATE Project..CovidDeaths
SET population = CAST(population as bigint);

ALTER TABLE Project..CovidDeaths
ALTER COLUMN population bigint;


UPDATE Project..CovidDeaths
SET total_cases = NULL
WHERE total_cases = '' OR total_cases = '0';

UPDATE Project..CovidDeaths
SET population = NULL
WHERE population = '' OR population = '0';

UPDATE Project..CovidDeaths
SET total_deaths = NULL
WHERE total_deaths = '' OR total_deaths = '0';

UPDATE Project..CovidVaccinations
SET new_vaccinations = NULL
WHERE new_vaccinations = '' OR new_vaccinations = '0';




-- Death percentage vs Population
SELECT TOP 10
    location,
	population,
    MAX(total_deaths) AS total_deaths,
    (MAX(total_deaths) * 1.0 / population) * 100 AS death_rate_percentage
FROM
    Project..CovidDeaths
Where
	continent IS NOT NULL
	And continent <> '' 
	And total_deaths > 5000
GROUP BY
    location,
	population
ORDER BY
    4 DESC;


-- Vacc vs deaths

WITH Pop_vs_vac AS (
    SELECT 
		cd.continent,
		cd.location,
		cd.ConvertedDate,
		cd.population, 
        cv.new_vaccinations,
		cd.total_deaths,
        SUM(CONVERT(bigint, cv.new_vaccinations))
			OVER (PARTITION BY cd.location ORDER BY cd.ConvertedDate) AS Rolling_vaccinations
    FROM 
		Project..CovidDeaths cd 
		JOIN Project..CovidVaccinations cv 
		ON cd.location = cv.location 
		And cd.ConvertedDate = cv.ConvertedDate
    WHERE
		cd.continent IS NOT NULL 
        AND cd.continent <> ''

), vacc_percentage AS (
    SELECT 
		Continent,
		Location,
		Population, 
        ((Rolling_vaccinations * 1.0) / Population) * 100 AS People_vaccinated_percentage,
        ConvertedDate,
		total_deaths
    FROM 
		Pop_vs_vac
)
SELECT 
    TOP 10
    Continent, 
    Location, 
    Population, 
    MAX(People_vaccinated_percentage) AS Vaccination_percentage,
    (MAX(total_deaths) * 1.0/ Population) * 100 AS Total_death_percentage
FROM
	vacc_percentage
WHERE
	total_deaths > 5000
GROUP BY
	Continent,
	Location,
	Population
HAVING 
	(MAX(total_deaths) * 1.0/ Population) * 100 IS NOT NULL
ORDER BY
	4 DESC;





-- Total Cases vs Total Deaths
WITH case_vs_deaths AS (
SELECT
	location,
	population,
	MAX(total_cases) AS total_cases,
	MAX(total_deaths) AS total_deaths,
	(MAX(total_deaths * 1.0) / population) * 100 AS DeathPercentage
FROM
	Project..CovidDeaths
WHERE
	continent IS NOT NULL 
	And continent <> ''
GROUP BY
	location,
	population
HAVING
	MAX(total_cases) > 10000

)
Select TOP 10
	*,
	(total_cases * 1.0/population)* 100 as Infected_percentage
FROM
	case_vs_deaths
WHERE
	total_cases > 10000 
	And total_deaths > 5000
ORDER BY
	6 DESC,
	5 DESC;



-- Population vs Total Cases

SELECT TOP 10
	location,
	population,
	MAX(total_cases) as total_cases,
	(MAX(total_cases * 1.0)/ population)* 100 AS infection_rate
FROM
	Project..CovidDeaths
WHERE
	continent IS NOT NULL 
	And continent <> '' 
GROUP BY 
	location,
	population
ORDER BY 
	2 DESC;
	



-- Top 10 locations where infection is most spread

SELECT Top 10
    location, 
    population, 
    MAX(COALESCE(total_cases, 0)) AS total_infection, -- change NULL with 0 
    (MAX(total_cases) * 1.0 / population)*100 AS infection_rate -- we don't need  MAX(COALESCE(total_cases, 0)) again
FROM 
    Project..CovidDeaths
WHERE 
	continent IS NOT NULL
	And continent <> ''
	And total_cases > 10000
	And total_deaths > 5000
GROUP BY 
    location,
	population
ORDER BY 
    4 DESC;



-- Highest death count per population

Select TOP 10
	location,
	population,
	MAX(total_deaths) AS total_deaths
FROM 
	Project..CovidDeaths
WHERE
	continent IS NOT NULL
	And continent <> ''
GROUP BY
	location,
	population
ORDER BY
	3 DESC;



-- Get infected and died among the world

Select 
	SUM(CAST(new_cases as bigint)) as total_cases,
	SUM(CAST(new_deaths as bigint)) as total_deaths,
	( SUM(CAST(new_deaths as bigint)) * 1.0 / SUM(CAST(new_cases as bigint)) ) * 100 as get_infected_and_died_percentage
FROM 
	Project..CovidDeaths
WHERE
	continent IS NOT NULL
	And continent <> '';



-- Total population vs Vaccinations
with Pop_vs_vac (Continent, Location, Date, Population, New_vaccinations, Rolling_vaccinations)
as (
SELECT
	cd.continent,
	cd.location,
	cd.ConvertedDate,
	cd.population,
	cv.new_vaccinations,
	SUM(CONVERT(bigint, cv.new_vaccinations))
		OVER (Partition by cd.location order by cd.ConvertedDate) As Rolling_vaccinations
FROM
	Project..CovidDeaths cd
	Join Project..CovidVaccinations cv 
	ON cd.location = cv.location
	And cd.ConvertedDate = cv.ConvertedDate
WHERE
	cd.continent IS NOT NULL
	And cd.continent <> '' 
), vacc_percentage AS(
SELECT 
	*,
	((Rolling_vaccinations * 1.0)/Population)*100 AS People_vaccinated_percentage
FROM
	Pop_vs_vac
)

Select TOP 10
	Continent,
	Location,
	Population,
	MAX(People_vaccinated_percentage) AS Vaccination_percentage
FROM 
	vacc_percentage
GROUP BY
	Continent,
	Location,
	Population
ORDER BY
	3 DESC,
	4 DESC;


-- Top 10 most vaccinated locations per percentage
with Pop_vs_vac (Continent, Location, Date, Population, New_vaccinations, Rolling_vaccinations)
as (
SELECT 
	cd.continent,
	cd.location,
	cd.ConvertedDate,
	cd.population,
	cv.new_vaccinations,
	SUM(CONVERT(bigint, cv.new_vaccinations))
		OVER (Partition by cd.location order by cd.ConvertedDate) As Rolling_vaccinations
FROM 
	Project..CovidDeaths cd 
	Join Project..CovidVaccinations cv 
	ON cd.location = cv.location
	And cd.ConvertedDate = cv.ConvertedDate
WHERE
	cd.continent IS NOT NULL
	And cd.continent <> '' 
)
Select TOP 10
	Continent,
	Location,
	Population,
	MAX(Rolling_vaccinations) as Total_vaccinated,
	((MAX(Rolling_vaccinations) * 1.0)/Population)*100 as People_vaccinated_percentage
FROM
	Pop_vs_vac
WHERE 
	Population > 100000
GROUP by
	Continent,
	Location,
	Population
ORDER BY
	5 DESC;


CREATE VIEW Population_vs_vacc AS
SELECT
	cd.continent,
	cd.location,
	cd.ConvertedDate,
	cd.population,
	cv.new_vaccinations,
    SUM(CONVERT(bigint, cv.new_vaccinations)) 
        OVER (PARTITION BY cd.location ORDER BY cd.location, cd.ConvertedDate) AS Rolling_vaccinations
FROM
	Project..CovidDeaths cd
	JOIN Project..CovidVaccinations cv 
    ON cd.location = cv.location 
    And cd.ConvertedDate = cv.ConvertedDate
WHERE
	cd.continent IS NOT NULL And
	cd.continent <> '';



-- death per case
WITH CTE AS (
    SELECT
        location,
        MAX(total_deaths) AS total_deaths,
        MAX(total_cases) AS total_cases,
        (MAX(total_deaths) * 1.0 / MAX(total_cases)) AS death_per_case
    FROM
        Project..CovidDeaths
    WHERE
        population > 100000
        AND total_deaths > 5000
        AND continent IS NOT NULL
        AND continent <> ''
    GROUP BY
        location
)
SELECT TOP 10
    location,
    total_deaths,
    total_cases,
    death_per_case,
    CASE
        WHEN death_per_case > (SELECT AVG(death_per_case) FROM CTE) THEN 'Above Average'
        WHEN death_per_case < (SELECT AVG(death_per_case) FROM CTE) THEN 'Below Average'
		ELSE 'Average'
    END AS death_per_case_comparison
FROM
    CTE
ORDER BY
    2 DESC;



-- Top 10 death percentage 
SELECT TOP 10
    location,
    MAX(total_deaths) AS total_deaths,
    MAX(population) AS population,
    (MAX(total_deaths) * 1.0 / MAX(population)) * 100 AS death_rate_percentage
FROM
    Project..CovidDeaths
GROUP BY
    location
ORDER BY
    4 DESC;


-- Death percentage worldwide
WITH total_find AS (
    SELECT
        location,
        MAX(total_deaths) AS total_deaths,
        MAX(population) AS total_population
    FROM
        Project..CovidDeaths
    WHERE 
        total_deaths IS NOT NULL 
        And continent IS NOT NULL 
        And continent <> ''
    GROUP BY 
        location
)
SELECT 
	SUM(total_deaths) AS total_deaths_worldwide, 
	SUM(total_population) AS total_population_worldwide,
    (SUM(total_deaths) * 1.0 / SUM(total_population)) * 100 AS death_percentage_worldwide
FROM 
    total_find;

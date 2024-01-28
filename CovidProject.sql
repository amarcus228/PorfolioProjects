SELECT
  location, date, total_cases, new_cases, total_deaths, population
FROM covid_project.covid_deaths
ORDER BY 1,2

-- What timeframe does this data span?
SELECT
  min(date)
  max(date),
FROM covid_project.covid_deaths
-- From 1/1/20-4/30/21; looking at peak COVID timeframe

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract COVID in your country
SELECT
  location, date, total_cases,total_deaths,ROUND((total_deaths/total_cases)*100,2) as DeathPercentage
FROM covid_project.covid_deaths
WHERE location = "United States"
ORDER BY 1,2

-- Looking at Total Cases vs US Population
-- Shows what percentage of US population got COVID during timeframe
SELECT
  location, date, total_cases,population,(total_cases/population)*100 as PercentCasesPopulation
FROM covid_project.covid_deaths
WHERE location = "United States"
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT
  location, population, MAX(total_cases) as HighestCaseCount,MAX((total_cases/population)*100) as PercentCasesPopulation
FROM covid_project.covid_deaths
GROUP BY location, population
ORDER BY PercentCasesPopulation DESC

-- Showing Countries with Highest Death Count per Population
SELECT
  location, MAX(total_deaths) as TotalDeathCount
FROM covid_project.covid_deaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing continent with the highest death count per population
SELECT
  continent, MAX(total_deaths) as TotalDeathCount
FROM covid_project.covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT
  date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM covid_project.covid_deaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- Global Numbers Summary
SELECT
  SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM covid_project.covid_deaths
WHERE continent is not null
ORDER BY 1,2

-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
  SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM covid_project.covid_deaths dea
JOIN  covid_project.covid_vaccinations vac
  ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- Use CTE to see rolling vaccination rate by country
With PopvsVac
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
  SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM covid_project.covid_deaths dea
JOIN  covid_project.covid_vaccinations vac
  ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population)*100 as RollingVaccinationRate
FROM PopvsVac
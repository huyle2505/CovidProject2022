SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL


SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking at Total cases and Total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases*100) AS PercentageOfDeaths
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

-- Looking at Total cases and Population
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentageOfCases
FROM PortfolioProject..CovidDeaths
WHERE location = 'VietNam'
ORDER BY 1,2

--Looking at Countries with Highest Infection Rate compared to Population
SELECT location, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS PercentageOfCases
FROM PortfolioProject..CovidDeaths
GROUP BY location
ORDER BY 3 DESC,2 DESC

--Looking at Countries with Highest Deaths Rate compared to Population
SELECT location, 
	MAX(CAST(total_deaths as int)) AS HighesDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

--Looking at continent with Highest Deaths Rate compared to Population
SELECT continent, 
	MAX(CAST(total_deaths as int)) AS HighesDeathCount 
FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC
-- This following is actually correct
SELECT location, 
	MAX(CAST(total_deaths as int)) AS HighesDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY 2 DESC


-- GLOBAL NUMBERS
SELECT
		SUM(new_cases) TotalNewCases
		,SUM(CAST(new_deaths AS int)) TotalNewDeaths
		,SUM(CAST(new_deaths AS int))/SUM(new_cases) NewDeathPercentage
		--,MAX(CAST(total_cases AS int)) HighestNumOfCases 
		--,MAX(total_deaths) HighestNumOfDeaths
		--,MAX(total_deaths/total_cases*100) AS PercentageOfDeaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

-- Looking at Total Population vs Vaccinations
SET ANSI_WARNINGS OFF
SELECT De.continent
	, De.location
	, De.date
	, De.population
	, Va.new_vaccinations
	, SUM(CAST(Va.new_vaccinations AS float)) OVER (PARTITION BY De.location ORDER BY De.location, De.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths De
	JOIN PortfolioProject..CovidVaccinations Va
	ON De.location = Va.location 
	AND De.date = Va.date 
WHERE De.continent IS NOT NULL
ORDER BY 2,3

--USE CTE 

WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS
(SELECT De.continent
	, De.location
	, De.date
	, De.population
	, Va.new_vaccinations
	, SUM(CAST(Va.new_vaccinations AS float)) OVER (PARTITION BY De.location ORDER BY De.location, De.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths De
	JOIN PortfolioProject..CovidVaccinations Va
	ON De.location = Va.location 
	AND De.date = Va.date 
WHERE De.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 VaccinationRate
FROM PopvsVac

--TEMP TABLE
DROP TABLE IF EXISTS #VaccinationRate
CREATE TABLE #VaccinationRate
(Continent nvarchar(255)
, Location nvarchar(255)
, Date datetime
, Population numeric
, New_vaccinations numeric
, RollingPeopleVaccinated numeric
)

INSERT INTO #VaccinationRate
SELECT De.continent
	, De.location
	, De.date
	, De.population
	, Va.new_vaccinations
	, SUM(CAST(Va.new_vaccinations AS float)) OVER (PARTITION BY De.location ORDER BY De.location, De.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths De
	JOIN PortfolioProject..CovidVaccinations Va
	ON De.location = Va.location 
	AND De.date = Va.date 
--WHERE De.continent IS NOT NULL
--ORDER BY 2,3

SELECT  *, (RollingPeopleVaccinated/Population)*100 VaccinationRate
FROM #VaccinationRate
UPDATE #VaccinationRate SET New_vaccinations = 0 WHERE New_vaccinations IS NULL

-- USE VIEW to store data for later viz

CREATE VIEW VaccinationRate AS
SELECT De.continent
	, De.location
	, De.date
	, De.population
	, Va.new_vaccinations
	, SUM(CAST(Va.new_vaccinations AS float)) OVER (PARTITION BY De.location ORDER BY De.location, De.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths De
	JOIN PortfolioProject..CovidVaccinations Va
	ON De.location = Va.location 
	AND De.date = Va.date 
WHERE De.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM VaccinationRate

SELECT*
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT*
FROM CovidVaccinations
ORDER BY 3,4

-- select data the we are going to be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

-- Looking at total cases vs total deaths 
SELECT Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE Location LIKE '%Egypt%'
AND continent IS NOT NULL
ORDER BY 1,2

---- Looking at total cases vs Population 
SELECT Location, date, population, total_cases, (total_cases / population) * 100 AS PercentPopulationInfected
FROM CovidDeaths
--WHERE Location LIKE '%Egypt%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population
SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
--WHERE Location LIKE '%Egypt%'
GROUP BY Location, population
ORDER BY PercentPopulationInfected DESC 

--Looking at countries with highest death count per population
SELECT Location, MAX(CAST (total_deaths as int )/ population) AS HighestCountPerPopulation
FROM CovidDeaths
--WHERE Location LIKE '%Egypt%'
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY HighestCountPerPopulation DESC

--break things down by continent


-- showing continent with thhe highest death count
SELECT continent, MAX(CAST (total_deaths as int )) AS HighestDeathCount
FROM CovidDeaths
--WHERE Location LIKE '%Egypt%'
WHERE continent IS NULL
GROUP BY continent
ORDER BY HighestDeathCount DESC

--GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(CAST (new_deaths AS INT)) AS total_deaths, 
SUM(CAST (new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM CovidDeaths
--WHERE Location LIKE '%Egypt%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


--looking at total pop vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST (vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE vac.continent IS NOT NULL
ORDER BY 2,3 

-- USE CTE 
WITH PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST (vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE vac.continent IS NOT NULL
--ORDER BY 2,3 
)
SELECT *, (RollingPeopleVaccinated / population) * 100 AS PerPop
FROM PopvsVac

-- USE TEMPTABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST (vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE vac.continent IS NOT NULL
--ORDER BY 2,3 

SELECT *, (RollingPeopleVaccinated / population) * 100 AS PerPop
FROM #PercentPopulationVaccinated


-- creating view to store data for later visualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST (vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE vac.continent IS NOT NULL
 






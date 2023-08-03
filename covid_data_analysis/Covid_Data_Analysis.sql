/****** Script from SSMS  ******/
-- List everything
SELECT * FROM [dbo].[CovidDeaths]
GO
SELECT * FROM [dbo].[CovidVaccination]
GO

--List data that is to be used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [dbo].[CovidDeaths] 
WHERE continent IS NOT NULL
ORDER BY location, date;


--Total cases vs total death (by percentage)
-- Likely hood of dying if you contract covid
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT)/total_cases)  * 100 AS 'Death Rate (%)'
FROM [dbo].[CovidDeaths] 
WHERE continent IS NOT NULL
ORDER BY location, date;

-- U.S cases
SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT)/total_cases)  * 100 AS 'U.S Death Rate (%)'
FROM [dbo].[CovidDeaths]
WHERE location LIKE '%United States%' AND  continent IS NOT NULL


--Total cases vs population (by percentage)
SELECT location, date, total_cases, population, (CAST(total_cases AS FLOAT)/population)  * 100 AS 'Population Infected (%)'
FROM [dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY location, date


--Countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS 'Highest Infection Count' ,
							 MAX((CAST(total_cases AS FLOAT)/population)  * 100) AS 'Highest Percentage'
FROM [dbo].[CovidDeaths]
WHERE continent IS NOT NULL
GROUP BY location , population
ORDER BY 'Highest Percentage' DESC
 

 -- Countries with highest death rate per population
 SELECT location, MAX(total_deaths) AS 'Total Death Count' --,
							-- MAX((CAST(total_cases AS FLOAT)/population)  * 100) AS 'Highest Percentage'
FROM [dbo].[CovidDeaths]
WHERE continent IS NOT NULL
GROUP BY location , population
ORDER BY 'Total Death Count' DESC
 


 --By continent
 SELECT continent, MAX(total_deaths) AS 'Total Death Count'
 FROM [dbo].[CovidDeaths]
 WHERE continent IS NOT NULL
 GROUP BY continent

 --Global Numbers
 SELECT  SUM(new_cases) AS 'Total Case', SUM(CONVERT(BIGINT,total_deaths)) AS 'Total Deaths', 
		 SUM(CAST(new_deaths AS FLOAT))/SUM(new_cases)  * 100 AS 'Death Percentage'
 FROM [dbo].[CovidDeaths]
 WHERE continent IS NOT NULL




 --Total population vs vaccination  (Joining two tables)
  --COMMON TABLE EXPRESSION
 WITH PopVac (continent, location, date, population, new_vaccination, PeopleVaccinated)
 AS
(
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ) AS PeopleVaccinated
	FROM [dbo].[CovidDeaths] dea
	JOIN [dbo].[CovidVaccination] vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
 )
 SELECT *, (CONVERT(FLOAT,PeopleVaccinated)/population) * 100  
 FROM PopVac

 --Temp table
 DROP TABLE IF EXISTS #PercentPopulationVaccinated
 CREATE TABLE #PercentPopulationVaccinated
 (
	continent NVARCHAR(255),
	location NVARCHAR(255),
	date DATE,
	population NUMERIC,
	new_vaccination NUMERIC,
	PeopleVaccinated NUMERIC
 )
 INSERT INTO #PercentPopulationVaccinated
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ) AS PeopleVaccinated
	FROM [dbo].[CovidDeaths] dea
	JOIN [dbo].[CovidVaccination] vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
 
 SELECT *, (CONVERT(FLOAT,PeopleVaccinated)/population) * 100  
 FROM #PercentPopulationVaccinated

 
 --Creating view for later visualization
 CREATE VIEW PercentPopulationVaccinated
 AS
	 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
			SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ) AS PeopleVaccinated
		FROM [dbo].[CovidDeaths] dea
		JOIN [dbo].[CovidVaccination] vac
			ON dea.location = vac.location
			AND dea.date = vac.date
		WHERE dea.continent IS NOT NULL



select * 
from ..Coviddataset
order by 3,4


--select * 
--from ..CovidVaccination
--order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from ..Coviddataset
order by 1,2

--looking at toal cases vs total deaths

SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS deathpercentage
FROM 
    PortfolioProject..Coviddataset
where location like '%States%'
ORDER BY 
    location, 
    date;

-- Looing at Total cases vs population 
-- Describes what percent of people got covid in one particular location

SELECT 
    location, 
    date, 
    total_cases, 
    population, 
    (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS deathpercentage
FROM 
    PortfolioProject..Coviddataset
where location like '%States%'
ORDER BY 
    location, 
    date;

-- Looking at countries with highest infection rate

SELECT 
    location,  
    MAX(total_deaths) AS max_deaths, 
    population, 
    (CAST(MAX(total_deaths) AS FLOAT) / CAST(population AS FLOAT)) * 100 AS death_rate_percentage
FROM 
    PortfolioProject..Coviddataset
--WHERE 
--    location LIKE '%India%'
GROUP BY 
    location, 
    population
ORDER BY 
    death_rate_percentage desc




-- Showing Country with the highest dying rate

	SELECT 
    location,  
    MAX(total_deaths) AS max_deaths
    --population, 
    --(CAST(MAX(total_deaths) AS FLOAT) / CAST(population AS FLOAT)) * 100 AS death_rate_percentage
FROM 
    PortfolioProject..Coviddataset
--WHERE 
--    location LIKE '%India%'
GROUP BY 
    location 
    --population
ORDER BY 
    max_deaths desc

-- Looing at the death rate by continents

SELECT 
    continent,  
    MAX(total_deaths) AS max_deaths
    --population, 
    --(CAST(MAX(total_deaths) AS FLOAT) / CAST(population AS FLOAT)) * 100 AS death_rate_percentage
FROM 
    PortfolioProject..Coviddataset
WHERE 
 continent is not NULL
GROUP BY 
    continent 
    --population
ORDER BY 
    max_deaths desc

-- Let's work with the covid vaccination dataset to see the vacination status in different country, continents, etc.

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject .. Coviddataset dea
join PortfolioProject ..CovidVaccination vac
	on dea.location = vac.location
	and dea.location = vac.location
	
-- create view for further visualization.
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rollingpeoplvaccinated
FROM 
    PortfolioProject..Coviddataset dea
JOIN 
    PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;



select * from PercentPopulationVaccinated



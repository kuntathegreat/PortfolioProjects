--display all the data in CovidDeaths table and order by location then by date

SELECT *
FROM PortfolioProject..CovidDeaths
--WHERE continent is not null
order by 3,4

--display all the data in COvidVaccinations table and order by location then by date
SELECT *
FROM PortfolioProject..CovidVaccinations
order by 3,4

--select data that we would be using for the analysis and order by location then by date
--showing the information for each country
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location = 'Nigeria'
and continent is not null
ORDER BY 1,2

--shows most recent total covid cases and death info for a specific country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location = 'Nigeria' 
and date = '2021-12-05 00:00:00.000'

--shows most recent total covid cases and death info for specific continents
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE (Location = 'Africa' or Location = 'Europe')
and date = '2021-12-05 00:00:00.000'

--Total Cases vs Population
--Shows what percentage of the population got covid
SELECT Location, date, population, total_cases, (total_cases/population) * 100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Group by Location, Population
order by PercentPopulationInfected desc


SELECT Location, Population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Group by Location, Population, date
order by PercentPopulationInfected desc

--Showing countries with highest death count per population
SELECT Location, Population, MAX(cast(total_deaths as int)) as TotalDeaths, MAX((total_deaths/Population)) * 100 as DeathCountPerPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Group by Location, Population
order by DeathCountPerPopulation desc

--Let's break things down by continent
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Group by continent
order by TotalDeathCount desc

--Let's break things down by continent
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount, Population
FROM PortfolioProject..CovidDeaths
WHERE continent is null
Group by location, population
order by TotalDeathCount desc

--Showing continents with the highest death countper population
SELECT location, Population, MAX(cast(total_deaths as int)) as TotalDeathCount, (MAX(cast(total_deaths as int))/population) * 100 as DeathPerPop
FROM PortfolioProject..CovidDeaths
WHERE continent is null
and location != 'European Union' and location != 'world' and location != 'High income' and location != 'low income'
 and location != 'upper middle income' and location != 'lower middle income' and location != 'international'
Group by location, population
order by DeathPerPop desc


--excludig eu
SELECT location,  SUM(cast(new_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null
and location != 'European Union' and location != 'world' and location != 'High income' and location != 'low income'
 and location != 'upper middle income' and location != 'lower middle income' and location != 'international'
Group by location
order by TotalDeathCount desc



--GLOBAL NUMBERS 
SELECT date, SUM(new_cases) as total_cases,
	SUM(cast(new_deaths as int)) as total_deaths,
	SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

SELECT SUM(new_cases) as total_cases,
	SUM(cast(new_deaths as int)) as total_deaths,
	SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
--Group by date
order by 1,2

--Looking at Total population vs Total Vaccinations
--using join to link two tables together
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as CurrentPeopleVaccinated
-- (CurrentPeopleVaccinated/population)*100)
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, CurrentPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location,
dea.Date) as CurrentPeopleVaccinated
--, (CurrentPeopleVaccinated/population)*100)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
Select *, (CurrentPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
CurrentPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location,
dea.Date) as CurrentPeopleVaccinated
--, (CurrentPeopleVaccinated/population)*100)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

Select *, (CurrentPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Creating view to store data which will be used later for visualization in Tableau

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location order by dea.Location,
dea.Date) as CurrentPeopleVaccinated
--, (CurrentPeopleVaccinated/population)*100)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated
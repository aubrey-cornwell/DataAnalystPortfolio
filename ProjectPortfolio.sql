Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Show likelihood of dying if you contract covid in your country


Select Location, date, total_cases, total_deaths, ((CONVERT(float, total_deaths))/(CONVERT(float, total_cases)))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location = 'United States'
Order by 1,2 



-- Looking at Total Cases vs Population


Select Location, date, population, total_cases, (total_cases/population)*100 as InfectionRate
From PortfolioProject..CovidDeaths
Where location = 'United States'
Order by 1,2 


-- Looking at Countries with Highest Infection Rate compared to Population


Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentInfectedPopulation
From PortfolioProject..CovidDeaths
--Where location = 'United States'
Group by continent, population
Order by PercentInfectedPopulation DESC


-- Looking at Countries with Highest Death Count per Population


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'United States'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


-- Breaking down by continent
--Showing continents with highest death count per population


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc



--Global Numbers

Select date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, (SUM(new_deaths)/NULLIF(SUM(new_cases),0))*100 as GlobalDeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Date
Order by 1,2

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac

-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select  *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to Store Data for Later Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


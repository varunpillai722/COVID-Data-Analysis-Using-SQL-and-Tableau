-- Covid Analysis Data Analysis Project

select * from coviddeaths;

-- Total cases v/s Total Deaths Compared
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths order by 1,2;

-- Total cases v/s Total Deaths in Canada
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths where location ='Canada' order by 1,2;

-- Percentage of people affected by Covid in Canada
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From coviddeaths Where location ='Canada'
order by 1,2;
-- Countries with high density of Covid cases as poer population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths
Group by Location, Population
order by PercentPopulationInfected desc;

-- --Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
From coviddeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc;


-- Continents with highest death rates

Select continent, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
From coviddeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc;


--- World wide numbers perday

Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as unsigned)) as total_deaths,
 SUM(cast(new_deaths as unsigned))/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
where continent is not null 
Group By date
order by 1,2;

----- Shows Percentage of Population that has recieved at least one Covid Vaccine
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations,unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated

From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;


-- Creating tmp table to store above query

DROP Table if exists #PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated



--- Creating Views 

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations,unsigned)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;
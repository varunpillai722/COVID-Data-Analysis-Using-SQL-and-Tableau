-- Data exploration for COVID data Analysis


---  Total Cases v/s Total Deaths WorldWide and Death Percentage
Select SUM(new_cases) as total_cases,
 SUM(cast(new_deaths as unsigned)) as total_deaths,
 SUM(cast(new_deaths as unsigned))/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
where continent is not null 
order by 1,2;

--- Total Deaths Count per Continent in Decending order
Select location, SUM(cast(new_deaths as unsigned)) as TotalDeathCount
From coviddeaths
Where continent is null 
and location not in ('World', 'European Union', 'International','High income',
'Upper middle income','lower middle income','low income')
Group by location
order by TotalDeathCount desc;

---- Percentage of Population Infected per Country

Select Location, Population, MAX(total_cases) as HighestInfectionCount,
 Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths where location not in ('World', 'European Union', 'International','High income',
'Upper middle income','lower middle income','low income')
Group by Location, Population
order by PercentPopulationInfected desc;

---- Cumulative Date-wise Infection Rate per country

Select Location, Population,date,
 MAX(total_cases) as HighestInfectionCount,
 Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeaths where location not in ('World', 'European Union', 'International','High income',
'Upper middle income','lower middle income','low income')
Group by Location, Population, date
order by PercentPopulationInfected desc;

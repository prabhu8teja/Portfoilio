-- 1.Let’s start by examining the two tables Covid_deaths,Covid_Vaccinations.

Select * 
From Myproject..Covid_Deaths
order by location,date desc


Select *
From Myproject..Covid_Vaccinations
order by date desc


-- 2.Let's select necessary columns from Covid_deaths table

Select continent,location,date,total_cases,new_cases,total_deaths,new_deaths,population
From Myproject..Covid_Deaths
order by location,date desc



-- 3. let's check global numbers
Select location,date,total_cases,new_cases,total_deaths,new_deaths,population
From Myproject..Covid_Deaths
where location ='world'
order by location,date desc

--4. Percentage of people infected in the world

Select location,date,total_cases,population,(total_cases/population) * 100 as percentageofpeopleinffected
from Myproject..Covid_Deaths
where location ='world'
order by date  desc

--5. Percentage of death rate in the world

Select location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 as death_rate
from Myproject..Covid_Deaths
where location ='world'
order by date desc

-- 6. Top 10 countries with highest cases

Select top 10
location,max(total_cases) as Total_cases
from Myproject..Covid_Deaths
where continent is not null
group by location
order by max(total_cases) desc

--7. Top 10 Countries with highest death count

Select top 10
location,MAX(cast(Total_deaths as int)) as highest_death_count 
from Myproject..Covid_Deaths
where continent is not null
group by location
order by 2 desc


--8. Percentage of death rate in india

Select location,date,total_cases,total_deaths,(total_deaths/total_cases) * 100 as death_rate 
from Myproject..Covid_Deaths
where location ='india'
order by date desc

--9. Percentage of people effected by covid-19 in india.

Select location,date,total_cases,population,(total_cases/population) * 100 as percentageofpeopleeffected
from Myproject..Covid_Deaths
where location ='india'
order by date  desc

--10. Countries with Highest Infection Rate compared to Population

Select location,population,max(total_cases) as HighestInfectedCount, Max((total_cases/population))*100 as PercentPopulationInfected
from Myproject..Covid_Deaths
where continent is not null
group by location,population
order by HighestInfectedCount desc

--11 Countries with highest death rate count by population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount, Max((total_deaths/population))*100 as PercentPopulationdied
From Myproject..Covid_Deaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



--12. continents with  Total_death count ,Total_cases and percentage of people died.

Select continent, max(total_cases) as TotalCases,MAX(cast(Total_deaths as int)) as TotalDeathCount,Max((total_deaths/population))*100 as PercentPopulationdied
From Myproject..Covid_Deaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--13 showing the continents 

Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Myproject..Covid_Deaths
where continent is not null 
group by date
order by 1 desc


--14 Showing Total world

Select SUM(new_cases) as world_total_New_cases, SUM(cast(new_deaths as int)) as world_total_new_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Myproject..Covid_Deaths
where location='World'
order by 1 desc

-- 15 now lets look at Covid_vaccinations table
-- how many people got vaccinated in ther world

Select continent,location,date,population,new_vaccinations
, SUM(Cast(new_vaccinations as bigint)) OVER (Partition by Location Order by location, Date) as PeopleVaccinated
From Myproject..Covid_Vaccinations
where continent is not null 
order by 2,3 desc


-- cte 
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select continent,location,date,population,new_vaccinations
, SUM(Cast(new_vaccinations as bigint)) OVER (Partition by Location Order by location, Date) as RollingPeopleVaccinated
From Myproject..Covid_Vaccinations
where continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as percentageofpeoplevaccinated
From PopvsVac





-- Creating temporary table 

drop table if exists percentageofpeoplevaccinated
create table percentageofpeoplevaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into percentageofpeoplevaccinated
Select continent,location,date,population,new_vaccinations
, SUM(Cast(new_vaccinations as bigint)) OVER (Partition by Location Order by location, Date) as RollingPeopleVaccinated
From Myproject..Covid_Vaccinations

Select *, (RollingPeopleVaccinated/Population)*100 as percentageofpeoplevaccinated
From percentageofpeoplevaccinated

-- creating multiple views for visualizations

create view globalnumbers as 
Select location,date,total_cases,new_cases,total_deaths,new_deaths,population
From Myproject..Covid_Deaths
where location ='world'

---visual

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Myproject..Covid_deaths
where location ='world'
order by 1,2



Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Myproject..Covid_Deaths
--Where location like '%states%'
Where continent is  null 
and location not in ('World', 'European Union', 'International','High income','Upper middle income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc


select location,population,max(total_cases) as HighestInfectedCount, Max((total_cases/population))*100 as PercentPopulationInfected
from Myproject..Covid_Deaths
where continent is not null
group by location,population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Myproject..Covid_deaths
Group by Location, Population, date
order by PercentPopulationInfected desc


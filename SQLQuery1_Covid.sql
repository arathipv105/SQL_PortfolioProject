
SELECT *
FROM Covid_Portfolio_Projects..CovidDeaths
where continent is not null

---Looking at the imported data

SELECT location,date, total_cases,new_cases,total_deaths, population
FROM Covid_Portfolio_Projects..CovidDeaths
where continent is not null
ORDER BY 1,2


-- Looking at Total cases vs total Deaths

SELECT location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage 
FROM Covid_Portfolio_Projects..CovidDeaths
where location like '%india%'
and  continent is not null
ORDER BY 1,2


--- Looking at Total cases vs Population : Shows what % of population got covid

SELECT location,date, Population , total_cases,total_deaths,(total_cases/population)*100 as Population_Percentage 
FROM Covid_Portfolio_Projects..CovidDeaths
where continent is not null
ORDER BY 6 desc


--- Looking at countries with highest infection rate

SELECT location, Population , max(total_cases) as highest_infection_count ,max((total_cases/population)*100 ) as PercentPopulationInfected
FROM Covid_Portfolio_Projects..CovidDeaths
--where location like '%india%' or location like '%canada%'
where continent is not null
group by location,population
ORDER BY  PercentPopulationInfected desc


--- Showing countries with highest death count per population:

SELECT location, max(cast(total_deaths as int)) as TotalDeath
FROM Covid_Portfolio_Projects..CovidDeaths
--where location like '%india%' or location like '%canada%'
where continent is not null
group by location
ORDER BY  TotalDeath desc


---Breaking down by continent

SELECT continent, max(cast(total_deaths as int)) as TotalDeath
FROM Covid_Portfolio_Projects..CovidDeaths
--where location like '%india%' or location like '%canada%'
where continent is not null
group by continent
ORDER BY  TotalDeath desc


---Showing continents with the highest death count per population:

SELECT continent, max(cast(total_deaths as int)) as TotalDeath
FROM Covid_Portfolio_Projects..CovidDeaths
--where location like '%india%' or location like '%canada%'
where continent is not null
group by continent
ORDER BY  TotalDeath desc


--- Global Numbers:

SELECT date, SUM(new_cases) as Newcase_count,SUM(cast(new_deaths as int)) as NewDeath_count, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Newdeath_Percentage
FROM Covid_Portfolio_Projects..CovidDeaths
--where location like '%india%'
where continent is not null
and new_cases != '0'
Group by date
ORDER BY Newdeath_Percentage desc

-- Global numbers Without grouping with dates:

SELECT  SUM(new_cases) as Newcase_count,SUM(cast(new_deaths as int)) as NewDeath_count,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Newdeath_Percentage
FROM Covid_Portfolio_Projects..CovidDeaths
--where location like '%india%'
where continent is not null
and new_cases != '0'
ORDER BY Newdeath_Percentage desc

--Covid vaccinations:

Select *
From Covid_Portfolio_Projects..CovidVaccinations
Order by 1,2

-- Total vaccinations in each location

select location,date,total_vaccinations,continent
from Covid_Portfolio_Projects..CovidVaccinations
where continent is not null
order by total_vaccinations desc


--- total test taken vs positive rate:
select location,date,total_tests,positive_rate
from Covid_Portfolio_Projects..CovidVaccinations
where continent is not null
order by positive_rate desc

--- Number of fully vaccinated people
select location, total_tests,people_vaccinated,people_fully_vaccinated
from Covid_Portfolio_Projects..CovidVaccinations
where continent is not null
and total_tests is not null
order by people_fully_vaccinated desc


---Joining two tables:
select *
from Covid_Portfolio_Projects..CovidDeaths dea
join Covid_Portfolio_Projects..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date



--- Total populations vs vaccinations:

select dea.location,dea.continent,dea.date,dea.population,
vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations))OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--using 'bigint' instead of 'int', as rollingPeoplevaccinated results in a value larger than what int can handle. 
from Covid_Portfolio_Projects..CovidDeaths dea
join Covid_Portfolio_Projects..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
--where dea.continent is not null
order by 1,3


-- Same output as above, diff code:

select dea.location,dea.continent,dea.date,dea.population,
vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint))OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Covid_Portfolio_Projects..CovidDeaths dea
join Covid_Portfolio_Projects..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
order by 1,3


--- use CTE:

with popvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated )
as
(
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint))OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Covid_Portfolio_Projects..CovidDeaths dea
join Covid_Portfolio_Projects..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--- order by 1,3
)
select * ,(RollingPeopleVaccinated/population)*100 as Vaccinated_percentage
from popvsVac


--- TEMP Table:

drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Covid_Portfolio_Projects..CovidDeaths dea
join Covid_Portfolio_Projects..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--- order by 1,3

select *, (RollingPeopleVaccinated/population)*100 as Percentage_vaccination
From #PercentPopulationVaccinated


---Creating views to store data for later visualization:

create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,
SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from Covid_Portfolio_Projects..CovidDeaths dea
join Covid_Portfolio_Projects..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--- order by 1,3

select *
From PercentPopulationVaccinated
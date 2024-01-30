SELECT * FROM CovidDeaths cd 



--Vamos começar as analises: Tabela com coluna de todos os casos e outra com total de
--mortes por país


SELECT 
	location,
	sum(new_cases) as total_casos,
	sum(new_deaths) as total_mortes
FROM CovidDeaths cd 
where iso_code not like "OWID%"  --like só para filtro de texto
group by location


--Probabilidade de morte se contrarir COVID por cada país


SELECT 
	location,
	round(sum(new_deaths)/ sum(new_cases) * 100, 2) as "Probalidade_morte" --sem aspas tbm funcionaria
from CovidDeaths cd 
where iso_code not like "OWID"
group by location
order by 2 desc


--Tabela com coluna total de casos e outra com total 
--população por país


SELECT
	location,
	sum(new_cases) as total_casos,
	max(population) as populacao
from CovidDeaths 
where iso_code not like "%OWID"
group by location


---Probabilidade de se infectar por país


SELECT 
	location,
	sum(new_cases) as casos_totais,
	max(population) as populacao_total,
	--1000*sum(new_cases)/ max(population) as "Para cada 1000 pessoas x tem COVID",
	--1000*sum(new_deaths)/ sum(new_cases) as "Para cada 1000 pessoas infectadas x morrem",
	sum(new_deaths)/ sum(new_cases) * 100 as "Probabilidade de morte"
from CovidDeaths cd
where iso_code not like "OWID%"
GROUP BY location 


---Quais os países com maior taxa de infecção?


SELECT 
	location,
	sum(new_cases) as casos_totais,
	max(population) as populacao_total,
	sum(new_cases) / max(population) * 100 as "Maior taxa de Infecção"
from CovidDeaths cd
where iso_code not like "OWID%"
GROUP BY location
order by 4 desc


---Quais os países com maior taxa morte?


SELECT 
	location,
	sum(new_deaths) as total_mortes,
	sum(new_cases) as total_casos,
	sum(new_deaths) / sum(new_cases) *100 as "Maior taxa de morte"
from CovidDeaths cd
where iso_code not like "OWID%"
GROUP BY location
order by 4 desc


---Continentes com maior taxa de morte


select 
	continent,
	sum(new_deaths) as total_mortes,
	sum(new_cases) as total_casos,
	sum(new_deaths) / sum(new_cases) *100 as "Maior taxa de morte por continente"
from CovidDeaths cd 
group by continent
order by 4 desc


 
---Total vs Vacinações: porcentagem da população que 
---recebeu pelo menos uma vacina contra COVID


select * from CovidVaccinations cv 

select
	location,
	count(date),
	count(people_vaccinated),
	count(new_vaccinations)
from CovidVaccinations cv 
group by location


---Vamos criar uma view para armazenar dados para visualizações posteriores?

create view dados_exploratorios as 
select 
	location,
	date,
	people_vaccinated,
	population,
	cast(people_vaccinated as float)/ population * 100 as "% pessoas que se vacinaram"
from CovidDeaths cd 
where people_vaccinated <> ""



	
-- EDA

select *
from layoffs_stagging2;

 select max(total_laid_off), max(percentage_laid_off)
from layoffs_stagging2;

select *
from layoffs_stagging2
where percentage_laid_off = 1
order by total_laid_off desc;

-- industries with highest laid_off

select industry, sum(total_laid_off) as total_laid_0ff
from layoffs_stagging2
group by industry
order by sum(total_laid_off) desc;

-- companies with highest laid off
select company, sum(total_laid_off) as total_laid_off
from layoffs_stagging2
group by company
order by sum(total_laid_off) desc;


select max(`date`), min(`date`)
from layoffs_stagging2;

-- countries who did maximum laid offs 
select country, sum(total_laid_off) total_laid_off
from layoffs_stagging2
group by country
order by sum(total_laid_off) desc;


-- Year with maximum layoffs 
select year(`date`), sum(total_laid_off) total_laid_offs
from layoffs_stagging2
group by year(`date`)
order by sum(total_laid_off) desc;


-- Month with maximum layoffs
select month(`date`), sum(total_laid_off)
from layoffs_stagging2
group by month(`date`)
order by 2;

-- Rolling sum of layoffs from start to end

select  substring(`date`,1,7) as Month, sum(total_laid_off)
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1;

with Rolling_total as
(
select  substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`, total_off,
sum(total_off) over(order by `Month`) as rolling_total
from Rolling_total;



-- Finding out 5 companies with maximum layoffs each year
select company, year(`date`), sum(total_laid_off)
from layoffs_stagging2
group by company, year(`date`)
order by sum(total_laid_off) desc;


with company_year(comapny, years ,lays_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_stagging2
group by company, year(`date`)
), scnd_cte as(
select *, dense_rank() over(partition by years order by lays_off desc) as rank_num
from company_year
where years is not null
)
select * 
from scnd_cte 
where rank_num <= 5;









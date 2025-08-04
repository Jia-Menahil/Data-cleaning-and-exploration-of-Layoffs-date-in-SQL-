-- DATA CLEANING

select *
from layoffs;

-- 1.Remove Duplicates
-- 2.Standardize the data
-- 3.Null values or blank values
-- 4.Remove any columns

create table layoffs_stagging
like layoffs;

insert into layoffs_stagging
select * from layoffs;

select *
from layoffs_stagging;

-- Applying row number to find duplicates

select *,
row_number()over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_stagging ;


with duplicate_cte as
(
select *,
row_number()over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_stagging 
)
select * 
from duplicate_cte 
where row_num > 1;

CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_stagging2;

insert into layoffs_stagging2
select *,
row_number()over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_stagging ;

DELETE 
from layoffs_stagging2
where row_num> 1;

select * 
from layoffs_stagging2;


-- Standardization

 select company , trim(company)
 from layoffs_stagging2;

update layoffs_stagging
set company = trim(company);

select distinct industry
from layoffs_stagging2
order by 1;

select 
distinct industry
from layoffs_stagging2
order by 1;

update layoffs_stagging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct country
from layoffs_stagging2
order by 1;

update layoffs_stagging2
set country = 'United States'
where country like 'United States%'; 

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_stagging2;

update layoffs_stagging2
set date = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_stagging2
modify `date` date;


-- Null values

delete
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null; 


select *
from layoffs_stagging2
where industry is null
or industry = '';

update layoffs_stagging2
set industry = null
where industry = '';

select t1.industry, t2.industry
from layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
where t1.industry is null
and t2.industry is not null;


update layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

alter table layoffs_stagging2
drop column row_num;

select count(*)
from layoffs_stagging2
where total_laid_off is null;


















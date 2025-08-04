# DataCleaningAndExplorationOfLayoffsDate-in-SQL-
## Overview
In this project I used different formulas of sql to clean and get answers of my question through exploring the data. The main purpose of this project to analyze layoffs data to gain insights, patterns and trends regarding layoffs in different companies across the world
## Approach
Layoffs data is the data of different companies world wide showing the number of layoffs they did in different periods of time. As this data is real world data so its cleaning was important step. 
1. Cleaning of data
2. Exploratory data analysis
## Data Cleaning
Here I used follwing steps to clean the data by different sql commands
1. Removed Duplicates
    To find out duplicated rows I wrote following query
``` sql
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
```
2. Standardized the data
   This data contains the date column in text format, I formatted it into date.
   The idustry column contains different names for the same industry 'Crypto', so I used only 'Crypto' for other such industries
   The country column had 'United States' and 'United States.', this issue was also resolved
   
3. Handled null and blank values
   I deleted those rows who had null values in both 'total_laid_off', and 'laid_off_percentage', as these rows were of no use to me.
   Some industry values were null while for the same company other industry values were not null. I handeled this case by writing following query

``` sql
select t1.industry, t2.industry
from layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
where t1.industry is null
and t2.industry is not null;
```
   
4. Removed unnecessary columns
   At the end I didn't need 'row_num' column anymore, so I deleted this column from the table.

## Exploratory data analysis
There were many questions, and I was seeking their answers.
Here are those questions and there answers:
### Time period when this data was collected
``` sql
select max(`date`), min(`date`)
from layoffs_stagging2;
```
The data is from 2020-03-11 to 2023-03-06, This time period show a lot of changes in the world from like 2020 was the year of covid 19
### Industries with highest laid_off
Consumer Industry did highest laysoff

Query:
```sql
select industry, sum(total_laid_off) as total_laid_0ff
from layoffs_stagging2
group by industry
order by sum(total_laid_off) desc;
```

Result

<img width="221" height="144" alt="image" src="https://github.com/user-attachments/assets/5a279f02-a48a-4a96-bf88-a0ff9ccff5ea" />

### Companies with highest laid off
Amazon did maximum laid off
Query:
```sql
select company, sum(total_laid_off) as total_laid_off
from layoffs_stagging2
group by company
order by sum(total_laid_off) desc;
```

Result:

<img width="199" height="138" alt="image" src="https://github.com/user-attachments/assets/b090c699-c3f4-4f36-9aa9-a2217530293a" />

### Countries who did maximum laid offs 
United States with 256559 did highest laid offs
Query:
```sql
select country, sum(total_laid_off) total_laid_off
from layoffs_stagging2
group by country
order by sum(total_laid_off) desc;
```

Result:

<img width="256" height="174" alt="image" src="https://github.com/user-attachments/assets/ffdb4f63-d0e9-49d4-9574-46bab39550bd" />

### Year with maximum layoffs 
In year 2022, maximum laysoffs were done
Query:
```sql
select year(`date`), sum(total_laid_off) total_laid_offs
from layoffs_stagging2
group by year(`date`)
order by sum(total_laid_off) desc;
```

Result:

<img width="200" height="91" alt="image" src="https://github.com/user-attachments/assets/74c8e258-90ae-4e3c-b673-c58b736d5758" />

### Found out rolling totals w.r.t to months

### 5 companies with maximum layoffs each year

Query:
```sql
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
where rank_num <= 5
```

Result:

<img width="264" height="361" alt="image" src="https://github.com/user-attachments/assets/b4e18b85-7524-4505-9b1a-d1d151ad83b0" />























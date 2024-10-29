use world_layoffs;

select * from layoffs;

-- 1. Remove duplicate values
-- 2. Standardize the data (check spellings)
-- 3. Check NULL values or blank values
-- 4. Remove unncessary columns


-- 1) Removing the duplicate values by creating the replica of the actual table


-- Creating the  duplicate table as like the layoffs
create table layoffs_staging
like layoffs;

-- Inserting into the layoff_staging from the layoff table
insert layoffs_staging
select *
from layoffs;

select * from layoffs_staging;

select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num 
from layoffs_staging;


with duplicate_cte as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) as row_num 
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

select * 
from layoffs_staging
where company = 'ABL';

-- created the another table called "layoffs_staging2" for removing the duplicate values from the row_num greater than 1 

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) as row_num 
from layoffs_staging;

-- Disable the safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Deleting the rows with the value greater than 1 or duplicate values
delete
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2;

-- 2) Standardizing the data

-- Removing the white space using the TRIM command

select distinct(company), trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

-- Check the industry column

select distinct(industry), trim(industry)
from layoffs_staging2;

update layoffs_staging2
set industry = trim(industry);

select *
from layoffs_staging2;

-- Check Location column

select distinct(Location), trim(Location)
from layoffs_staging2;

update layoffs_staging2
set Location = trim(Location);

-- Check Country column

select distinct(Country), trim(Country)
from layoffs_staging2;

update layoffs_staging2
set Country = trim(Country);

-- 3) Checking the NULL values

select *
from layoffs_staging2
where total_laid_off is null;

-- Removing the NULL values from the industry
select distinct(Industry)
from layoffs_staging2;

delete 
from layoffs_staging2
where industry is null;

-- 4) Remove Unnecessary column from the database.

-- Removing the row_num column
alter table layoffs_staging2
drop column row_num;
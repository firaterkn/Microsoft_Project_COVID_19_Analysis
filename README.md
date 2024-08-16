# Overview

This project provides a powerful understanding of how the COVID-19 pandemic seen across different areas, highlighting areas with high death rates, infection spreads, and vaccination progress. The insights gathered from these visuals can inform public health strategies and responses to future pandemics.

<br>

# The Questions
The questions to be answered in the project are below:
1. How many people died in the pandemic?
2.  What percentage of people have the World lost because of the virus?
3. What are the most infected areas?
4. What are the locations with the highest death counts?
5. What is the impact of population on the infection?
6. What is the relationship between death rate and population?
7. What is the effect of vaccination on total deaths?

<br>

# Tools Used
**1. Microsoft SQL Server:** Used for the data analysis, enabling efficient data transformation, cleansing, and extraction of critical insights from large datasets.

**2. Power BI:** The visualization tool used to create dynamic and interactive dashboards, presenting the analyzed data in a clear and impactful manner.

<br>

# Data Preparation and Cleanup
The data used is converted into the required format, providing easier and more effective use.
### Date Transformation
```sql

ALTER TABLE Project..CovidDeaths
ADD ConvertedDate DATE;

UPDATE Project..CovidDeaths
SET ConvertedDate = CONVERT(DATE, date, 104);

ALTER TABLE Project..CovidDeaths
DROP COLUMN date;

ALTER TABLE Project..CovidDeaths
ALTER COLUMN ConvertedDate DATE;

```

### Number Transformations

```sql

UPDATE Project..CovidDeaths
SET total_cases = CAST(total_cases as bigint);

ALTER TABLE Project..CovidDeaths
ALTER COLUMN total_cases bigint;

```
### Ease of Operation

```sql

UPDATE Project..CovidVaccinations
SET new_vaccinations = NULL
WHERE new_vaccinations = '' OR new_vaccinations = '0';


```

<br>

# Result
![Dashboard](https://github.com/firaterkn/Microsoft_Project_COVID_19_Analysis/blob/main/COVID-19%20Dashboard.PNG)

<br>

# Insights About the Graph

## 1. Global Overview

**Total Population & Deaths:** The global population stands at **8 billion**, with **3 million** total deaths attributed to COVID-19. This translates to a global death percentage of **0.04%**, indicating that while the virus has had a significant impact, the death rate remains relatively low on a global scale.

## 2. Top 5 Most Infected Locations

- **Czechia:** Leads the list with an infection rate of **15.2%**, indicating a high level of virus spread in the population.
- **Serbia, United States, Israel, and Sweden:** Also show high infection rates, ranging from **9.6%** to **10.1%**, indicating significant virus penetration in these regions.



## 3. Locations with the Highest Deaths

**United States:** Has the highest number of deaths at **576,000**, followed by Brazil **(404,000)** and Mexico **(217,000)**. India and the United Kingdom also feature prominently, reflecting the severe impact of the virus in these regions.

## 4. Population vs. Infection

- **United States and India:** Show a high number of total cases, but the relationship between infection rates and population size varies. The U.S. has a large number of cases although its small population, while India, despite its massive population, has fewer cases.
- **China:** Despite having the largest population, the number of reported cases is significantly lower, which may reflect different containment measures or reporting practices.

## 5. Top 10 Death Rate vs. Population

- **Hungary, Czechia, Bosnia and Herzegovina:** Stand out with high death rates despite to their relatively small populations.
- **Brazil:** Despite having a far larger population, it has a relatively low death rate compared to others.
- Smaller countries like Slovakia and Bulgaria are also highlighted, indicating that even less populous nations faced substantial death rates.


## 6. Top 5 Vaccinated Locations vs. Total Deaths

As vaccination rates increase, death rates decrease. Also, the **120%** vaccination rate in Israel indicates that people have been vaccinated more than once.

<br>

# Insights

## 1. High Infection Rates in Specific Regions 
Countries like Czechia, Serbia, and the United States have experienced extremely high infection rates, leading to widespread illness, overwhelming healthcare systems, and disrupting daily life.
- **Impact:** High infection rates increase the burden on healthcare systems and lead to more significant economic and social disruptions. It also complicates efforts to control the virus spread.

## 2. High Death Rates in Certain Countries
The United States, Brazil, and Mexico have recorded the highest number of deaths, indicating severe impacts on public health.
- **Impact:** High mortality rates strain healthcare resources, cause long-lasting societal impacts, and lead to a significant loss of life, particularly in vulnerable populations.

## 3. Disparity Between Population and Infection/Death Rates
Countries with large populations like India and China show varied relationships between population size and the number of infections or deaths. For instance, India has a significant number of cases, but China, despite its large population, reports fewer cases.
- **Impact:** This disparity suggests challenges in accurately tracking and reporting cases, differences in government responses, and potential underreporting or effective containment measures.

## 4. Inequities in Vaccination Distribution
While some countries like Israel and Chile have achieved high vaccination rates, other regions lag behind, leading to unequal protection against the virus.
- **Impact:** Uneven vaccination coverage can prolong the pandemic, allowing the virus to spread and mutate in under-vaccinated regions, potentially leading to new variants and global setbacks in controlling the virus.

## 5. High Death Rates in Smaller Populations
Countries like Bulgaria, Bosnia and Herzegovina, and Slovakia show high death rates relative to their populations, which could indicate issues like healthcare system strain, late response to the pandemic, or higher prevalence of underlying health conditions.
- **Impact:** High death rates in smaller populations can devastate communities, overwhelm local healthcare services, and lead to long-term demographic changes.

<br>

# Conclusion

 The dashboard serves as a critical resource for understanding the pandemic's impact, revealing the complexities and disparities in infection rates, death rates, and vaccination across different locations. As pandemics continue, the tools used to track and analyze their progress must evolve. By overcoming these challenges, dashboards can be created that empower decision-makers, healthcare workers, and the public with the information needed to effectively respond to the ongoing crisis and ultimately contribute to global efforts to manage and reduce the impact of pandemics.

















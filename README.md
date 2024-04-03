# Patient Satisfaction Score

This repository includes a SQL query for processing hospital data from two datasets:
  <ul>
    <li>v1 HCAHPS 2022: Patient survey responses related to hospital experiences</li>
    <li>Hospital Beds: Information about the number of beds in each hospital and corresponding reporting periods</li>
  </ul>

The analysis aims to gain insights into how hospitals in the United States deliver quality care to patients and to identify areas where hospitals could improve their overall care.

Skills applied: JOIN, Window Functions, Common Table Expressions (CTE), Date Functions, String Functions, and Data Conversion

## SQL Query
<img src = "Snap.png">

Before importing the processed data to Tableau, I took the following actions:
<ul>
  <li>Created tables and columns with correct data types in pgAdmin</li>
  <li>Checked the column formats in each table to make sure they match</li>
</ul>

### Hospital Beds Data Preparation
<ul>
  <li>Convert the "provider_ccn" column to a six-digit string format using LPAD function. </li>
  <li>Convert the "fiscal_year_begin_date" and "fiscal_year_end_date" columns to date format using TO_DATE function</li>
  <li>Calculate the row number for each record within a group of "provider_ccn" ordered by the "fiscal_year_end_date" in descending order to identify the most recent bed count data for each hospital</li>
  <li>Utilized a CTE as it would be used for a join</li>  
</ul>

### Joining Data
<ul>
<li>Join the HCAHPS Data with the preprocessed Hospital Beds Data (hospital_beds_prep) on the "provider_ccn" column</li>
<li>Convert the "facility_id" column in the HCAHPS Data to a six-digit string format using LPAD function</li>
<li>Convert the "start_date" and "end_date" columns in the HCAHPS Data to date format using TO_DATE function</li>
<li>Include all columns from the HCAHPS Data</li>
<li>Include the "number_of_beds" column from the preprocessed Hospital Beds Data</li>
<li>Include the "fiscal_year_begin_date" and "fiscal_year_end_date" columns from the preprocessed Hospital Beds Data (hospital_beds_prep), renaming them as "beds_start_report_period" and "beds_end_report_period"</li>
<li>Filter the results to include only records where the "recent_date" value from the preprocessed Hospital Beds Data is 1, indicating the most recent bed count data for each hospital</li>
</ul>

## Results
As a result of these actions, I was able to determine what areas a hospital needed to improve as they try to give the best quality care to their patients.

## Visualizations

<img src = "Patient Satisfaction Score.png">

I chose to filter for questions that specifically mention "Always" and are rated as "9-10" on a 1-10 scale. These responses are considered top-box choices in the survey and are crucial for evaluating if hospitals are meeting expected standards.

- <b>% of Patients Rating Hospital 9-10</b>
- Survey Response Rate: The percentage of patients who decided to take and complete a hospital survey
- Number of Completed Surveys: The number of patients who decided to take and complete a hospital survey
- Question Delta from Mean Cohort %
- Cohort Hospital Delta Spread: A comparasion between the averages of the selected hospital and its cohort 

These visualizations are created in Tableau and can be found here: <a href = "https://public.tableau.com/app/profile/alejandro.de.la.cruz5286/viz/HCAHPSDashboard_17114636828960/HCAHPSDashboard?publish=yes" relative = unfollow> Patient Satisfaction Score Dashboard</a>

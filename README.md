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

### Hospital Beds Data Preparation
  <li>Convert the "provider_ccn" column to a six-digit string format using LPAD function. </li>
  <li>Convert the "fiscal_year_begin_date" and "fiscal_year_end_date" columns to date format using TO_DATE function</li>
  <li>Calculate the row number for each record within a group of "provider_ccn" ordered by the "fiscal_year_end_date" in descending order to identify the most recent bed count data for each hospital</li>
  <li>Utilized a CTE as it would be used for a join</li>
</ul>

## Results
As a result of these actions, I was able to determine what areas a hospital needed to improve as they try to give the best quality care to their patients.

<img src = "Patient Satisfaction Score.png">

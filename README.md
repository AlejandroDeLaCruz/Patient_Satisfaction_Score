# Patient Satisfaction Score

This repository includes a SQL query for processing hospital data from two datasets:
- v1 HCAHPS 2022: Patient survey responses related to hospital experiences
- Hospital Beds: Information about the number of beds in each hospital and corresponding reporting periods

The analysis aims to gain insights into how hospitals in the United States deliver quality care to patients and to identify areas where hospitals could improve their overall care.

Skills applied: JOIN, Window Functions, Common Table Expressions (CTE), Date Functions, String Functions, and Data Conversion

# SQL Query

```sql
CREATE TABLE "postgres"."Hospital_Data".Tableau_File AS

WITH hospital_beds_prep AS (
	SELECT
		LPAD(provider_ccn::TEXT, 6, '0') AS provider_ccn,
		hospital_name,
		TO_DATE(fiscal_year_begin_date, 'MM/DD/YYYY') AS fiscal_year_begin_date,
		TO_DATE(fiscal_year_end_date, 'MM/DD/YYYY') AS fiscal_year_end_date,
		number_of_beds,
		ROW_NUMBER() OVER(PARTITION BY provider_ccn ORDER BY TO_DATE(fiscal_year_end_date, 'MM/DD/YYYY') DESC) AS nth_row
	FROM
		"postgres"."Hospital_Data".hospital_beds)

SELECT
	LPAD(facility_id::TEXT, 6, '0') AS provider_ccn,
	TO_DATE(start_date, 'MM/DD/YYYY') AS start_date_converted,
	TO_DATE(end_date, 'MM/DD/YYYY') AS end_date_converted,
	hcahps.*,
	beds.number_of_beds,
	beds.fiscal_year_begin_date AS beds_start_report_period,
	beds.fiscal_year_end_date AS beds_end_report_period
FROM
	"postgres"."Hospital_Data".hcahps_data AS hcahps
LEFT JOIN
	hospital_beds_prep AS beds ON beds.provider_ccn = LPAD(facility_id::TEXT, 6, '0')
	AND beds.nth_row = 1;
```

Before importing the processed data to Tableau, I took the following actions:
- Created tables and columns with correct data types in pgAdmin
- Checked the column formats in each table to make sure they match

### Hospital Beds Data Preparation
- Convert the "provider_ccn" column to a six-digit string format using LPAD function
- Convert the "fiscal_year_begin_date" and "fiscal_year_end_date" columns to date format using TO_DATE function
 - Calculate the row number for each record within a group of "provider_ccn" ordered by the "fiscal_year_end_date" in descending order to identify the most recent bed count data for each hospital
- Utilized a CTE as it would be used for a join  


### Joining Data
- Join the HCAHPS Data with the preprocessed Hospital Beds Data (hospital_beds_prep) on the "provider_ccn" column
- Convert the "facility_id" column in the HCAHPS Data to a six-digit string format using LPAD function
- Convert the "start_date" and "end_date" columns in the HCAHPS Data to date format using TO_DATE function
- Include all columns from the HCAHPS Data
- Include the "number_of_beds" column from the preprocessed Hospital Beds Data
- Include the "fiscal_year_begin_date" and "fiscal_year_end_date" columns from the preprocessed Hospital Beds Data (hospital_beds_prep), renaming them as "beds_start_report_period" and "beds_end_report_period"
- Filter the results to include only records where the "recent_date" value from the preprocessed Hospital Beds Data is 1, indicating the most recent bed count data for each hospital


# Visualizations
![HCAHPS Patient Satisfaction Scores](/Patient%20Satisfaction%20Score.png)

I chose to filter for questions that specifically mention "Always" and are rated as "9-10" on a 1-10 scale. These responses are considered top-box choices in the survey and are crucial for evaluating if hospitals are meeting expected standards.

I also chose to filter it by state and the size of the hospital (small, medium, large) based from the number of beds they had in 2022. Here is the calculation below determining the size of the hospital for each respective hospital.

![Hospital Size Calculation](/Hospital%20Size%20Calculation.png)

### Dashboard Components
- **% of Patients Rating Hospital 9-10**: Patients who rated the hospital from 9-10 in a 1-10 scale
- **Survey Response Rate**: The percentage of patients who took and completed the hospital survey
- **Number of Completed Surveys**: The number of patients who took and completed a hospital survey
- **Question Delta from Mean Cohort %**: Selected hospital displaying the delta against the average for each top box question. If positive, then it means the selected hospital is performing well in that area. If negative, it means that the selected hospital is performing poorly in that area
- **Cohort Hospital Delta Spread**: Similar to "Question Delta from Mean Cohort %", but it is comparing the selected hospital to its peers

These visualizations are created in Tableau and can be found here: [Patient Satisfaction Score Dashboard](https://public.tableau.com/app/profile/alejandro.de.la.cruz5286/viz/HCAHPSDashboard_17114636828960/HCAHPSDashboard?publish=yes)

# Results
As a result of these actions, I was able to determine what areas a hospital needed to improve as they try to give the best quality care to their patients.

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
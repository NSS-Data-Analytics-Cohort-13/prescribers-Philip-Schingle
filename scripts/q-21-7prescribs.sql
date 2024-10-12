--Q1.

SELECT p.specialty_description,p.npi,CONCAT(nppes_provider_last_org_name,' ', Nppes_provider_first_name), SUM(total_claim_count) as max_claims
FROM prescriber as p
INNER JOIN prescription as pr
ON p.npi=PR.npi
GROUP BY 1,2,3
Order by max_claims DESC

--ANSWER 1.A,B--DAVID COFFEY

--Q2.a

SELECT p.specialty_description, p.npi, SUM(total_claim_count) as total_sum
FROM prescriber as p
INNER JOIN prescription as pr
ON p.npi=PR.npi
GROUP BY 1,2
Order by total_sum DESC
limit 1

--ANSWER FAMILY PRACTICE

--2b.
SELECT p.specialty_description, p.npi, d.opioid_drug_flag, SUM(total_claim_count) as total_sum
FROM prescriber as p
INNER JOIN prescription as pr
ON p.npi=PR.npi
INNER JOIN drug as d
ON pr.drug_name=d.drug_name
WHERE d.opioid_drug_flag = 'Y'
GROUP BY 1,2,3
ORDER BY total_sum DESC

--Q3a
SELECT d.generic_name,pr.total_drug_cost
FROM prescription as pr
Inner JOIN drug as d
On pr.drug_name=d.drug_name
order by 2 DESC
--ANSWER- Pirfenidone= 2829174.3

--Q3b

SELECT d.generic_name, 
ROUND(MAX(pr.total_drug_cost/pr.total_day_supply),2):: MONEY as total_per_day
FROM prescription as pr
Inner JOIN drug as d
On pr.drug_name=d.drug_name
--WHERE pr.total_day_supply > 0
group by 1
order by total_per_day DESC


--Answer LEVOTHYROXINE SODIUM

--Q4.

SELECT drug_name,
 CASE WHEN opioid_drug_flag ='Y' THEN 'opioid' 
	WHEN antibiotic_drug_flag = 'Y' Then
	'antibiotic' else 'neither'end as drug_type
FROM drug


--Q4b
--SELECT d.drug_name, p.total_drug_cost,
 CASE WHEN opioid_drug_flag ='Y' THEN 'opioid' 
	WHEN antibiotic_drug_flag = 'Y' Then
	'antibiotic' else 'neither'end as drug_type
FROM drug as d
inner JOIN prescription as p
on d.drug_name=p.drug_name

SELECT *
FROM(
SELECT
    CASE 
        WHEN opioid_drug_flag = 'Y' THEN 'Opioid'
        WHEN antibiotic_drug_flag = 'Y' THEN 'Antibiotic'
    END AS drug_type,
    SUM(total_drug_cost) AS total_cost 
FROM drug as D
INNER JOIN Prescription as pr
on d.drug_name=pr.drug_name
--WHERE drug_class IN ('Opioid', 'Antibiotic')
GROUP BY drug_type
ORDER BY total_cost DESC) as SUBQUERY,
CAST(total_cost as MONEY)
WHERE drug_type IS NOT NULL

--Q5

select fc.state, c.cbsa
from CBSA as C
LEFT join fips_county as fc
ON c.fipscounty=fc.fipscounty
WHERE fc.state = 'TN'



SELECT c.cbsa, fc.state
FROM CBSA AS c
INNER JOIN fips_county AS fc 
ON c.fipscounty = fc.fipscounty
WHERE fc.state = 'TN';


--answer 42

--5b
select CBSA, MAX(pop.population) as highest_pop, cbsaname
from CBSA as C
inner join fips_county as fc
ON c.fipscounty=fc.fipscounty
INNER JOIN population as pop
on fc.fipscounty=pop.fipscounty
GROUP BY CBSA,pop.population,cbsaname
ORDER BY population DESC

--5b2
select CBSA, MIN(pop.population) as highest_pop, cbsaname
from CBSA as C
inner join fips_county as fc
ON c.fipscounty=fc.fipscounty
INNER JOIN population as pop
on fc.fipscounty=pop.fipscounty
GROUP BY CBSA,pop.population,cbsaname
ORDER BY population 


--5c
SELECT
	f.county
,	p.population
FROM fips_county AS f
	LEFT JOIN population AS p
		ON f.fipscounty = p.fipscounty
WHERE county NOT IN
	(SELECT fipscounty
	FROM cbsa
	WHERE fipscounty IS NULL)
ORDER BY
	f.county
,	p.population DESC;







--Q6

SELECT total_claim_count,d.drug_name
FROM prescription as pr
INNER JOIN drug as d
ON pr.drug_name=d.drug_name
WHERE total_claim_count >= 3000


--Q6b + c 
SELECT total_claim_count,d.drug_name,CONCAT(pres.nppes_provider_last_org_name,' ',
		pres.nppes_provider_first_name),
CASE WHEN opioid_drug_flag = 'Y' THEN 'Opioid'
	WHEN opioid_drug_flag = 'N' THEN 'Not Opioid' END as opioid
FROM prescription as pr
INNER JOIN drug as d
ON pr.drug_name=d.drug_name
INNER JOIN prescriber as pres
ON pr.npi=pres.npi
WHERE total_claim_count >= 3000 


--Q7

Select p.npi,d.drug_name,
	p.specialty_description,
	nppes_provider_city,
	d.opioid_drug_flag
FROM prescriber as p
CROSS JOIN drug as d
WHERE d.opioid_drug_flag = 'Y'
AND nppes_provider_city = 'NASHVILLE'
AND specialty_description = 'Pain Management'



Select p.npi,d.drug_name,
	--p.specialty_description,
	--nppes_provider_city,
	--d.opioid_drug_flag,
	pre.total_claim_count
FROM prescriber as p
CROSS JOIN drug as d
FULL JOIN prescription as Pre
on p.npi=pre.npi
WHERE d.opioid_drug_flag = 'Y'
AND nppes_provider_city = 'NASHVILLE'
AND specialty_description = 'Pain Management'




--(SELECT prescriber.nppes_provider_city
FROM prescriber
--WHERE prescriber.nppes_provider_city ='NASHVILLE' )

(SELECT drug_name
FROM drug)






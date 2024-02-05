/** After careful inspection of the raw datam 6 tables will be created.
This will be in accordiance to the data nomalization guidelines **/

CREATE DATABASE subscription_data;

CREATE TABLE contact_type(
    contact_name VARCHAR,
    contact_id INT PRIMARY KEY
    );
-- table containing the just the contact types and their corresponding contact ID.

CREATE TABLE job(
    job_type VARCHAR,
    job_id INT PRIMARY KEY
    );
-- table containing just the job types and their corresponding IDs

CREATE TABLE education(
    education_name VARCHAR,
    education_id INT PRIMARY KEY
    );
-- Table contatin just the education names and their corresponding IDs.

CREATE TABLE housing(
    housing_status VARCHAR,
    housing_id INT PRIMARY KEY
    );
--Table containing the various housing status and their corresponding IDs

CREATE TABLE marital(
    marital_status VARCHAR,
    marital_id INT PRIMARY KEY
    );
--Table containing the various marital status and their corresponding IDs

CREATE TABLE personal_details(
    account_id INT,
    subscription_year INT,
    user_age INT,
    contact_id INT,
    job_id INT,
    education_id INT,
    housing_id INT,
    marital_id INT,
    CONSTRAINT fk_contact_id FOREIGN KEY (contact_id) REFERENCES contact_type(contact_id),
    CONSTRAINT fk_job_id FOREIGN KEY (job_id) REFERENCES job(job_id),
    CONSTRAINT fk_education_id FOREIGN KEY (education_id) REFERENCES education(education_id),
    CONSTRAINT fk_housing_id FOREIGN KEY (housing_id) REFERENCES housing(housing_id),
    CONSTRAINT fk_marital_id FOREIGN KEY (marital_id) REFERENCES marital(marital_id)
    );
-- Table containing the userID, account ID, user_age and foreign keys to all the linking tables.

/** Next phase is to import the data into the respective tables. We currently have just 2 types of contact; telephone and celular. 
So we just enter them manually.**/

INSERT INTO contact_type VALUES
    ('telephone', 1),
    ('cellular', 2);

COPY job from '/Users/Shared/job.csv' DELIMITER ',' CSV HEADER;
COPY education from '/Users/Shared/education.csv' DELIMITER ',' CSV HEADER;

INSERT INTO housing VALUES
    ('yes', 1),
    ('no',0);

COPY marital from '/Users/Shared/marital.csv' DELIMITER ',' CSV HEADER;

COPY personal_details from '/Users/Shared/personal_details.csv' DELIMITER ',' CSV HEADER;


SELECT  account_id,
        subscription_year,
        user_age, 
        contact_name, 
        job_type, 
        education_name, 
        housing_status, 
        marital_status 
FROM personal_details
    JOIN contact_type USING (contact_id)
    JOIN job USING (job_id)
    JOIN education USING (education_id)
    JOIN housing USING (housing_id)
    JOIN marital USING (marital_id)

-- CREATING FREQUENCY DISTRIBUTION USING VIEWS
CREATE VIEW filtered_data AS 
    select account_id, user_age, job_type, education_name, housing_status from personal_details
            JOIN job USING (job_id)
            JOIN education USING (education_id)
            JOIN housing USING (housing_id);

-- VIEW CREATED

-- Computing Frequency distributio, % frequency and cumulative frequency on the user_age accounts
        
     SELECT fd as "Frequency_Distribution",
            counted as "Frequency",
            100 * counted/sum(counted) OVER () as "% Frequency",
            SUM(counted) OVER (ORDER BY counted) as "Cummulative"
    FROM(
        SELECT  fd,
                count(fd) as "counted"
        FROM (
            SELECT user_age,
                CASE    WHEN user_age BETWEEN 20 and 30 then '20-30'
                        WHEN user_age BETWEEN 31 and 40 then '31-40'
                        WHEN user_age BETWEEN 41 and 50 then '41-50'
                        ELSE '51-60'
                END as fd
            FROM filtered_data) as a
        GROUP BY fd)
  

select * from filtered_data

select education_name, count(education_name)
FROM filtered_data
group by education_name

Select job_type, count(job_type)
from filtered_data
group by job_type

/**select * from(
select user_age, avg(user_age::decimal) OVER (ORDER BY user_age RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "average_age"
from filtered_data)
where user_age>average_age
**/


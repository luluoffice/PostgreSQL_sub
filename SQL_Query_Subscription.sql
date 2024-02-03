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
    user_id SERIAL PRIMARY KEY,
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


INSERT INTO personal_details (account_id,
    subscription_year,
    user_age,
    contact_id,
    job_id,
    education_id,
    housing_id,
    marital_id)
    select * from temp

select * from personal_details

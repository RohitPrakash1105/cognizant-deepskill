SELECT student_id , COUNT(*) AS total_courses
    FROM enrollments
    GROUP BY student_id HAVING Count(*) >(SELECT AVG(total_courses)
FROM (
    SELECT COUNT(*) AS total_courses
    FROM enrollments
    GROUP BY student_id
)) ;

SELECT c.course_id, c.course_name
FROM courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollments e
    WHERE e.course_id = c.course_id
      AND e.grade <> 'A'
);

SELECT d.dept_name , professor_id , p.prof_name , p.salary 
from departments as d JOIN professors as p
ON d.department_id  = p.department_id 
WHERE p.salary = (SELECT max(p2.salary) from professors p2 
WHERE p2.department_id  = p.department_id);

SELECT *
FROM (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM professors
    GROUP BY department_id
) AS dept_avg
WHERE avg_salary > 85000;

CREATE OR REPLACE VIEW vw_student_enrollment_summary AS
SELECT
    s.first_name || ' ' || s.last_name AS full_name,
    d.dept_name,
    COUNT(e.course_id) AS no_of_courses,
    AVG(
        CASE e.grade
            WHEN 'A' THEN 4
            WHEN 'B' THEN 3
            WHEN 'C' THEN 2
            WHEN 'D' THEN 1
            WHEN 'F' THEN 0
        END
    ) AS gpa
FROM students s
JOIN departments d
ON s.department_id = d.department_id
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY
    s.student_id,
    s.first_name,
    s.last_name,
    d.dept_name;

SELECT * FROM vw_student_enrollment_summary;

create or replace view vw_course_stats as
SELECT c.course_name , c.course_code , count(*) as total_enrollments,
AVG(
	CASE e.grade
		WHEN 'A' THEN 4
		WHEN 'B' THEN 3
		WHEN 'C' THEN 2
		WHEN 'D' THEN 1
		WHEN 'F' THEN 0
	END
) AS gpa
FROM courses c join enrollments e on c.course_id = e.course_id 
group by e.course_id,c.course_name , c.course_code;

SELECT * FROM vw_course_stats;

SELECT full_name , gpa from vw_student_enrollment_summary where gpa>3.0;

UPDATE vw_student_enrollment_summary
SET gpa = 4.00
WHERE full_name = 'Rohit Kumar';
/*
The UPDATE on vw_student_enrollment_summary fails because it is a
multi-table view containing JOINs, GROUP BY, COUNT(), AVG(), and
computed columns.

Such views are generally not automatically updatable since PostgreSQL
cannot determine which underlying table(s) should be modified or how
derived values should be recalculated. Only simple views based on a
single table without aggregation are automatically updatable.
*/

DROP VIEW IF EXISTS vw_student_enrollment_summary;
DROP VIEW IF EXISTS vw_course_stats;

CREATE VIEW vw_student_enrollment_summary AS
SELECT *
FROM students
WHERE department_id = 1
WITH CHECK OPTION;

UPDATE vw_student_enrollment_summary
SET email = 'rohit@college.edu'
WHERE student_id = 1;

/*WITH CHECK OPTION prevents INSERT or UPDATE operations through a view from 
creating rows that would no longer be visible through that view. 
It is only applicable to updatable views, 
which are typically based on a single table without joins or aggregate functions.*/
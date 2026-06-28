SELECT *
FROM students
WHERE enrollment_year = 2022
ORDER BY last_name ASC;

SELECT *
FROM courses
WHERE credits > 3
ORDER BY credits DESC;

SELECT *
FROM professors
WHERE salary BETWEEN 80000 AND 95000;

SELECT *
FROM students
WHERE email LIKE '%@college.edu';

SELECT
    enrollment_year,
    COUNT(*) AS total_students
FROM students
GROUP BY enrollment_year;

SELECT
    s.first_name || ' ' || s.last_name AS full_name,
    d.department_name
FROM students s
JOIN departments d
ON s.department_id = d.department_id;

SELECT
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_name,
    e.enrollment_date
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id;

SELECT s.*
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

SELECT
    c.course_id,
    c.course_name,
    COUNT(e.student_id) AS enrolled_students
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

SELECT
    d.department_name,
    p.first_name,
    p.last_name,
    p.salary
FROM departments d
LEFT JOIN professors p
ON d.department_id = p.department_id;

SELECT c.course_name, Count(e.course_id) as enrollment_count 
From enrollments as e join courses as c on e.course_id = c.course_id
group by e.course_id, c.course_name;

SELECT ROUND(avg(salary),2) from professors 
group by department_id,salary;

Select dept_name from departments 
where budget>600000;

SELECT
    e.grade,
    COUNT(*) AS total
FROM enrollments AS e
JOIN courses AS c
ON e.course_id = c.course_id
WHERE c.course_name = 'CS101'
GROUP BY e.grade;

SELECT
    c.course_name,
    COUNT(e.course_id) AS enrollment_count
FROM enrollments AS e
JOIN courses AS c
ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.course_id) > 2;
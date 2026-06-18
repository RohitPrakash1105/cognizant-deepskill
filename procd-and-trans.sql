
CREATE OR REPLACE FUNCTION fn_enroll_student(
    p_student_id INT,
    p_course_id INT,
    p_enrollment_date DATE
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM enrollments
        WHERE student_id = p_student_id
        AND course_id = p_course_id
    ) THEN

        RAISE NOTICE 'Student already enrolled';

    ELSE

        INSERT INTO enrollments(student_id, course_id, enrollment_date)
        VALUES (p_student_id, p_course_id, p_enrollment_date);

        RAISE NOTICE 'Enrollment added';

    END IF;
END;
$$;

SELECT fn_enroll_student(1, 101, '2026-08-07');

CREATE TABLE department_transfer_log (
    transfer_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    old_department_id INT NOT NULL,
    new_department_id INT NOT NULL,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE PROCEDURE sp_transfer_student(
    p_student_id INT,
    p_new_department_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_department_id INT;
BEGIN

    SELECT department_id
    INTO v_old_department_id
    FROM students
    WHERE student_id = p_student_id;

    IF v_old_department_id IS NULL THEN
        RAISE EXCEPTION 'Student % does not exist', p_student_id;
    END IF;

    UPDATE students
    SET department_id = p_new_department_id
    WHERE student_id = p_student_id;

    INSERT INTO department_transfer_log(
        student_id,
        old_department_id,
        new_department_id
    )
    VALUES (
        p_student_id,
        v_old_department_id,
        p_new_department_id
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Transfer failed: %', SQLERRM;
        RAISE;
END;
$$;
	
CALL sp_transfer_student(1, 3);

BEGIN;

-- Insert first enrollment (this should succeed)
INSERT INTO enrollments(student_id, course_id, enrollment_date, grade)
VALUES (1, 101, '2026-06-18', 'A');

-- Create a SAVEPOINT after the first insert
SAVEPOINT after_first;

-- Insert second enrollment (deliberately fail: invalid course_id)
INSERT INTO enrollments(student_id, course_id, enrollment_date, grade)
VALUES (1, 9999, '2026-06-18', 'B');  -- 9999 doesn't exist, FK violation

-- Roll back only to the SAVEPOINT
ROLLBACK TO SAVEPOINT after_first;

-- Commit the transaction
COMMIT;


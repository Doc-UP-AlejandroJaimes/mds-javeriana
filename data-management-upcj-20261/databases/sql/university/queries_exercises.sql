-- =============================================================
-- CONSULTAS SQL - Oracle 21c
-- Modelo: Sistema Académico
-- Convención: Alias de tablas T1, T2... | Alias de campos en inglés
-- =============================================================


-- -------------------------------------------------------------
-- A. Listar todos los cursos ofrecidos en la carrera de
--    Ingeniería de Sistemas, considerando que un mismo curso
--    puede ser dictado por diferentes profesores, en diferentes
--    salones y horarios.
--    Datos: nombre del curso, nombre completo del profesor,
--           salón y hora de inicio del curso.
-- -------------------------------------------------------------
SELECT
    T1.nombre                                   AS course_name,
    T5.nombre || ' ' || T5.apellido             AS fullname_professor,
    T4.nombre                                   AS classroom_name,
    T3.hora_inicio                              AS start_time
FROM Cursos            T1
JOIN Cursos_Carreras   T2  ON T2.id_curso    = T1.id
JOIN Carreras          T6  ON T6.id          = T2.id_carrera
JOIN Calendario_Cursos T3  ON T3.id_curso    = T1.id
JOIN Salones           T4  ON T4.id          = T3.id_salon
JOIN Usuarios          T5  ON T5.id          = T3.id_profesor
WHERE T6.nombre = 'Ingeniería de Sistemas';


-- -------------------------------------------------------------
-- B. Obtener la lista de profesores que dictan cursos
--    pertenecientes a la facultad de Humanidades.
--    Datos: nombre completo del profesor y nombre del curso.
-- -------------------------------------------------------------
SELECT DISTINCT
    T4.nombre || ' ' || T4.apellido             AS fullname_professor,
    T1.nombre                                   AS course_name
FROM Cursos            T1
JOIN Facultades        T2  ON T2.id          = T1.id_facultad
JOIN Calendario_Cursos T3  ON T3.id_curso    = T1.id
JOIN Usuarios          T4  ON T4.id          = T3.id_profesor
WHERE T2.nombre = 'Humanidades';


-- -------------------------------------------------------------
-- C. Obtener la lista de profesores que dictan cursos en
--    DOS carreras diferentes.
--    Datos: nombre completo del profesor, nombre del curso
--           y nombre de la carrera a la que pertenece el curso.
--    Pista: se usa WITH (CTE) para identificar los profesores
--           que aparecen en más de una carrera.
-- -------------------------------------------------------------
WITH
proffessors_in_two_bachelors AS (
    SELECT 
        T3.id_profesor
    FROM Calendario_Cursos T3
    JOIN Cursos_Carreras   T2  ON T2.id_curso   = T3.id_curso
    GROUP BY T3.id_profesor
    HAVING COUNT(DISTINCT T2.id_carrera) >= 2
), bachelors_complements AS (
    SELECT
        T5.nombre || ' ' || T5.apellido             AS fullname_professor,
        T1.nombre                                   AS course_name,
        T6.nombre                                   AS career_name
    FROM cursos T1
    JOIN cursos_carreras T2
        ON T2.id_curso = T1.id_curso
    JOIN calendarios_cursos T3
        ON T3.id_curso = T2.id_curso
    JOIN proffessors_in_two_bachelors T4
        ON T4.id_profesor = T3.id_profesor
    JOIN usuarios T5
        ON T5.id_profesor = T4.id_profesor
    JOIN carreras T6
        ON T6.id_carrera = T2.id_carrera
)
SELECT *
FROM bachelors_complements;



WITH ProfesoresDosCarreras AS (
    -- Identificar profesores que dictan en al menos 2 carreras distintas
    SELECT T3.id_profesor
    FROM Calendario_Cursos T3
    JOIN Cursos_Carreras   T2  ON T2.id_curso   = T3.id_curso
    GROUP BY T3.id_profesor
    HAVING COUNT(DISTINCT T2.id_carrera) >= 2
)
SELECT DISTINCT
    T5.nombre || ' ' || T5.apellido             AS fullname_professor,
    T1.nombre                                   AS course_name,
    T6.nombre                                   AS career_name
FROM Cursos                 T1
JOIN Cursos_Carreras        T2  ON T2.id_curso    = T1.id
JOIN Calendario_Cursos      T3  ON T3.id_curso    = T1.id
JOIN ProfesoresDosCarreras  T4  ON T4.id_profesor = T3.id_profesor
JOIN Usuarios               T5  ON T5.id          = T3.id_profesor
JOIN Carreras               T6  ON T6.id          = T2.id_carrera
ORDER BY fullname_professor, career_name;


-- -------------------------------------------------------------
-- D. Para un estudiante en particular, obtener el listado de
--    cursos que PUEDE matricular.
--    Condiciones:
--      - Los cursos pertenecen a carreras diferentes.
--      - El estudiante NO puede matricular un curso que ya
--        esté matriculado (usa NOT EXISTS).
--    Datos: nombre del curso, nombre de la carrera y semestre.
--
--    NOTA: Reemplaza el valor 1 en T_EST.id = 1 con el ID
--          del estudiante deseado.
-- -------------------------------------------------------------
SELECT
    T1.nombre                                   AS course_name,
    T3.nombre                                   AS career_name,
    T2.semestre                                 AS semester
FROM Cursos          T1
JOIN Cursos_Carreras T2  ON T2.id_curso   = T1.id
JOIN Carreras        T3  ON T3.id         = T2.id_carrera
WHERE NOT EXISTS (
    -- Excluir cursos ya matriculados por el estudiante
    SELECT 1
    FROM Cursos_Estudiantes T4
    JOIN Calendario_Cursos  T5  ON T5.id      = T4.id_calendario
    WHERE T5.id_curso  = T1.id
      AND T4.id_usuario = 1  -- <-- ID del estudiante específico
)
ORDER BY T3.nombre, T2.semestre;


-- -------------------------------------------------------------
-- E. Listar los estudiantes inscritos en un curso determinado.
--    Datos: nombre completo del estudiante y nombre del curso.
--
--    NOTA: Reemplaza el valor 'Cálculo I' en T1.nombre con
--          el nombre del curso deseado.
-- -------------------------------------------------------------
SELECT DISTINCT
    T4.nombre || ' ' || T4.apellido             AS fullname_student,
    T1.nombre                                   AS course_name
FROM Cursos              T1
JOIN Calendario_Cursos   T2  ON T2.id_curso    = T1.id
JOIN Cursos_Estudiantes  T3  ON T3.id_calendario = T2.id
JOIN Usuarios            T4  ON T4.id          = T3.id_usuario
WHERE T1.nombre = 'Cálculo I'  -- <-- Nombre del curso específico
ORDER BY fullname_student;


WITH
    proffessors_in_two_bachelors(

    )

SELECT
    T4.nombre || ' ' || T4.apellido AS profesor,
    COUNT(T3.id_curso) AS total_cursos_dicta
FROM calendario_cursos T1
JOIN usuarios T2
    ON T1.id_profesor = T2.id_usuario
JOIN cursos T3
    ON T3.id_curso = T1.id_curso
JOIN cursos_carreras T4
    ON T4.id_curso = T3.id_curso
JOIN carreras T5
    ON T5.id_carrera = T4.id_carrera
GROUP BY T4.nombre, T4.apellido
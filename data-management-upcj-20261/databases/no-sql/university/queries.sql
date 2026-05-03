// ─────────────────────────────────────────────────────────────
// CONSULTAS - Base de datos universidad
// ─────────────────────────────────────────────────────────────

// A. Lista de cursos de Ingeniería de Sistemas con profesor, salón y hora
db.carreras.aggregate([
    // 1. Filtrar la carrera
    { $match: { nombre: "Ingeniería de Sistemas" } },

    // 2. Descomponer el array de cursos para trabajar uno a uno
    { $unwind: "$cursos" },

    // 3. Unir con la colección cursos
    { $lookup: {
        from: "cursos",
        localField: "cursos.curso",
        foreignField: "_id",
        as: "datos_curso"
    }},
    { $unwind: "$datos_curso" },

    // 4. Unir con la colección profesores
    { $lookup: {
        from: "profesores",
        localField: "datos_curso.profesor",
        foreignField: "_id",
        as: "datos_profesor"
    }},
    { $unwind: "$datos_profesor" },

    // 5. Descomponer el calendario para obtener salón y hora
    { $unwind: "$datos_curso.calendario" },

    // 6. Proyectar los campos solicitados
    { $project: {
        _id: 0,
        curso: "$datos_curso.nombre",
        profesor: "$datos_profesor.nombre",
        salon: "$datos_curso.calendario.salon",
        hora_inicio: "$datos_curso.calendario.inicio",
        hora_fin: "$datos_curso.calendario.fin"
    }}
])


// ─────────────────────────────────────────────────────────────

// B. Profesores que dictan cursos en dos carreras diferentes
db.carreras.aggregate([
    // 1. Descomponer el array de cursos
    { $unwind: "$cursos" },

    // 2. Unir con la colección cursos
    { $lookup: {
        from: "cursos",
        localField: "cursos.curso",
        foreignField: "_id",
        as: "datos_curso"
    }},
    { $unwind: "$datos_curso" },

    // 3. Unir con la colección profesores
    { $lookup: {
        from: "profesores",
        localField: "datos_curso.profesor",
        foreignField: "_id",
        as: "datos_profesor"
    }},
    { $unwind: "$datos_profesor" },

    // 4. Agrupar por profesor para contar en cuantas carreras distintas aparece
    { $group: {
        _id: "$datos_profesor._id",
        nombre_profesor: { $first: "$datos_profesor.nombre" },
        carreras: { $addToSet: "$nombre" },
        cursos: { $addToSet: "$datos_curso.nombre" }
    }},

    // 5. Filtrar solo los que aparecen en 2 o mas carreras
    { $match: {
        $expr: { $gte: [{ $size: "$carreras" }, 2] }
    }},

    // 6. Descomponer para mostrar una fila por curso
    { $unwind: "$cursos" },

    // 7. Unir de nuevo con carreras para obtener el nombre de la carrera por curso
    { $lookup: {
        from: "carreras",
        let: { nombre_curso: "$cursos" },
        pipeline: [
            { $unwind: "$cursos" },
            { $lookup: {
                from: "cursos",
                localField: "cursos.curso",
                foreignField: "_id",
                as: "info_curso"
            }},
            { $unwind: "$info_curso" },
            { $match: {
                $expr: { $eq: ["$info_curso.nombre", "$$nombre_curso"] }
            }},
            { $project: { _id: 0, carrera: "$nombre" } }
        ],
        as: "info_carrera"
    }},
    { $unwind: "$info_carrera" },

    // 8. Proyectar los campos solicitados
    { $project: {
        _id: 0,
        profesor: "$nombre_profesor",
        curso: "$cursos",
        carrera: "$info_carrera.carrera"
    }}
])


// ─────────────────────────────────────────────────────────────

// C. Cursos que puede matricular un estudiante en particular
// Condiciones:
//   - Cursos de su misma carrera
//   - Que no haya matriculado ya
//   - Agrupados por semestre

db.estudiantes.aggregate([
    // 1. Filtrar el estudiante en particular (cambiar el nombre segun el caso)
    { $match: { nombre: "Nombre del Estudiante" } },

    // 2. Unir con carreras para obtener todos los cursos de su carrera
    { $lookup: {
        from: "carreras",
        localField: "carreras",
        foreignField: "_id",
        as: "datos_carrera"
    }},
    { $unwind: "$datos_carrera" },

    // 3. Descomponer el array de cursos de la carrera
    { $unwind: "$datos_carrera.cursos" },

    // 4. Unir con la coleccion cursos para obtener el detalle
    { $lookup: {
        from: "cursos",
        localField: "datos_carrera.cursos.curso",
        foreignField: "_id",
        as: "detalle_curso"
    }},
    { $unwind: "$detalle_curso" },

    // 5. Filtrar los cursos que el estudiante ya tiene matriculados
    { $match: {
        $expr: {
            $not: {
                $in: ["$detalle_curso._id", "$cursos"]
            }
        }
    }},

    // 6. Proyectar los campos solicitados
    { $project: {
        _id: 0,
        curso: "$detalle_curso.nombre",
        carrera: "$datos_carrera.nombre",
        semestre: "$datos_carrera.cursos.semestre"
    }},

    // 7. Ordenar por semestre
    { $sort: { semestre: 1 } }
])
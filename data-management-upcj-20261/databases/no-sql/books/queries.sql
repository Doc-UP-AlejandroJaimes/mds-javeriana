// ─────────────────────────────────────────────────────────────
// CONSULTAS books-javeriana - De menor a mayor complejidad
// ─────────────────────────────────────────────────────────────

use("books-javeriana")

// ── 1. Ver todos los libros (consulta básica) ──────────────────
db.libros.find()

// ── 2. Ver solo nombre y páginas de los libros (proyección) ───
db.libros.find(
    {},
    { nombre: 1, paginas: 1, _id: 0 }
)

// ── 3. Libros con más de 300 páginas (filtro simple) ──────────
db.libros.find(
    { paginas: { $gt: 300 } },
    { nombre: 1, paginas: 1, _id: 0 }
)

// ── 4. Libros publicados después del año 2000 (filtro por fecha)
db.libros.find(
    { fecha_publicacion: { $gt: new Date("2000-01-01") } },
    { nombre: 1, fecha_publicacion: 1, _id: 0 }
)

// ── 5. Libros ordenados por páginas de mayor a menor ──────────
db.libros.find(
    {},
    { nombre: 1, paginas: 1, _id: 0 }
).sort({ paginas: -1 })

// ── 6. Contar cuántos libros tiene cada editor (agregación básica)
db.libros.aggregate([
    { $lookup: {
        from: "editores",
        localField: "editor",
        foreignField: "_id",
        as: "datos_editor"
    }},
    { $unwind: "$datos_editor" },
    { $group: {
        _id: "$datos_editor.nombre",
        total_libros: { $sum: 1 }
    }},
    { $sort: { total_libros: -1 } }
])

// ── 7. Promedio, máximo y mínimo de páginas por editor ────────
db.libros.aggregate([
    { $lookup: {
        from: "editores",
        localField: "editor",
        foreignField: "_id",
        as: "datos_editor"
    }},
    { $unwind: "$datos_editor" },
    { $group: {
        _id: "$datos_editor.nombre",
        promedio_paginas: { $avg: "$paginas" },
        max_paginas:      { $max: "$paginas" },
        min_paginas:      { $min: "$paginas" }
    }},
    { $sort: { promedio_paginas: -1 } }
])

// ── 8. Libros con sus autores completos (lookup a autores) ────
db.libros.aggregate([
    { $lookup: {
        from: "autores",
        localField: "autores._id",
        foreignField: "_id",
        as: "datos_autores"
    }},
    { $project: {
        nombre: 1,
        paginas: 1,
        fecha_publicacion: 1,
        "datos_autores.nombre": 1,
        _id: 0
    }}
])

// ── 9. Librerías con el stock total de cada libro ─────────────
db.librerias.aggregate([
    { $unwind: "$libros" },
    { $group: {
        _id: "$libros.libro",
        stock_total:     { $sum: "$libros.stock" },
        en_librerias: { $sum: 1 }
    }},
    { $sort: { stock_total: -1 } }
])

// ── 10. Informe completo: libros con editor, autores y stock total
db.libros.aggregate([
    // Unir con editores
    { $lookup: {
        from: "editores",
        localField: "editor",
        foreignField: "_id",
        as: "datos_editor"
    }},
    { $unwind: "$datos_editor" },
    // Unir con autores
    { $lookup: {
        from: "autores",
        localField: "autores._id",
        foreignField: "_id",
        as: "datos_autores"
    }},
    // Unir con librerias para obtener stock
    { $lookup: {
        from: "librerias",
        let: { nombre_libro: "$nombre" },
        pipeline: [
            { $unwind: "$libros" },
            { $match: {
                $expr: { $eq: ["$libros.libro", "$$nombre_libro"] }
            }},
            { $group: {
                _id: null,
                stock_total: { $sum: "$libros.stock" }
            }}
        ],
        as: "stock_info"
    }},
    // Limpiar y proyectar resultado final
    { $project: {
        _id: 0,
        nombre: 1,
        paginas: 1,
        fecha_publicacion: 1,
        editor: "$datos_editor.nombre",
        autores: "$datos_autores.nombre",
        stock_total: { $ifNull: [
            { $arrayElemAt: ["$stock_info.stock_total", 0] }, 0
        ]}
    }},
    { $sort: { stock_total: -1 } }
])
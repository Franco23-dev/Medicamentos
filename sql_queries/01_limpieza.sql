use medicamentos_pami;
/* Creaccion de la tabla para ingresar los datos luego */
CREATE TABLE medicamentos (
	alfabeta INT PRIMARY KEY,
    principal_activo VARCHAR(250),
    marca_comercial VARCHAR(250),
    presentacion VARCHAR(250),
	laboratorio VARCHAR(250),
    pvp_pami DECIMAL(15, 2),
    cobertura_porcentaje INT,
    aporte_afiliado DECIMAL(15,2)
);


/* Consulta a la tabla para ver si tiene datos */
SELECT * FROM medicamentos;

/* REPORTE DE ALERTA DE PRECIOS */
SELECT 
    laboratorio, 
    marca_comercial, 
    pvp_pami 
FROM medicamentos 
WHERE pvp_pami > (SELECT AVG(pvp_pami) FROM medicamentos)
ORDER BY pvp_pami DESC;


/* 
¿Cuántos medicamentos totales tenemos en la tabla?
¿Cuántos laboratorios distintos hay?
¿Cuál es el precio (PVP_PAMI) máximo, el mínimo y el promedio de toda la farmacia?
*/
SELECT 
	COUNT(*) as total_registro,
	COUNT(DISTINCT(laboratorio)) as total_laboratorio,
    MAX(pvp_pami) as precio_maximo,
    MIN(pvp_pami) as precio_minimo,
    TRUNCATE(AVG(pvp_pami),2) as precio_promedio
FROM medicamentos;


/* Mostrar los 10 laboratorios que tienen la suma de precios más alta */
SELECT laboratorio, SUM(pvp_pami) as total_recaudacion
FROM medicamentos
GROUP BY laboratorio
ORDER BY total_recaudacion DESC
LIMIT 10;


/* Medicamentos cuyo principio_activo contenga la palabra 'enalapril' O 'losartán', 
pero que además tengan una cobertura mayor al 50%. */
SELECT principal_activo, marca_comercial, presentacion, pvp_pami, cobertura_porcentaje
FROM medicamentos
WHERE principal_activo LIKE '%enalapril%' 
	OR principal_activo LIKE '%losartán%' 
    AND cobertura_porcentaje > 0.5;


/* 
Reporte que muestra: marca_comercial, pvp_pami, importe_afiliado y una columna calculada llamada 'ahorro_pesos' 
Solo queremos ver los productos donde el ahorro sea mayor a $20.000.
*/
SELECT marca_comercial, pvp_pami, aporte_afiliado, (pvp_pami - aporte_afiliado) as ahorro_pesos
FROM medicamentos
HAVING ahorro_pesos > 20000
ORDER BY ahorro_pesos ASC;





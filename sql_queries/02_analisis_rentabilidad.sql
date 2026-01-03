/* Creamos una tabla de rentabilidad para trabjar con JOINS */
CREATE TABLE rentabilidad_laboratorios(
	laboratorio VARCHAR(250),
    bono_de_retorno DECIMAL(15,2)
);

/* Le colocamos los valores */
INSERT INTO rentabilidad_laboratorios (laboratorio, bono_de_retorno) VALUES ('Elea', 0.5);
INSERT INTO rentabilidad_laboratorios (laboratorio, bono_de_retorno) VALUES ('Casasco', 0.3);
INSERT INTO rentabilidad_laboratorios (laboratorio, bono_de_retorno) VALUES ('Baliarda', 0.4);
INSERT INTO rentabilidad_laboratorios (laboratorio, bono_de_retorno) VALUES ('Abbott', 0.2);

/* verificamos */
SELECT * FROM rentabilidad_laboratorios;


/* Necesitamos saber cuánto ganaría la farmacia por cada producto vendido, basado en el bono de cada laboratorio. */
SELECT m.marca_comercial, m.laboratorio, IFNULL(ROUND((m.pvp_pami * r.bono_de_retorno), 2), 0) as ganancia_farmacia
FROM medicamentos as m
LEFT JOIN rentabilidad_laboratorios as r
	ON m.laboratorio = r.laboratorio
ORDER BY ganancia_farmacia DESC;

/* Creacion de una vista */
CREATE VIEW v_reporte_rentabilidad AS
SELECT m.marca_comercial, m.laboratorio, IFNULL(ROUND((m.pvp_pami * r.bono_de_retorno), 2), 0) as ganancia_farmacia
FROM medicamentos as m
LEFT JOIN rentabilidad_laboratorios as r
	ON m.laboratorio = r.laboratorio
ORDER BY ganancia_farmacia DESC;

SELECT * FROM v_reporte_rentabilidad;

CREATE OR REPLACE VIEW v_analisis_comercial_detallado AS
SELECT
	m.marca_comercial,
    m.laboratorio,
    m.presentacion,
    m.pvp_pami,
    /* Si es bono es NULL porque no esta en la tabla de rentabilidad_laboratorio sera 0 */
    IFNULL(r.bono_de_retorno, 0) AS bono_pactado,
    /* Calculamos ganancia real */
    IFNULL(ROUND((m.pvp_pami * r.bono_de_retorno), 2), 0)AS ganancia_estimada_farmacia
FROM medicamentos AS m
LEFT JOIN rentabilidad_laboratorios AS r
ON m.laboratorio = r.laboratorio;

SELECT * FROM v_analisis_comercial_detallado;


/* ¿Cuál es el Top 5 de medicamentos que más ganancia nos dejan (en pesos)? */
SELECT * FROM v_analisis_comercial_detallado
ORDER BY ganancia_estimada_farmacia DESC
LIMIT 5;


/* ¿Hay algún medicamento que tenga un PVP PAMI alto pero una ganancia de 0? */
SELECT * FROM v_analisis_comercial_detallado
WHERE ganancia_estimada_farmacia = 0
ORDER BY pvp_pami DESC
LIMIT 1;
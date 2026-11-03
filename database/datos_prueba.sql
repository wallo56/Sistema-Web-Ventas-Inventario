-- ==============================================
-- SISTEMA WEB DE INVENTARIO
-- DATOS DE PRUEBA - POSTGRESQL
-- ==============================================

-- Roles utilizados por el backend
INSERT INTO public.rol (id_rol, nombre)
VALUES
    (1, 'ADMINISTRADOR'),
    (2, 'OPERADOR');

-- Productos de ejemplo
INSERT INTO public.productos
    (nombre, descripcion, precio, stock, estado)
VALUES
    ('Teclado USB', 'Teclado para computadora', 150.00, 20, 'A'),
    ('Mouse USB', 'Mouse optico', 80.00, 30, 'A'),
    ('Monitor LED', 'Monitor de 24 pulgadas', 1100.00, 10, 'A'),
    ('Memoria USB', 'Memoria de almacenamiento de 32 GB', 100.00, 25, 'A'),
    ('Disco SSD', 'Unidad de estado solido de 500 GB', 600.00, 15, 'A');

-- Ajustar la secuencia del rol tras insertar IDs manuales
SELECT pg_catalog.setval(
    pg_get_serial_sequence('public.rol', 'id_rol'),
    (SELECT MAX(id_rol) FROM public.rol),
    true
);

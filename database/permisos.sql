-- ==============================================
-- PERMISOS DE POSTGRESQL PARA EL VPS
-- Ejecutar como administrador de PostgreSQL
-- ==============================================

GRANT USAGE ON SCHEMA public TO app_inventario;

GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLE public.productos TO app_inventario;

GRANT SELECT
ON TABLE public.rol, public.usuario
TO app_inventario;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public
TO app_inventario;

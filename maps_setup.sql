-- Agregar campos de ubicación a la tabla trips
ALTER TABLE public.trips ADD COLUMN meeting_lat DOUBLE PRECISION;
ALTER TABLE public.trips ADD COLUMN meeting_lng DOUBLE PRECISION;
ALTER TABLE public.trips ADD COLUMN destination_lat DOUBLE PRECISION;
ALTER TABLE public.trips ADD COLUMN destination_lng DOUBLE PRECISION;
ALTER TABLE public.trips ADD COLUMN meeting_address TEXT;
ALTER TABLE public.trips ADD COLUMN destination_address TEXT;
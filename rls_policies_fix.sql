-- Script para arreglar las políticas RLS que causan recursión infinita
-- Ejecutar SOLO las políticas, no las tablas (ya existen)

-- Primero eliminar TODAS las políticas problemáticas
DROP POLICY IF EXISTS "Users can view participants of trips they can see" ON public.trip_participants;
DROP POLICY IF EXISTS "Users can view participants of public trips" ON public.trip_participants;
DROP POLICY IF EXISTS "Users can view participants of their own trips" ON public.trip_participants;
DROP POLICY IF EXISTS "Users can view their own participations" ON public.trip_participants;
DROP POLICY IF EXISTS "Users can join trips" ON public.trip_participants;
DROP POLICY IF EXISTS "Users can leave trips (except organizers)" ON public.trip_participants;

-- También eliminar políticas de trips que puedan causar problemas
DROP POLICY IF EXISTS "Anyone can view public trips" ON public.trips;
DROP POLICY IF EXISTS "Users can view trips they participate in" ON public.trips;
DROP POLICY IF EXISTS "Authenticated users can create trips" ON public.trips;
DROP POLICY IF EXISTS "Organizers can update their trips" ON public.trips;
DROP POLICY IF EXISTS "Organizers can delete their trips" ON public.trips;

-- Crear políticas simples para trips
CREATE POLICY "Anyone can view public trips" ON public.trips
  FOR SELECT USING (is_public = true);

CREATE POLICY "Users can view their own trips" ON public.trips
  FOR SELECT USING (organizer_id = auth.uid());

CREATE POLICY "Authenticated users can create trips" ON public.trips
  FOR INSERT WITH CHECK (auth.uid() = organizer_id);

CREATE POLICY "Organizers can update their trips" ON public.trips
  FOR UPDATE USING (organizer_id = auth.uid());

CREATE POLICY "Organizers can delete their trips" ON public.trips
  FOR DELETE USING (organizer_id = auth.uid());

-- Crear políticas simples para trip_participants
CREATE POLICY "Users can view trip participants" ON public.trip_participants
  FOR SELECT USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM public.trips
      WHERE id = trip_id AND (is_public = true OR organizer_id = auth.uid())
    )
  );

CREATE POLICY "Users can join trips" ON public.trip_participants
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can leave trips" ON public.trip_participants
  FOR DELETE USING (auth.uid() = user_id);
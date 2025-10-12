-- Script para arreglar las políticas RLS que causan recursión infinita
-- Ejecutar SOLO las políticas, no las tablas (ya existen)

-- Primero eliminar las políticas problemáticas
DROP POLICY IF EXISTS "Users can view participants of trips they can see" ON public.trip_participants;

-- Crear nuevas políticas separadas para evitar recursión
CREATE POLICY "Users can view participants of public trips" ON public.trip_participants
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.trips
      WHERE id = trip_id AND is_public = true
    )
  );

CREATE POLICY "Users can view participants of their own trips" ON public.trip_participants
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.trips
      WHERE id = trip_id AND organizer_id = auth.uid()
    )
  );

CREATE POLICY "Users can view their own participations" ON public.trip_participants
  FOR SELECT USING (user_id = auth.uid());

-- Las demás políticas ya deberían estar bien, pero por si acaso:
DROP POLICY IF EXISTS "Users can join trips" ON public.trip_participants;
CREATE POLICY "Users can join trips" ON public.trip_participants
  FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can leave trips (except organizers)" ON public.trip_participants;
CREATE POLICY "Users can leave trips (except organizers)" ON public.trip_participants
  FOR DELETE USING (auth.uid() = user_id AND role = 'participant');
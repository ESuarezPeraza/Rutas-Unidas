-- Crear tabla de usuarios (extiende auth.users)
CREATE TABLE public.users (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'user',
  experience INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Crear tabla de viajes
CREATE TABLE public.trips (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  start_date TIMESTAMP WITH TIME ZONE,
  end_date TIMESTAMP WITH TIME ZONE,
  organizer_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  status TEXT DEFAULT 'planned' CHECK (status IN ('planned', 'in_progress', 'completed', 'cancelled')),
  is_public BOOLEAN DEFAULT true,
  max_participants INTEGER DEFAULT 10,
  tags TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Crear tabla de participantes de viajes
CREATE TABLE public.trip_participants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID REFERENCES public.trips(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  role TEXT DEFAULT 'participant' CHECK (role IN ('organizer', 'participant')),
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  UNIQUE(trip_id, user_id)
);

-- Políticas de seguridad (RLS - Row Level Security)

-- Habilitar RLS en todas las tablas
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trip_participants ENABLE ROW LEVEL SECURITY;

-- Políticas para users
CREATE POLICY "Users can view their own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Políticas para trips
CREATE POLICY "Anyone can view public trips" ON public.trips
  FOR SELECT USING (is_public = true);

CREATE POLICY "Users can view trips they participate in" ON public.trips
  FOR SELECT USING (
    organizer_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM public.trip_participants
      WHERE trip_id = trips.id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Authenticated users can create trips" ON public.trips
  FOR INSERT WITH CHECK (auth.uid() = organizer_id);

CREATE POLICY "Organizers can update their trips" ON public.trips
  FOR UPDATE USING (organizer_id = auth.uid());

CREATE POLICY "Organizers can delete their trips" ON public.trips
  FOR DELETE USING (organizer_id = auth.uid());

-- Políticas para trip_participants
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

CREATE POLICY "Users can join trips" ON public.trip_participants
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can leave trips (except organizers)" ON public.trip_participants
  FOR DELETE USING (auth.uid() = user_id AND role = 'participant');

-- Función para crear perfil automáticamente al registrarse
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para crear perfil automáticamente
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = TIMEZONE('utc'::text, NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER handle_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER handle_trips_updated_at
  BEFORE UPDATE ON public.trips
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Función para incrementar experiencia de usuario
CREATE OR REPLACE FUNCTION increment_user_experience(user_id UUID, points INTEGER)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE public.users
  SET experience = experience + points,
      updated_at = TIMEZONE('utc'::text, NOW())
  WHERE id = user_id;
END;
$$;

-- Índices para mejor rendimiento
CREATE INDEX idx_trips_organizer_id ON public.trips(organizer_id);
CREATE INDEX idx_trips_is_public ON public.trips(is_public);
CREATE INDEX idx_trips_created_at ON public.trips(created_at DESC);
CREATE INDEX idx_trip_participants_trip_id ON public.trip_participants(trip_id);
CREATE INDEX idx_trip_participants_user_id ON public.trip_participants(user_id);
CREATE INDEX idx_users_email ON public.users(email);
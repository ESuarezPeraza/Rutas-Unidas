# 🚀 Guía de Configuración - Rutas Unidas

## 📋 Requisitos Previos

- Flutter SDK (versión 3.9.0 o superior)
- Dart SDK
- Cuenta en [Supabase](https://supabase.com)

## 🛠️ Configuración Inicial

### 1. Clonar el repositorio
```bash
git clone <tu-repositorio>
cd rutas-unidas
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar Supabase

#### a) Crear proyecto en Supabase
1. Ve a [supabase.com](https://supabase.com) y crea una cuenta
2. Crea un nuevo proyecto
3. Espera a que se configure completamente

#### b) Obtener credenciales
1. Ve a **Settings > API** en tu proyecto de Supabase
2. Copia el **Project URL** y **anon/public key**

#### c) Configurar la aplicación
1. Copia el archivo template:
```bash
cp lib/config/supabase_config_template.dart lib/config/supabase_config.dart
```

2. Edita `lib/config/supabase_config.dart` y reemplaza:
```dart
static const String supabaseUrl = 'TU_SUPABASE_URL_AQUI';
static const String supabaseAnonKey = 'TU_SUPABASE_ANON_KEY_AQUI';
```

#### d) Crear la base de datos
1. Ve a **SQL Editor** en Supabase
2. Copia y pega todo el contenido de `database_schema.sql`
3. Ejecuta el script

### 4. Ejecutar la aplicación
```bash
flutter run
```

## 🔐 Variables de Entorno (Opcional)

Para mayor seguridad, puedes usar variables de entorno:

1. Crea un archivo `.env` en la raíz del proyecto:
```
SUPABASE_URL=tu_url_aqui
SUPABASE_ANON_KEY=tu_key_aqui
```

2. Modifica `lib/config/supabase_config.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'YOUR_SUPABASE_URL';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'YOUR_SUPABASE_ANON_KEY';
  // ... resto del código
}
```

3. Agrega al `pubspec.yaml`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

## 🚀 Funcionalidades Implementadas

- ✅ **Autenticación completa** (registro/login/logout)
- ✅ **Sistema de experiencia** con niveles
- ✅ **Creación y unión a viajes**
- ✅ **Feed social** (Explorar)
- ✅ **Perfiles con estadísticas**
- ✅ **Manejo de errores robusto**

## 📱 Uso de la Aplicación

1. **Registro/Login**: Crea una cuenta o inicia sesión
2. **Explorar**: Ve viajes creados por otros usuarios
3. **Crear Viaje**: Publica tus propias aventuras
4. **Unirse**: Participa en viajes de la comunidad
5. **Perfil**: Ve tu progreso y estadísticas

## 🔒 Seguridad

- **Nunca commits las credenciales reales**
- El archivo `lib/config/supabase_config.dart` está en `.gitignore`
- Usa el template para compartir código sin datos sensibles

## 🐛 Solución de Problemas

### Error de conexión a Supabase
- Verifica que las credenciales sean correctas
- Asegúrate de que el proyecto de Supabase esté activo

### Error al crear tablas
- Ejecuta el script SQL en el orden correcto
- Verifica que tengas permisos de administrador en Supabase

### Problemas de autenticación
- Confirma que RLS esté habilitado
- Revisa las políticas de seguridad en Supabase

## 📞 Soporte

Si tienes problemas, verifica:
1. Las credenciales de Supabase
2. La ejecución del script SQL
3. La conexión a internet
4. Los permisos del proyecto

¡Disfruta tu aplicación Rutas Unidas! 🏍️
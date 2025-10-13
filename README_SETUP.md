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

### 3. Configurar Google Maps API

#### a) Obtener API Key de Google Maps
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la **Maps SDK for Android** y **Maps SDK for iOS**
4. Ve a **Credenciales** y crea una **API Key**
5. Restringe la API Key para mayor seguridad:
   - **Aplicaciones**: Android apps (con tu package name: `com.example.myapp`)
   - **APIs**: Maps SDK for Android, Maps SDK for iOS

#### b) Configurar para Android
1. Copia el archivo template:
```bash
cp android/local.properties.example android/local.properties
```

2. Edita `android/local.properties` y configura tu API key:
```
GOOGLE_MAPS_API_KEY=tu_api_key_de_google_maps_aqui
```

#### c) Configurar para desarrollo Flutter
Para desarrollo local, puedes usar variables de entorno:
```bash
flutter run --dart-define=GOOGLE_MAPS_API_KEY=tu_api_key_aqui
```

### 4. Configurar Supabase

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

### API Keys y Credenciales
- **Nunca commits las credenciales reales al repositorio**
- Los archivos `android/local.properties` y `.env` están en `.gitignore`
- Usa los archivos `.example` como templates para compartir código sin datos sensibles
- **Google Maps API Key**: Restringe el uso por aplicaciones y APIs específicas
- **Supabase Keys**: Mantén las keys de producción separadas del código

### Configuración Segura
- Para desarrollo: usa `flutter run --dart-define=GOOGLE_MAPS_API_KEY=tu_key`
- Para producción: configura variables de entorno en tu CI/CD
- Android: `android/local.properties` contiene keys sensibles (no commitear)
- Flutter: usa `--dart-define` o variables de entorno para runtime

## 🐛 Solución de Problemas

### Error de Google Maps API
- Verifica que la API key esté correctamente configurada en `android/local.properties`
- Confirma que la API esté habilitada en Google Cloud Console
- Revisa las restricciones de la API key (package name correcto)
- Para desarrollo: usa `flutter run --dart-define=GOOGLE_MAPS_API_KEY=tu_key`

### Error de conexión a Supabase
- Verifica que las credenciales sean correctas
- Asegúrate de que el proyecto de Supabase esté activo

### Error al crear tablas
- Ejecuta el script SQL en el orden correcto
- Verifica que tengas permisos de administrador en Supabase

### Problemas de autenticación
- Confirma que RLS esté habilitado
- Revisa las políticas de seguridad en Supabase

### Error: GOOGLE_MAPS_API_KEY no está configurada
- Copia `android/local.properties.example` a `android/local.properties`
- Configura tu API key real en el nuevo archivo
- Asegúrate de que `android/local.properties` no esté en git (está en .gitignore)

## 📞 Soporte

Si tienes problemas, verifica:
1. Las credenciales de Supabase
2. La ejecución del script SQL
3. La conexión a internet
4. Los permisos del proyecto

¡Disfruta tu aplicación Rutas Unidas! 🏍️
import 'dart:io';
import 'package:logging/logging.dart';
import '../config/supabase_config.dart';

class StorageService {
  static const String tripsBucket = 'trip-images';
  static final Logger _logger = Logger('StorageService');

  /// Inicializa el bucket de almacenamiento si no existe
  static Future<void> initializeStorage() async {
    try {
      _logger.info('Verificando storage...');

      // Verificar si el bucket existe
      final buckets = await SupabaseConfig.client.storage.listBuckets();
      _logger.info('Buckets existentes: ${buckets.map((b) => b.id).toList()}');

      final bucketExists = buckets.any((bucket) => bucket.id == tripsBucket);

      if (!bucketExists) {
        _logger.info('ADVERTENCIA: El bucket $tripsBucket no existe. Debe ser creado manualmente en Supabase.');
        _logger.info('Ve a https://supabase.com/dashboard/project/gymdpbgmowobgzznbfjm/storage y crea el bucket "trip-images"');
        _logger.info('IMPORTANTE: Configura las políticas RLS para permitir uploads públicos o autenticados según necesites.');
      } else {
        _logger.info('Bucket $tripsBucket encontrado correctamente');
      }
    } catch (e) {
      _logger.info('Error verificando storage: $e');
      // Continuar sin el bucket por ahora
    }
  }

  /// Sube una imagen al almacenamiento y retorna la URL pública
  static Future<String?> uploadTripImage(String imagePath, String tripId) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        _logger.info('Error: El archivo de imagen no existe en la ruta: $imagePath');
        throw Exception('El archivo de imagen no existe');
      }

      // Verificar tamaño del archivo
      final fileSize = await file.length();
      _logger.info('Tamaño del archivo: $fileSize bytes');

      if (fileSize > 5 * 1024 * 1024) { // 5MB
        _logger.info('Error: Archivo demasiado grande: $fileSize bytes');
        throw Exception('El archivo es demasiado grande (máximo 5MB)');
      }

      // Generar nombre único para el archivo
      final fileExtension = imagePath.split('.').last.toLowerCase();
      final fileName = '${tripId}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      _logger.info('Subiendo archivo: $fileName al bucket: $tripsBucket');

      // Subir archivo al bucket
      final uploadResponse = await SupabaseConfig.client.storage
          .from(tripsBucket)
          .upload(fileName, file);

      _logger.info('Respuesta de subida: $uploadResponse');

      // Obtener URL pública
      final publicUrl = SupabaseConfig.client.storage
          .from(tripsBucket)
          .getPublicUrl(fileName);

      _logger.info('URL pública generada: $publicUrl');

      return publicUrl;
    } catch (e) {
      _logger.info('Error detallado al subir imagen: $e');
      _logger.info('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Elimina una imagen del almacenamiento
  static Future<bool> deleteTripImage(String imageUrl) async {
    try {
      // Extraer el nombre del archivo de la URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final fileName = pathSegments.lastWhere((segment) => segment.contains('.'));

      await SupabaseConfig.client.storage
          .from(tripsBucket)
          .remove([fileName]);

      return true;
    } catch (e) {
      _logger.info('Error deleting image: $e');
      return false;
    }
  }

  /// Actualiza la imagen de un viaje (elimina la anterior y sube la nueva)
  static Future<String?> updateTripImage(String newImagePath, String tripId, String? oldImageUrl) async {
    try {
      // Eliminar imagen anterior si existe
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await deleteTripImage(oldImageUrl);
      }

      // Subir nueva imagen
      return await uploadTripImage(newImagePath, tripId);
    } catch (e) {
      _logger.info('Error updating image: $e');
      return null;
    }
  }

  /// Sube una imagen desde web (Blob) al almacenamiento
  static Future<String?> uploadTripImageWeb(dynamic blob, String tripId, String fileName) async {
    // This method is only available on web platform
    return null;
  }

  /// Valida que una URL sea de nuestro almacenamiento
  static bool isValidStorageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.contains('supabase') && uri.path.contains(tripsBucket);
    } catch (e) {
      return false;
    }
  }
}
import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

// Conditional import for web platform
import 'package:flutter/foundation.dart' show kIsWeb;

class StorageService {
  static const String tripsBucket = 'trip-images';

  /// Inicializa el bucket de almacenamiento si no existe
  static Future<void> initializeStorage() async {
    try {
      print('Verificando storage...');

      // Verificar si el bucket existe
      final buckets = await SupabaseConfig.client.storage.listBuckets();
      print('Buckets existentes: ${buckets.map((b) => b.id).toList()}');

      final bucketExists = buckets.any((bucket) => bucket.id == tripsBucket);

      if (!bucketExists) {
        print('ADVERTENCIA: El bucket $tripsBucket no existe. Debe ser creado manualmente en Supabase.');
        print('Ve a https://supabase.com/dashboard/project/[tu-proyecto]/storage y crea el bucket "trip-images"');
      } else {
        print('Bucket $tripsBucket encontrado correctamente');
      }
    } catch (e) {
      print('Error verificando storage: $e');
      // Continuar sin el bucket por ahora
    }
  }

  /// Sube una imagen al almacenamiento y retorna la URL pública
  static Future<String?> uploadTripImage(String imagePath, String tripId) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        print('Error: El archivo de imagen no existe en la ruta: $imagePath');
        throw Exception('El archivo de imagen no existe');
      }

      // Verificar tamaño del archivo
      final fileSize = await file.length();
      print('Tamaño del archivo: $fileSize bytes');

      if (fileSize > 5 * 1024 * 1024) { // 5MB
        print('Error: Archivo demasiado grande: $fileSize bytes');
        throw Exception('El archivo es demasiado grande (máximo 5MB)');
      }

      // Generar nombre único para el archivo
      final fileExtension = imagePath.split('.').last.toLowerCase();
      final fileName = '${tripId}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      print('Subiendo archivo: $fileName al bucket: $tripsBucket');

      // Subir archivo al bucket
      final uploadResponse = await SupabaseConfig.client.storage
          .from(tripsBucket)
          .upload(fileName, file);

      print('Respuesta de subida: $uploadResponse');

      // Obtener URL pública
      final publicUrl = SupabaseConfig.client.storage
          .from(tripsBucket)
          .getPublicUrl(fileName);

      print('URL pública generada: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('Error detallado al subir imagen: $e');
      print('Stack trace: ${StackTrace.current}');
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
      print('Error deleting image: $e');
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
      print('Error updating image: $e');
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
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img_picker;
import 'dart:io';
import 'dart:html' as html;
import '../services/storage_service.dart';

class ImagePicker extends StatefulWidget {
  final String label;
  final IconData icon;
  final double aspectRatio;
  final String backgroundImageUrl;
  final Function(String)? onImageSelected;

  const ImagePicker({
    super.key,
    required this.label,
    required this.icon,
    this.aspectRatio = 16 / 9,
    required this.backgroundImageUrl,
    this.onImageSelected,
  });

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  final img_picker.ImagePicker _imagePicker = img_picker.ImagePicker();
  String? _selectedImagePath;
  String? _uploadedImageUrl;

  Future<void> _pickImage(img_picker.ImageSource source) async {
    try {
      final img_picker.XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImagePath = pickedFile.path;
        });

        // Para web, necesitamos convertir el XFile a bytes
        if (widget.onImageSelected != null) {
          // Mostrar indicador de carga
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Subiendo imagen...')),
            );
          }

          try {
            // Leer los bytes del archivo
            final bytes = await pickedFile.readAsBytes();

            // Generar ID temporal para la subida (se reemplazará con el ID real del viaje)
            final tempId = DateTime.now().millisecondsSinceEpoch.toString();
            print('Iniciando subida de imagen con ID temporal: $tempId');
            print('Tamaño del archivo: ${bytes.length} bytes');

            // Crear un archivo temporal para Supabase
            final tempFile = html.Blob([bytes]);
            final imageUrl = await StorageService.uploadTripImageWeb(tempFile, tempId, pickedFile.name);

            if (imageUrl != null) {
              setState(() {
                _uploadedImageUrl = imageUrl;
              });
              widget.onImageSelected!(imageUrl);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Imagen subida exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al subir la imagen'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } catch (e) {
            print('Error al procesar imagen web: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al procesar la imagen'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(img_picker.ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(img_picker.ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancelar'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: InkWell(
            onTap: _showImageSourceDialog,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: _uploadedImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(_uploadedImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : _selectedImagePath != null
                        ? DecorationImage(
                            image: FileImage(File(_selectedImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: NetworkImage(widget.backgroundImageUrl),
                            fit: BoxFit.cover,
                          ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _uploadedImageUrl != null ? 'Cambiar imagen' : _selectedImagePath != null ? 'Subiendo...' : 'Seleccionar imagen',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

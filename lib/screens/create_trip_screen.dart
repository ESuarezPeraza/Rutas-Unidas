import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/trips_provider.dart';
import 'package:myapp/widgets/custom_form_field.dart';
import 'package:myapp/widgets/image_picker.dart';
import 'package:myapp/widgets/location_picker.dart';
import 'package:myapp/theme/app_theme.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _routeController = TextEditingController();
  final _meetingPointController = TextEditingController();
  final _logisticsController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String? _imageUrl;
  bool _isPublic = true;
  bool _isLoading = false;

  // Nuevos campos de ubicación
  LocationData? _meetingLocation;
  LocationData? _destinationLocation;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _routeController.dispose();
    _meetingPointController.dispose();
    _logisticsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          // Si no hay fecha fin, la ponemos igual que la de inicio
          if (_selectedEndDate == null) {
            _selectedEndDate = picked;
          }
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  Future<void> _createTrip() async {
    print('=== INICIANDO CREACIÓN DE VIAJE ===');

    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      print('❌ Validación de formulario fallida');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifica que todos los campos sean correctos')),
      );
      return;
    }

    // Validar fecha de inicio
    if (_selectedStartDate == null) {
      print('❌ Fecha de inicio no seleccionada');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una fecha de inicio')),
      );
      return;
    }

    // Validar autenticación
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripsProvider = Provider.of<TripsProvider>(context, listen: false);

    if (authProvider.currentUser == null) {
      print('❌ Usuario no autenticado');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado')),
      );
      return;
    }

    print('✅ Validaciones pasadas');
    print('📝 Título: ${_titleController.text.trim()}');
    print('📅 Fecha inicio: $_selectedStartDate');
    print('📅 Fecha fin: $_selectedEndDate');
    print('🖼️ Imagen URL: $_imageUrl');
    print('👤 Organizador ID: ${authProvider.currentUser!.id}');
    print('🌐 Es público: $_isPublic');

    setState(() => _isLoading = true);

    final success = await tripsProvider.createTrip(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      imageUrl: _imageUrl,
      startDate: _selectedStartDate,
      endDate: _selectedEndDate,
      organizerId: authProvider.currentUser!.id,
      isPublic: _isPublic,
      meetingLat: _meetingLocation?.latitude,
      meetingLng: _meetingLocation?.longitude,
      destinationLat: _destinationLocation?.latitude,
      destinationLng: _destinationLocation?.longitude,
      meetingAddress: _meetingLocation?.address,
      destinationAddress: _destinationLocation?.address,
    );

    setState(() => _isLoading = false);

    if (success) {
      print('✅ Viaje creado exitosamente');
      // Actualizar la lista de viajes del usuario
      await tripsProvider.loadUserTrips(authProvider.currentUser!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Viaje creado exitosamente!')),
        );
        Navigator.of(context).pop(); // Volver a la pantalla anterior
      }
    } else {
      print('❌ Error al crear viaje: ${tripsProvider.error}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tripsProvider.error ?? 'Error al crear viaje')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Crear Viaje',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomFormField(
                  label: 'Nombre del Viaje *',
                  placeholder: 'Ej: Rodada a la Colonia Tovar',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre del viaje es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  label: 'Descripción',
                  placeholder: 'Describe la ruta, paradas y actividades planificadas.',
                  controller: _descriptionController,
                  multiline: true,
                  lines: 3,
                ),
                const SizedBox(height: 24),
                ImagePicker(
                  label: 'Añadir foto de portada',
                  icon: Icons.add_photo_alternate,
                  backgroundImageUrl: _imageUrl ?? 'https://via.placeholder.com/300x200',
                  onImageSelected: (imageUrl) {
                    setState(() => _imageUrl = imageUrl);
                  },
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  label: 'Ruta',
                  placeholder: 'Ej: Caracas - La Guaira',
                  controller: _routeController,
                ),
                const SizedBox(height: 24),
                // Selector de punto de encuentro
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Punto de Encuentro',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPicker(
                              title: 'Seleccionar Punto de Encuentro',
                              initialLocation: _meetingLocation != null
                                  ? LocationData(
                                      latitude: _meetingLocation!.latitude,
                                      longitude: _meetingLocation!.longitude,
                                      address: _meetingLocation!.address,
                                    )
                                  : null,
                              onLocationSelected: (location) {
                                setState(() => _meetingLocation = location);
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _meetingLocation?.address ?? 'Seleccionar ubicación en el mapa',
                                style: TextStyle(
                                  color: _meetingLocation != null
                                      ? Theme.of(context).textTheme.bodyLarge?.color
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const Icon(Icons.map, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Fecha de Inicio *',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _selectedStartDate != null
                                ? '${_selectedStartDate!.day.toString().padLeft(2, '0')}/${_selectedStartDate!.month.toString().padLeft(2, '0')}/${_selectedStartDate!.year}'
                                : 'Seleccionar fecha',
                            style: TextStyle(
                              color: _selectedStartDate != null
                                  ? Theme.of(context).textTheme.bodyLarge?.color
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Fecha de Fin',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _selectedEndDate != null
                                ? '${_selectedEndDate!.day.toString().padLeft(2, '0')}/${_selectedEndDate!.month.toString().padLeft(2, '0')}/${_selectedEndDate!.year}'
                                : 'Opcional',
                            style: TextStyle(
                              color: _selectedEndDate != null
                                  ? Theme.of(context).textTheme.bodyLarge?.color
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Selector de destino
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destino del Viaje',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPicker(
                              title: 'Seleccionar Destino del Viaje',
                              initialLocation: _destinationLocation != null
                                  ? LocationData(
                                      latitude: _destinationLocation!.latitude,
                                      longitude: _destinationLocation!.longitude,
                                      address: _destinationLocation!.address,
                                    )
                                  : null,
                              onLocationSelected: (location) {
                                setState(() => _destinationLocation = location);
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flag, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _destinationLocation?.address ?? 'Seleccionar destino en el mapa',
                                style: TextStyle(
                                  color: _destinationLocation != null
                                      ? Theme.of(context).textTheme.bodyLarge?.color
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const Icon(Icons.map, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                CustomFormField(
                  label: 'Detalles Logísticos',
                  placeholder: 'Nivel de dificultad, tipo de moto recomendada, etc.',
                  controller: _logisticsController,
                  multiline: true,
                  lines: 3,
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Viaje Público'),
                  subtitle: const Text('Los demás usuarios podrán ver y unirse a este viaje'),
                  value: _isPublic,
                  onChanged: (value) => setState(() => _isPublic = value),
                  activeColor: AppTheme.primaryBlue,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _createTrip,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Crear Viaje', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

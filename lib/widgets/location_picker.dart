import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../config/maps_config.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String address;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
    );
  }
}

class LocationPicker extends StatefulWidget {
  final String title;
  final LocationData? initialLocation;
  final Function(LocationData)? onLocationSelected;

  const LocationPicker({
    super.key,
    required this.title,
    this.initialLocation,
    this.onLocationSelected,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _selectedAddress = 'Selecciona una ubicación';
  bool _isLoading = true;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      // Si hay ubicación inicial, úsala
      if (widget.initialLocation != null) {
        _selectedLocation = LatLng(
          widget.initialLocation!.latitude,
          widget.initialLocation!.longitude,
        );
        _selectedAddress = widget.initialLocation!.address;
        _updateMarker();
        setState(() => _isLoading = false);
        return;
      }

      // Obtener ubicación actual
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        await _updateAddressFromCoordinates(_selectedLocation!);
        _updateMarker();
      } else {
        // Ubicación por defecto
        _selectedLocation = LatLng(MapsConfig.defaultLat, MapsConfig.defaultLng);
        _selectedAddress = MapsConfig.defaultCountry;
        _updateMarker();
      }
    } catch (e) {
      print('Error inicializando ubicación: $e');
      // Ubicación por defecto en caso de error
      _selectedLocation = const LatLng(10.5061, -66.9146);
      _selectedAddress = 'Caracas, Venezuela';
      _updateMarker();
    }

    setState(() => _isLoading = false);
  }

  void _updateMarker() {
    if (_selectedLocation != null) {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedLocation!,
          infoWindow: InfoWindow(title: _selectedAddress),
        ),
      };
    }
  }

  Future<void> _updateAddressFromCoordinates(LatLng position) async {
    final address = await LocationService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (address != null) {
      setState(() => _selectedAddress = address);
    }
  }

  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _selectedAddress = 'Obteniendo dirección...';
    });

    await _updateAddressFromCoordinates(position);
    _updateMarker();

    // Notificar al padre
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(
        LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          address: _selectedAddress,
        ),
      );
    }
  }

  Future<void> _goToCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null && _mapController != null) {
      final currentLatLng = LatLng(position.latitude, position.longitude);
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 15),
      );
      _onMapTap(currentLatLng);
    }
  }

  void _confirmLocation() {
    if (_selectedLocation != null && widget.onLocationSelected != null) {
      widget.onLocationSelected!(
        LocationData(
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
          address: _selectedAddress,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Información de la ubicación seleccionada
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedAddress,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                // Mapa
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation ?? LatLng(MapsConfig.defaultLat, MapsConfig.defaultLng),
                      zoom: 12,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    onTap: _onMapTap,
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                  ),
                ),

                // Botones de acción
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _goToCurrentLocation,
                          icon: const Icon(Icons.my_location),
                          label: const Text('Mi Ubicación'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
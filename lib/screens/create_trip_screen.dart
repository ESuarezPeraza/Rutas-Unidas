import 'package:flutter/material.dart';
import 'package:myapp/widgets/custom_form_field.dart';
import 'package:myapp/widgets/image_picker.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Más adelante, esto navegará de vuelta a la pantalla anterior
          },
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
            child: Column(
              children: [
                const CustomFormField(
                  label: 'Nombre del Viaje',
                  placeholder: 'Ej: Rodada a la Colonia Tovar',
                ),
                const SizedBox(height: 24),
                const CustomFormField(
                  label: 'Descripción',
                  placeholder: 'Describe la ruta, paradas y actividades planificadas.',
                  multiline: true,
                  lines: 3,
                ),
                const SizedBox(height: 24),
                const ImagePicker(
                  label: 'Añadir foto de portada',
                  icon: Icons.add_photo_alternate,
                  backgroundImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBDIurs6q_7IbwZ79vvzEC3X3UzJqWHb8kEsFsl-5a529Cikzi_AKrW32L7rRlN9t5MZoqIpKjyH7gxvxYzmywzQxkoJ0Gp5Uh8ZYQpIg3eJQ6Q9G2RKAbTjssm7G0BM2dupDyzzchvvc1qO2SDsutoYbsYGt0D_QcgI2lzTrODg1oLUu3vmQfnOSHCR_25D39sjS-WMm9NgUIzklKYcfsvZqS_K5lppDQMQLBVlTfZshz0BkJHqAFR7tG0NfCmaDcjVuiCjBzIZheA',
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(
                      child: CustomFormField(
                        label: 'Ruta',
                        placeholder: 'Caracas - La Guaira',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomFormField(
                        label: 'Punto de Encuentro',
                        placeholder: 'Plaza Altamira',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(
                      child: CustomFormField(
                        label: 'Fecha',
                        placeholder: 'DD/MM/AAAA',
                        inputType: TextInputType.datetime,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomFormField(
                        label: 'Hora',
                        placeholder: 'HH:MM',
                        inputType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const CustomFormField(
                  label: 'Detalles Logísticos Adicionales',
                  placeholder: 'Nivel de dificultad, tipo de moto recomendada, etc.',
                  multiline: true,
                  lines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Crear Viaje', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

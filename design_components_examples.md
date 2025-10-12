# Ejemplos de Componentes Rediseñados - Estilo Apple

## 🎨 Componente: TripCard Mejorado

### Código Actual vs Propuesto

#### Estado Actual (Material Design básico):
```dart
Card(
  margin: EdgeInsets.only(bottom: 16),
  child: ListTile(
    leading: Image.network(
      item['imageUrl'],
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    ),
    title: Text(item['title']),
    subtitle: Text(item['subtitle']),
    trailing: Chip(
      label: Text(item['tag']['label']),
    ),
  ),
)
```

#### Propuesta Nueva (Estilo Apple):
```dart
Container(
  margin: EdgeInsets.only(bottom: 16),
  decoration: BoxDecoration(
    color: isDarkMode ? Color(0xFF1C1C1E) : Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 20,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => navigateToDetail(),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen con bordes redondeados
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            // Información del viaje
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.41,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ),
            // Badge mejorado
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isPrimary 
                  ? Color(0xFF007AFF).withOpacity(0.15)
                  : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tagLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isPrimary 
                    ? Color(0xFF007AFF)
                    : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

## 📱 Layout Completo de "Mis Viajes"

### Estructura Visual:

```
┌─────────────────────────────────────┐
│                                     │
│         Mis Viajes                  │ <- LargeTitle (34pt, bold)
│                                     │
├─────────────────────────────────────┤
│                                     │
│  Viajes Programados                 │ <- Title2 (22pt, semibold)
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ┌─────┐                     │   │
│  │ │     │  Ruta de los Andes  │   │ <- Card con sombra sutil
│  │ │ IMG │  15 de Julio, 2024  │   │
│  │ │     │            [Badge]  │   │
│  │ └─────┘                     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ┌─────┐                     │   │
│  │ │     │  Carretera del Sur  │   │
│  │ │ IMG │  22 de Julio, 2024  │   │
│  │ │     │            [Badge]  │   │
│  │ └─────┘                     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────────  │ <- Divider sutil
│                                     │
│  Viajes Realizados                  │ <- Con opacidad 0.6
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Contenido similar...         │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

## 🎯 Especificaciones de Diseño

### Espaciado (Sistema 8pt)
- Padding horizontal pantalla: 20px
- Espacio entre secciones: 32px
- Espacio entre cards: 16px
- Padding interno card: 12px
- Espacio entre elementos en card: 16px

### Colores por Tema

#### Modo Claro
```dart
backgroundColor: Color(0xFFF2F2F7)     // Gris muy claro
cardBackground: Colors.white           // Blanco puro
primaryText: Colors.black              // Negro
secondaryText: Color(0xFF8E8E93)      // Gris
divider: Color(0xFFE5E5EA)            // Gris claro
```

#### Modo Oscuro
```dart
backgroundColor: Color(0xFF000000)     // Negro puro
cardBackground: Color(0xFF1C1C1E)     // Gris muy oscuro
primaryText: Colors.white              // Blanco
secondaryText: Color(0xFF8E8E93)      // Gris
divider: Color(0xFF38383A)            // Gris oscuro
```

### Animaciones

```dart
// Animación de entrada de cards
AnimationController _controller;
Animation<double> _animation;

// En initState
_animation = CurvedAnimation(
  parent: _controller,
  curve: Curves.easeOutCubic,
);

// En el widget
SlideTransition(
  position: Tween<Offset>(
    begin: Offset(0, 0.1),
    end: Offset.zero,
  ).animate(_animation),
  child: FadeTransition(
    opacity: _animation,
    child: TripCard(...),
  ),
)

// Animación de tap
Transform.scale(
  scale: _isPressed ? 0.95 : 1.0,
  child: AnimatedContainer(
    duration: Duration(milliseconds: 150),
    // ... resto del card
  ),
)
```

## 🔄 Transiciones entre Pantallas

### Hero Animation para imágenes
```dart
// En la lista
Hero(
  tag: 'trip-image-${trip.id}',
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(trip.imageUrl),
  ),
)

// En el detalle
Hero(
  tag: 'trip-image-${trip.id}',
  child: Container(
    height: 300,
    child: Image.network(trip.imageUrl),
  ),
)
```

## 📐 Grid System para Tablets

```dart
// Responsive grid para iPads
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // iPad layout
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) => TripCard(...),
      );
    } else {
      // iPhone layout
      return ListView.builder(
        itemBuilder: (context, index) => TripCard(...),
      );
    }
  },
)
```

## 🎨 Efectos Visuales Adicionales

### Blur Effect para Headers
```dart
ClipRect(
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      color: Colors.white.withOpacity(0.8),
      child: Text('Mis Viajes'),
    ),
  ),
)
```

### Shimmer Loading Effect
```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[100],
  child: Container(
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
  ),
)
```

## 🔧 Componentes Reutilizables

### AppleStyleCard
```dart
class AppleStyleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  
  const AppleStyleCard({
    Key? key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: padding ?? EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

### AppleStyleButton
```dart
class AppleStyleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  
  const AppleStyleButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: isPrimary ? Color(0xFF007AFF) : null,
      borderRadius: BorderRadius.circular(12),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: isPrimary ? Colors.white : Color(0xFF007AFF),
        ),
      ),
    );
  }
}
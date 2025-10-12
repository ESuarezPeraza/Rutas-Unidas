# Blueprint: Rutas Unidas

## Visión General

Rutas Unidas es una aplicación móvil diseñada para conectar a viajeros que desean compartir rutas y organizar viajes en grupo. La aplicación facilitará la búsqueda, creación y gestión de viajes, fomentando una comunidad de viajeros colaborativa.

## Diseño y Estilo

La aplicación sigue un diseño moderno y limpio, con una paleta de colores vibrantes y una tipografía clara y legible.

*   **Paleta de Colores:**
    *   Primario: Naranja (0xFFD45211)
    *   Fondo (Claro): Blanco Hueso (0xFFF8F6F6)
    *   Texto (Claro): Casi Negro (0xFF221610)
    *   Fondo (Oscuro): Negro-Marrón (0xFF221610)
    *   Texto (Oscuro): Blanco Hueso (0xFFF8F6F6)
    *   Secundario (Claro): Gris (rgba(34, 22, 16, 0.7))
    *   Secundario (Oscuro): Gris Claro (rgba(248, 246, 246, 0.7))
*   **Tipografía:**
    *   Fuente Principal: Space Grotesk (de Google Fonts)

## Estructura del Proyecto

El proyecto está estructurado de la siguiente manera:

*   `lib/main.dart`: El punto de entrada de la aplicación, contiene la configuración del tema y la navegación principal.
*   `lib/widgets/`: Carpeta que contiene todos los widgets reutilizables de la aplicación.
    *   `chip.dart`: Widget para las etiquetas de filtro.
    *   `header.dart`: Widget para la cabecera de las pantallas.
    *   `horizontal_chip_list.dart`: Widget que muestra la lista horizontal de etiquetas de filtro.
    *   `search_bar.dart`: Widget para la barra de búsqueda.
    *   `section_header.dart`: Widget para los títulos de las secciones.
    *   `trip_card.dart`: Widget para mostrar la información de un viaje.

## Funcionalidades Implementadas

### Versión 1 (Actual)

*   **Pantalla Principal ("Explorar Viajes")**
    *   **Navegación:** Barra de navegación inferior con cuatro pestañas: Explorar, Mis Viajes, Crear Viaje y Perfil.
    *   **Cabecera:** Título de la pantalla ("Explorar") y un botón de filtros (actualmente sin funcionalidad).
    *   **Búsqueda:** Barra de búsqueda para encontrar viajes.
    *   **Filtros:** Lista horizontal de etiquetas de filtro (Destino, Fecha, Tipo) (actualmente sin funcionalidad).
    *   **Lista de Viajes:** Sección de "Próximos Viajes" que muestra una lista de tarjetas con información de los viajes, incluyendo:
        *   Imagen del viaje.
        *   Título del viaje.
        *   Organizador del viaje.
        *   Fecha del viaje.

*   **Tema:**
    *   Tema claro y oscuro implementado con `provider`.
    *   Uso de `google_fonts` para la tipografía.

## Próximos Pasos

*   Implementar la funcionalidad de los botones de filtro y las etiquetas de filtro.
*   Crear las pantallas para "Mis Viajes", "Crear Viaje" y "Perfil".
*   Conectar la aplicación a un backend (Firebase) para gestionar los datos de los viajes y los usuarios.

🎨 Aprende a Dibujar - iOS App
Esta aplicación está diseñada para ayudar a principiantes a mejorar su técnica de dibujo mediante el calco. Utiliza una integración con IA para generar contornos minimalistas y fáciles de seguir.

📸 Retos Superados en el Desarrollo
Durante el desarrollo, nos enfrentamos a limitaciones técnicas que la app resuelve de forma inteligente:

1. Compatibilidad Regional y de Hardware
Muchos dispositivos o regiones (como la UE) no tienen acceso a Image Playground de Apple. La app soluciona esto utilizando una API externa, permitiendo que cualquier usuario pueda generar dibujos sin importar las restricciones de Apple Intelligence.

Captura del error de sistema que nuestra app evita al usar una solución de IA independiente.

2. Estabilidad de los Servidores
Las peticiones masivas a servidores de IA pueden causar errores internos o bloqueos por saturación. Nuestra app implementa un temporizador de seguridad de 4 segundos para evitar que el usuario reciba mensajes de error del servidor.

Ejemplo de error de saturación que el código actual gestiona mediante el bloqueo temporal del botón de generación.

✨ Características Principales
Generación de Contornos: Crea siluetas simples de objetos (casas, animales, flores) perfectas para principiantes.

Diccionario de Traducción: Mapeo interno Español -> Inglés para evitar que la IA confunda conceptos (como evitar que pinte un "hombre" cuando pides una "casa").

Slider de Opacidad: Control total para suavizar el dibujo, permitiendo ver el trazo del lápiz sobre el papel colocado en la pantalla.

Filtros de Alto Contraste: Procesa las imágenes para que las líneas sean siempre negras y el fondo blanco puro.

🛠️ Tecnologías
SwiftUI: Interfaz moderna y reactiva.

Pollinations AI: Generación de imágenes en la nube de forma gratuita y abierta.

PhotosUI: Soporte para importar imágenes propias de la galería si no hay conexión a internet.

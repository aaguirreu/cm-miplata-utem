# cm-miplata-utem
Proyecto de Computación Movil. Trackea tus transacciones y pagos para organizar tu plata.


# Instalación
- Descargar el proyecto.
- Una vez hecho esto, abrir android studio (o algún otro IDE a preferencia)y abrir el terminal en la raíz del proyecto.
- Usar "flutter clean" para borrar la build existente y borrar el caché (para evitar errores).
- Ahora, usar "flutter build apk", para descargar todas las dependencias y crear el apk del proyecto.
- Luego, usar "flutter run lib/main.dart" si es que el terminal se encuentra en la carpeta raíz (ejemplo: C:\RUTA AL PROYECTO\cm-miplata-utem).

# Funcionamiento
La aplicación posee:

- Login con correo de Google.
- Pantalla principal, con el balance total del usuario, total de dinero ingresado y egresado además de los 4 últimos movimientos.
- pantalla para añadir transacción ya sea cobro o pago, con el monto y la categoría si corresponde.
- pantalla para añadir categorias para transacciones de pago.
- pantalla para visualizar todas las transacciones hechas.
- pantalla para ver en gráfico el total de los gastos divididos para cada categoría.

Una vez el usuario se logea con Gmail, se ve la pantalla principal.
el usuario puede agregar el balance inicial, además de poder ver toda la información disponible de sus transacciones. Además, puede deslogearse si así lo desea.

Abajo aparecen los botones para agregar transacción, categoría y ver el gráfico.

En agregar transacción, se pide el título de la transacción, el monto, el tipo de transacción y la categoría (si corresponde).
Las transacciones añadidas se verán reflejadas en la pantalla principal.

Cuando haya más de 4 transacciones en el sistema, aparecerá un botón para poder ver el historial de todas las transacciones hechas.

En la pantalla de categorías el usuario puede añadir categorías para las transacciones de tipo "gasto", además de ver las categorías existentes y eliminarlas.

# En construcción
- Se creó una API de transacciones para los correos. está pendiente la conexión entre la API y el proyecto.
- Pendiente levantar proyecto a la nube e implementar la base de datos

# Créditos

Integrantes: 
- Guillermo Espinosa.
- Álvaro Aguirre.
- Samuel Tapia.

Profesor: Sebastián Salazar.

Ramo: Computación Móvil.
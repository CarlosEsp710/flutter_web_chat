# chat_app

Este proyecto es un chat hecho en flutter que se conecta a un servidor hecho en Node js, hace peticiones a una API y recibe notificaciones por medio de un socket.

Este proyecto solo ha sido probado en web.

La conexión está establecida en esta ruta <http://127.0.0.1:3000>, las URL de acceso se encuentran en "lib/app/global/environment.dart".

En caso de cambiarlas hay que volver a construir la aplicación web con el comando "flutter build web" y el contendio de la carpeta "build/web" debe reemplazar el contendio de la carpeta "public" de nuestro proyecto en Node.

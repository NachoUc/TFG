# TFG
## Descripción:
Se ha desarrollado una Infraestructura como Código (IaC) totalmente automatizada que actúa como un gemelo digital de un entorno de producción real. Esto permite desplegar, en minutos, un escenario idéntico para realizar pruebas de optimización de recursos, auditorías de seguridad y simulación de desastres sin riesgo para la operatividad de la empresa.

##Pasos para desplegar el servicio y hacer las correctas comprobaciones:
### Cómo activar o desactivar la versión de Taskfile para servidor en nube con redundancia o local:
<img width="462" height="312" alt="image" src="https://github.com/user-attachments/assets/27063aeb-ca0f-4a2c-ae7e-38c0c3738a62" />

Si el servidor ya tiene redundancia, dejaremos el comentario puesto; en caso contrario, quitamos el comentario. El RAID solo funcionará en el servidor de base de datos.

### Cómo cambiar las contraseñas y usuarios utilizados para los contenedores y servicios:
<img width="627" height="525" alt="image" src="https://github.com/user-attachments/assets/7b3609e9-1044-44b2-8777-494c7f1fc84d" />

Hay que cambiar SOLO el valor de la variable del principio del documento.

### Pasos para instalar correctamente los servicios necesarios para el Taskfile:
Es necesario ejecutar el script de setup.sh. Este ejecutable instalará todas las dependencias necesarias para que se ejecute correctamente el Taskfile.

### Cómo desplegar y destruir los contenedores:
- task build
- task destroy

### Recordatorio para utilizar el DNS:
- Previamente hay que tener configurada una VPN en el servidor para que el dispositivo esté en la misma red; se recomienda utilizar Tailscale.
- Para poder utilizar el servidor DNS configurado, hay que poner la IP del contenedor del servidor SMC en el adaptador de red.

### Enlaces para acceder a los servicios configurados:

Página Bootstrap Comporativa de SMC
- http://www.smc.local
- http://smc.smc.local
      
Página Nextcloud
- http://nextcloud.smc.local/nextcloud
- http://smc.smc.local/nextcloud

Directorio de script para crear usuarios y backup
- /usr/local/bin/

Grafana
- http://grafana.smc.local:3000

Prometheus
- http://prometheus.smc.local:9090

### Al final del Task mostrará un breve resumen de toda la configuración de los servicios, enlaces y codigos para el 2FA con SSH.

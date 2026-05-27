#!/bin/bash

# Salir inmediatamente si un comando falla
set -e

echo "======================================================="
echo "  Preparando entorno para Taskfile e Incus (Ubuntu)"
echo "======================================================="

# 1. Comprobación de privilegios
if [ "$EUID" -ne 0 ]; then
  echo "Error: Por favor, ejecuta este script como root o con sudo."
  exit 1
fi

# 2. Actualización e instalación de dependencias base
echo ">> Actualizando sistema e instalando dependencias básicas..."
apt-get update -y
apt-get install -y curl wget unzip acl nano jq apt-transport-https software-properties-common

# 3. Instalación de Task (go-task)
echo ">> Instalando 'Task' (go-task)..."
# Descarga e instala el binario directamente en /usr/local/bin
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# 4. Instalación de Incus (usando el repositorio oficial de Zabbly)
echo ">> Añadiendo repositorio e instalando Incus..."
curl -fsSL https://pkgs.zabbly.com/key.asc | tee /etc/apt/keyrings/zabbly.asc > /dev/null
cat <<EOF | tee /etc/apt/sources.list.d/zabbly-incus-stable.sources
Enabled: yes
Types: deb
URIs: https://pkgs.zabbly.com/incus/stable
Suites: $(. /etc/os-release && echo ${VERSION_CODENAME})
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/zabbly.asc
EOF

apt-get update -y
apt-get install -y incus

# 5. Inicialización de Incus (Preseed automatizado)
# Aquí creamos el pool "default" y la red "asirnetwork" que pide tu Taskfile
echo ">> Inicializando Incus y creando la red 'asirnetwork'..."
cat <<EOF | incus admin init --preseed
config: {}
networks:
- config:
    ipv4.address: auto
    ipv6.address: none
  description: "Red para instancias del Taskfile"
  name: asirnetwork
  type: bridge
  project: default
storage_pools:
- config:
    source: /var/lib/incus/storage-pools/default
  description: "Pool por defecto"
  name: default
  driver: dir
profiles:
- config: {}
  description: "Perfil por defecto"
  devices:
    eth0:
      name: eth0
      network: asirnetwork
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
EOF

# 6. Permisos del grupo Incus
echo ">> Configurando permisos de usuario..."
if [ -n "$SUDO_USER" ]; then
    usermod -aG incus-admin "$SUDO_USER"
    echo ">> [!] IMPORTANTE: El usuario '$SUDO_USER' ha sido añadido al grupo 'incus-admin'."
else
    echo ">> [!] Ejecutado como root. Si vas a usar un usuario normal (ej. ubuntu), ejecuta:"
    echo "       sudo usermod -aG incus-admin tu_usuario"
fi

echo "======================================================="
echo " ¡Instalación completada con éxito!"
echo " Para aplicar los grupos de permisos, CIERRA TU SESIÓN SSH"
echo " y vuelve a entrar. Luego, simplemente ejecuta:"
echo " "
echo "    task build"
echo " "
echo "======================================================="
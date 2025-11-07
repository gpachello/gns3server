# 🌐 GNS3 Server en Contenedor Docker (Debian Trixie Slim)

Este repositorio contiene los archivos necesarios para construir un **servidor GNS3 completo** y auto-contenido, utilizando una imagen base ligera de Debian (`debian:trixie-slim`) y **Docker Compose** para su despliegue.

## 🌟 Resumen del Proyecto

El objetivo principal es proporcionar un entorno de laboratorio de red **aislado y reproducible** que aloje el *backend* de GNS3. Esto permite ejecutar emuladores de red (routers, switches, PCs virtuales) sin interferir con el sistema operativo principal del host.

### Componentes Clave Instalados

La imagen incluye todos los emuladores necesarios, compilados directamente desde el código fuente para garantizar la máxima compatibilidad:

* **`gns3-server`**: El núcleo del servidor GNS3 (instalado vía Python `venv`).
* **`Dynamips`**: Emulador para *routers* Cisco basados en IOS (compilado con soporte `setcap`).
* **`VPCS`**: Simulador de PC virtual simple y ligero.
* **`uBridge`**: Herramienta crucial para la conectividad de red de bajo nivel entre los emuladores (compilado con soporte `setcap`).
* **`QEMU`**: Emulador para virtualización completa (soporte para KVM).

---

## 🚀 Despliegue Rápido con Docker Compose

El servicio se despliega en **modo privilegiado** (`--privileged`) para otorgar al servidor GNS3 los permisos de acceso a la red de bajo nivel (`uBridge`) y a la aceleración de hardware (`/dev/kvm`).

### Prerrequisitos

* **Docker**
* **Docker Compose**
* **GNS3 GUI** (instalada en la máquina *host* para interactuar con el servidor remoto).

### 1. Construir e Iniciar el Servidor

Asegúrate de que los archivos `Dockerfile` y `docker-compose.yml` estén en el mismo directorio.

```bash
# Construye la imagen y levanta el contenedor en segundo plano (-d)
docker compose up -d --build
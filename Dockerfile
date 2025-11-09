# Usa la imagen base debian:trixie-slim
FROM debian:trixie-slim

# Ejecutar como root (por defecto)
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# 1. Instalar Dependencias (GNS3 Server, Emuladores y Compilación)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3-venv \
        python3-pip \
        # Emuladores y virtualización
        qemu-kvm qemu-utils libvirt-clients libvirt-daemon-system virtinst \
        # Herramientas de compilación
        git build-essential libpcap-dev cmake libelf-dev libssl-dev \
        ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

# 2. Compilar e Instalar Emuladores (Dynamips, VPCS, uBridge)

# --- A. Dynamips (Requiere setcap) ---
RUN git clone https://github.com/GNS3/dynamips.git /usr/src/dynamips && \
    cd /usr/src/dynamips && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    setcap cap_net_admin,cap_net_raw=ep /usr/local/bin/dynamips && \
    cd / && rm -rf /usr/src/dynamips

# --- B. VPCS ---
RUN git clone https://github.com/GNS3/vpcs.git /usr/src/vpcs && \
    cd /usr/src/vpcs/src && \
    ./mk.sh && \
    cp vpcs /usr/local/bin/vpcs && \
    cd / && rm -rf /usr/src/vpcs

# --- C. uBridge (Requiere setcap) ---
RUN git clone https://github.com/GNS3/ubridge.git /usr/src/ubridge && \
    cd /usr/src/ubridge && \
    make && \
    make install && \
    setcap cap_net_admin,cap_net_raw=ep /usr/local/bin/ubridge && \
    cd / && rm -rf /usr/src/ubridge

# 3. Creación del Entorno Virtual e Instalación del Servidor
# Creamos el venv en /root/.venv
RUN python3 -m venv .venv

# Instalamos gns3-server en el venv
RUN /root/.venv/bin/pip install gns3-server

# 4. Configuración de Inicio
EXPOSE 3080
EXPOSE 5000-5350

# El ejecutable se invoca desde el entorno virtual de root
CMD ["/root/.venv/bin/gns3server", "--host", "0.0.0.0"]

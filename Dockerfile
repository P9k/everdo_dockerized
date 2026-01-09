# syntax=docker/dockerfile:1

FROM ubuntu:24.04

# Install dependencies for AppImage and VNC
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    x11vnc \
    xvfb \
    fluxbox \
    novnc \
    websockify \
    libglib2.0-0 \
    libgobject-2.0-0 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libpango-1.0-0 \
    libcairo2 \
    libatspi2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libxss1 \
    libnss3 \
    libnspr4 \
    libatk-bridge2.0-0 \
    libasound2t64 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Download and extract Everdo AppImage
RUN wget --no-verbose --timeout=30 --tries=3 \
    https://downloads.everdo.net/electron/Everdo-1.10.4.AppImage \
    -O /tmp/Everdo.AppImage \
    && chmod +x /tmp/Everdo.AppImage \
    && /tmp/Everdo.AppImage --appimage-extract \
    && mv squashfs-root /opt/Everdo \
    && rm -f /tmp/Everdo.AppImage

# Create startup script
RUN echo '#!/bin/bash' > /start.sh \
    && echo 'export DISPLAY=:1' >> /start.sh \
    && echo '# Clean up X11 lock files from previous sessions' >> /start.sh \
    && echo 'rm -f /tmp/.X1-lock /tmp/.X11-unix/X1' >> /start.sh \
    && echo 'RESOLUTION=${DISPLAY_WIDTH:-1920}x${DISPLAY_HEIGHT:-1080}' >> /start.sh \
    && echo 'Xvfb :1 -screen 0 ${RESOLUTION}x24 &' >> /start.sh \
    && echo 'sleep 2' >> /start.sh \
    && echo 'fluxbox &' >> /start.sh \
    && echo 'sleep 1' >> /start.sh \
    && echo 'x11vnc -display :1 -forever -passwd ${VNC_PASSWORD:-password} &' >> /start.sh \
    && echo '/usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 0.0.0.0:6080 &' >> /start.sh \
    && echo 'cd /opt/Everdo && ./everdo --no-sandbox &' >> /start.sh \
    && echo 'wait' >> /start.sh \
    && chmod +x /start.sh

# Expose ports
EXPOSE 5900 6080 11112

# Start the application
CMD ["/start.sh"]



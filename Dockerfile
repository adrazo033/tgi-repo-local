# Usa la imagen oficial TGI como base
FROM ghcr.io/huggingface/text-generation-inference:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV http_proxy=http://http.docker.internal:3128
ENV https_proxy=http://http.docker.internal:3128
ENV no_proxy=localhost,127.0.0.1,.internal

# Instala nginx y utilidades necesarias
USER root
RUN apt-get update && \
    apt-get install -y nginx ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copia la configuración de nginx y el entrypoint
RUN rm -f /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Asegúrate que sea ejecutable
RUN chmod +x /entrypoint.sh

# Exponer el puerto 80 para nginx (el backend TGI seguirá escuchando en 8080 dentro del contenedor)
EXPOSE 80

# Ejecutar el script de arranque. Los argumentos de TGI se pasan como CMD por defecto
ENTRYPOINT ["/entrypoint.sh"]

# CMD por defecto (ejemplo). Normalmente al hacer docker run le pasas --model-id, etc.
CMD ["--model-id", "gpt2"]



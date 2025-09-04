    #!/bin/sh
set -e

# Opcional: arreglar finales de línea si el script fue creado en Windows
if command -v dos2unix >/dev/null 2>&1; then
  dos2unix /etc/nginx/nginx.conf 2>/dev/null || true
fi

# Start nginx (daemoniza por defecto). Si prefieres foreground, usar `nginx -g 'daemon off;' &`
nginx

# Ahora ejecutamos el launcher de TGI con los argumentos que se pasen al contenedor.
# Usamos exec para que text-generation-launcher reemplace el PID del proceso y reciba señales correctamente.
exec text-generation-launcher "$@" --port 8080 --model-id gpt2


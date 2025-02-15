#!/bin/bash

# Verifica si se pasó un argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <archivo_sqlite>"
    exit 1
fi

DB_FILE="$1"

# Verifica si el archivo existe
if [ ! -f "$DB_FILE" ]; then
    echo "Error: El archivo '$DB_FILE' no existe."
    exit 1
fi

# Extrae y convierte los hashes
sqlite3 "$DB_FILE" "SELECT name, passwd, salt FROM user" | while IFS='|' read -r name passwd salt; do
    decoded_salt=$(echo "$salt" | xxd -p -r | base64)
    digest=$(echo "$passwd")
    echo "sha256:50000:$decoded_salt:$digest"
done

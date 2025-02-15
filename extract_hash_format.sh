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

# Extrae los datos de la base de datos y los convierte en el formato deseado
sqlite3 "$DB_FILE" "SELECT name, passwd, salt FROM user" | while read -r line; do
    salt="$(echo "$line" | awk -F'|' '{print $3}' | xxd -p -r | base64)"
    digest="$(echo "$line" | awk -F'|' '{print $2}' | xxd -p -r | base64)"
    username="$(echo "$line" | awk -F'|' '{print $1}')"
    echo "${username}:sha256:50000:${salt}:${digest}"
done

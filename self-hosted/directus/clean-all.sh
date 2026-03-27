#!/bin/bash

# --- CONFIGURACIÓN ---
URL="https://cms.ansango.com"
TOKEN=""
# ----------------------

echo "⚠️ INICIANDO LIMPIEZA NUCLEAR (Borrando TODO)..."

# 1. Borrar registros de la colección personalizada 'photos'
echo "🗑️ Vaciando colección 'photos'..."
# Obtenemos todos los IDs de la colección y los borramos en bloque (batch)
# Usamos un array de IDs para hacer un DELETE masivo si Directus lo permite, 
# o uno a uno para asegurar.
p_ids=$(curl -s -X GET "$URL/items/photos?limit=-1" -H "Authorization: Bearer $TOKEN" | jq -r '.data[].id // empty')

for id in $p_ids; do
    echo "  Eliminando item de BBDD: $id"
    curl -s -X DELETE "$URL/items/photos/$id" -H "Authorization: Bearer $TOKEN" > /dev/null
done

# 2. Borrar todos los ARCHIVOS (esto borra el archivo físico del disco también)
echo "🗑️ Eliminando archivos físicos de Directus..."
f_ids=$(curl -s -X GET "$URL/files?limit=-1" -H "Authorization: Bearer $TOKEN" | jq -r '.data[].id // empty')

for fid in $f_ids; do
    echo "  Eliminando archivo: $fid"
    curl -s -X DELETE "$URL/files/$fid" -H "Authorization: Bearer $TOKEN" > /dev/null
done

# 3. Borrar todas las CARPETAS
echo "🗑️ Eliminando estructura de carpetas..."
fold_ids=$(curl -s -X GET "$URL/folders?limit=-1" -H "Authorization: Bearer $TOKEN" | jq -r '.data[].id // empty')

for foldid in $fold_ids; do
    echo "  Eliminando carpeta: $foldid"
    curl -s -X DELETE "$URL/folders/$foldid" -H "Authorization: Bearer $TOKEN" > /dev/null
done

echo "✅ BASE DE DATOS LIMPIA. Todo el contenido ha sido eliminado."

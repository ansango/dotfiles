#!/bin/bash

# Script para subir fotos a Directus desde una carpeta local, con compresión previa a WebP.
# Tienes que tener instalado ImageMagick (convert) y jq para procesar JSON.
# Configura las variables al inicio del script antes de ejecutarlo.

# Recomendación: Ejecuta este script desde la terminal y monitorea la salida para detectar posibles errores.

# --- CONFIGURACIÓN ---
URL="https://cms.ansango.com"
TOKEN="Qi8Ufv6H2-V1NnQGXnbMq4CP6phHVlZL"
PATH_LOCAL="/media/ansango/Store/images/Negativos/Originales"
NOMBRE_PADRE="films"

# Parámetros de compresión
CALIDAD_WEBP=85
MAX_ANCHO=2500
# ----------------------

echo "--- 1. VERIFICANDO ESTRUCTURA DE DATOS (Colección 'photos') ---"
COL_CHECK=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$URL/collections/photos" \
    -H "Authorization: Bearer $TOKEN")

if [ "$COL_CHECK" != "200" ]; then
    echo "📦 Creando colección 'photos' y sus campos..."

    # Crear colección
    curl -s -X POST "$URL/collections" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"collection": "photos", "schema": {}, "meta": {"icon": "photo_library"}}' > /dev/null

    # Campo Imagen (Relación M2O hacia directus_files)
    curl -s -X POST "$URL/fields/photos" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "field": "image",
            "type": "uuid",
            "schema": {
                "foreign_key_table": "directus_files",
                "foreign_key_column": "id"
            },
            "meta": {
                "interface": "file-image",
                "special": ["file"]
            }
        }' > /dev/null

    # Crear relación M2O explícita
    curl -s -X POST "$URL/relations" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "collection": "photos",
            "field": "image",
            "related_collection": "directus_files"
        }' > /dev/null

    # Campos de texto
    for field in "name" "album_name"; do
        curl -s -X POST "$URL/fields/photos" \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "{\"field\": \"$field\", \"type\": \"string\", \"meta\": {\"interface\": \"input\"}}" > /dev/null
    done

    # Campo Fecha
    curl -s -X POST "$URL/fields/photos" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"field": "date_taken", "type": "timestamp", "meta": {"interface": "datetime"}}' > /dev/null

    echo "✅ Estructura lista."
fi

echo "--- 2. BUSCANDO/CREANDO CARPETA PADRE '$NOMBRE_PADRE' ---"
PARENT_ID=$(curl -s -X GET "$URL/folders?filter[name][_eq]=$NOMBRE_PADRE" \
    -H "Authorization: Bearer $TOKEN" | jq -r '.data[0].id // empty')

if [ -z "$PARENT_ID" ] || [ "$PARENT_ID" == "null" ]; then
    PARENT_ID=$(curl -s -X POST "$URL/folders" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"name\": \"$NOMBRE_PADRE\"}" | jq -r '.data.id // empty')
fi

if [ -z "$PARENT_ID" ]; then
    echo "❌ ERROR: No se pudo obtener ID del padre."
    exit 1
fi

echo "ID Padre: $PARENT_ID"

echo "--- 3. ESCANEANDO Y SUBIENDO ---"
cd "$PATH_LOCAL" || { echo "Ruta local no válida"; exit 1; }

for dir in */; do
    folder_name="${dir%/}"
    echo "------------------------------------------------"
    echo "📂 Procesando Carrete: $folder_name"

    # Obtener ID de subcarpeta
    NEW_FOLDER_ID=$(curl -s -X GET "$URL/folders?filter[name][_eq]=$folder_name&filter[parent][_eq]=$PARENT_ID" \
        -H "Authorization: Bearer $TOKEN" | jq -r '.data[0].id // empty')

    if [ -z "$NEW_FOLDER_ID" ] || [ "$NEW_FOLDER_ID" == "null" ]; then
        NEW_FOLDER_ID=$(curl -s -X POST "$URL/folders" \
            -H "Authorization: Bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "{\"name\": \"$folder_name\", \"parent\": \"$PARENT_ID\"}" | jq -r '.data.id // empty')
    fi

    if [ -z "$NEW_FOLDER_ID" ]; then
        echo "⚠️ Saltando $folder_name (ID carpeta fallido)"
        continue
    fi

    # Procesar archivos de imagen
    find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.tiff" \) | while read -r file; do
        filename=$(basename "$file")
        filename_no_ext="${filename%.*}"
        temp_webp="/tmp/${filename_no_ext}_$(date +%s).webp"

        echo "  🛠️ Comprimiendo $filename..."
        convert "$file" -resize "${MAX_ANCHO}>" -quality "$CALIDAD_WEBP" "$temp_webp"

        if [ -f "$temp_webp" ]; then
            echo "  🚀 Subiendo archivo físico: $filename_no_ext.webp"

            UPLOAD_RES=$(curl -s -X POST "$URL/files" \
                -H "Authorization: Bearer $TOKEN" \
                -F "folder=$NEW_FOLDER_ID" \
                -F "title=$filename_no_ext" \
                -F "file=@$temp_webp;type=image/webp")

            FILE_ID=$(echo "$UPLOAD_RES" | jq -r '.data.id // empty')

            if [ -n "$FILE_ID" ] && [ "$FILE_ID" != "null" ]; then
                echo "  🔗 Vinculando a colección 'photos'..."

                curl -s -X POST "$URL/items/photos" \
                    -H "Authorization: Bearer $TOKEN" \
                    -H "Content-Type: application/json" \
                    -d "{
                        \"image\": \"$FILE_ID\",
                        \"name\": \"$filename_no_ext\",
                        \"album_name\": \"$folder_name\",
                        \"date_taken\": \"$(date -r "$file" +"%Y-%m-%dT%H:%M:%SZ")\"
                    }" > /dev/null

                echo "  ✅ Completado."
            else
                echo "  ❌ ERROR EN SUBIDA: La API no devolvió un ID válido."
                echo "  Respuesta completa: $UPLOAD_RES"
            fi

            rm "$temp_webp"
        fi
    done
done

echo "--- ✅ PROCESO COMPLETADO ---"

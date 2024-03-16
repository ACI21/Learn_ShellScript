#!/bin/bash

# Función de ayuda
mostrar_ayuda() {
    echo "USO: userutils.sh"
    echo "-l : lista los usuarios del sistema con una vista simplificada"
    echo "-n : creará un usuario local con los datos solicitados por teclado"
}

# Verificación de parámetros de entrada
if [ "$#" -eq 0 ] || [ "$1" = "-h" ]; then
    mostrar_ayuda
    exit 0
fi

# Verificación de la opción ingresada
case "$1" in
    -l)
        # Listar usuarios del sistema con vista simplificada
        cat /etc/passwd | awk -F':' '{print $1, $3, $6}' | sort -k2 -n -r
        ;;
    -n)
        # Crear un nuevo usuario
        read -p "Ingrese el nombre del nuevo usuario: " new_user
        if [ -z "$new_user" ]; then
            echo "Error: El nombre de usuario no puede estar vacío."
            exit 1
        fi
        sudo adduser "$new_user"
        ;;
    *)
        # Opción no válida
        echo "Error: Opción no válida."
        mostrar_ayuda
        exit 1
        ;;
esac

exit 0

#!/bin/bash

# Función para mostrar el menú
mostrar_menu() {
    echo "/----------\\"
    echo "| PC Maker |"
    echo "\\----------/"
    echo "1. Catálogo de componentes"
    echo "2. Añadir componentes"
    echo "3. Configurar un nuevo PC"
    echo "4. Valorar configuración"
    echo "5. Salir"
    echo "Opción:"
}

# Verificación de la existencia del archivo pcmaker.dat
if [ ! -e "pcmaker.dat" ]; then
    echo "El archivo pcmaker.dat no existe."
    read -p "¿Desea crearlo? (s/n): " respuesta
    if [ "$respuesta" != "s" ]; then
        echo "Saliendo..."
        exit 0
    fi
    touch pcmaker.dat
fi

# Bucle del menú
while true; do
    mostrar_menu
    read opcion

    case $opcion in
        1)
            # Mostrar catálogo de componentes ordenados por marca
            echo "Código;Categoría;Marca;Modelo;Precio"
            sort -t ';' -k3 pcmaker.dat
            ;;
        2)
            # Añadir componente al catálogo
            read -p "Ingrese el código del componente: " codigo
            while grep -q "^$codigo;" pcmaker.dat; do
                read -p "El código ya existe. Introduzca otro código: " codigo
            done
            read -p "Ingrese la categoría: " categoria
            read -p "Ingrese la marca: " marca
            read -p "Ingrese el modelo: " modelo
            read -p "Ingrese el precio: " precio
            echo "$codigo;$categoria;$marca;$modelo;$precio" >> pcmaker.dat
            echo "Componente añadido al catálogo."
            ;;
        3)
            # Configurar un nuevo PC
            read -p "Ingrese el nombre de archivo para almacenar la configuración: " nombre_archivo
            touch "$nombre_archivo"
            #Definimos un arreglo que contiene las categorias de los componentes
            categorias=("placa base" "procesador" "ram" "disco duro")
            # Creamos un foreach  que recorra las categorias de componentes de pc
            for categoria in "${categorias[@]}"; do
                # Indicamos al usuario que elija un componente
                echo "Elija $categoria:"
                # Esto por partes:
                    # Primero: grep ";$categoria;" pcmaker.dat >> 
                    # buscamos en el archivo todas las lineas que contienen la cat. actual
                    # Sefundo: | esto canaliza la salida de antes y lo junto con la tercera parte
                    # Tercero: while IFS=';' read -r codigo categoria marca modelo precio; do
                    # Lee cada linea resultante del grep, diviendola en campos usando el ; como 
                    # delimitador y asigna estos campos a las varaibles correspondientes
                grep ";$categoria;" pcmaker.dat | while IFS=';' 
                read -r codigo categoria marca modelo precio; do
                    # Imprime datos
                    echo "$codigo $marca $modelo $precio"
                done
                read -p "Cód. $categoria: " codigo_seleccionado
                # Iniciamos un bucle mientras la condicion no sea verdadera, la cual es
                # Buscar el codigo ingresado anteriormente y comprobar si existe o no
                while ! grep -q "^$codigo_seleccionado;$categoria;" pcmaker.dat; do
                    read -p "Código inválido. Introduzca un código válido: " codigo_seleccionado
                done
                # buscamos la linea correspondiente al codigo y la guardamos en el archivo
                grep "^$codigo_seleccionado;$categoria;" pcmaker.dat >> "$nombre_archivo"
            done
            echo "Configuración almacenada en el archivo $nombre_archivo"
            ;;
        4)
            # Valorar configuración
            read -p "Ingrese el nombre del archivo de configuración: " nombre_configuracion
            # variabe contador
            total=0
            # inciamos un bucle y establecemos el delimitador en ; para la entrada de campos
            # Lee una línea del archivo de configuración, dividiéndola en campos usando ; como delimitador, 
            # y asigna estos campos a las variables correspondientes.
            while IFS=';' read -r codigo categoria marca modelo precio; do
                total=$((total + precio))
            #  Indicamos el final del bucle y especifica que la entrada para el bucle 
            # que vendrá del archivo de configuración especificado por el usuario.
            done < "$nombre_configuracion"
            fecha_actual=$(date +"%d/%m/%y")
            # Agregamos al final del archivo de configuración la configuración existente 
            # junto con la fecha actual y el precio total en euros.
            echo "$(<"$nombre_configuracion")" "$fecha_actual - $total €" >> "$nombre_configuracion"
            echo "Configuración valorada:"
            cat "$nombre_configuracion"
            ;;
        5)
            # Salir
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción no válida. Inténtelo de nuevo."
            ;;
    esac
done

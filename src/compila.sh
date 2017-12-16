#! /bin/sh

#===============================================================================
# Script para compilar y ejecutar relatos interactivos programados en Inform 6.
# Herramientas utilizadas:
#	<>	inform:			Compilador Inform 6
#	<>	bresc:			Blorb resource compiler (sólo GLULX)
#	<>	gargoyle-free:	Intérprete multi-plataforma
#-------------------------------------------------------------------------------

bresc_location=~/data/bin
zcode_interpreter=gargoyle-free;
glulx_interpreter=gargoyle-free;

#-------------------------------------------------------------------------------

rm ./*~

if [ "$1" != "" ]; then gameFile=$1;
else
	echo -n "Introduce el nombre del archivo (sin la extensión): ";
	read gameFile;
	echo " ";
fi
if [ ! -e "$gameFile.inf" ]; then
	echo "El archivo '$gameFile.inf' no existe.";
	exit 1;
fi

if [ "$2" != "" ]; then op=$2;
else
	echo "[1] Compilar el relato para MÁQUINA-Z"
	echo "[2] Compilar el relato para GLULX"
	echo "[3] Compilar el relato para GLULX (sin multimedia)"
	echo -n "Selecciona una opción: "
	read op;
	echo " "
fi

perl ./extensions/preprocesaTexto.pl ./$gameFile\_texts.inf ./$gameFile\_langOM.inf

#===============================================================================
# Compilar el relato para GLULX (sin multimedia)
#-------------------------------------------------------------------------------
if [ "$op" = "3" ]; then
	echo "============================================="
	echo "COMPILANDO PARA GLULX (sin multimedia)..."
	echo "---------------------------------------------"
	inform +include_path=,/usr/share/inform/include/,/usr/share/inform/module/,/usr/share/inform/6.31/include/,/usr/share/inform/6.31/module/,/usr/share/inform/6.31/include/gwindows/,/usr/share/inform/6.31/include/other/ -G $gameFile.inf ../$gameFile.ulx

	echo " "
	echo -n "Pulsa cualquier tecla para ejecutar la aplicación ('q' para salir): "
	read key

	if [ "$key" = "q" ]; then exit 0;
	fi
	if [ "$key" = "Q" ]; then exit 0;
	fi
	cd ..
	$glulx_interpreter $gameFile.ulx

#===============================================================================
# Compilar el relato para GLULX
#-------------------------------------------------------------------------------
elif [ "$op" = "2" ]; then
	echo "============================================="
	echo "COMPILANDO PARA GLULX..."
	echo "---------------------------------------------"
	inform +include_path=,/usr/share/inform/include/,/usr/share/inform/module/,/usr/share/inform/6.31/include/,/usr/share/inform/6.31/module/,/usr/share/inform/6.31/include/gwindows/,/usr/share/inform/6.31/include/other/ -G $gameFile.inf $gameFile.ulx
	$bresc_location/bres $gameFile.res
	inform +include_path=,/usr/share/inform/include/,/usr/share/inform/module/,/usr/share/inform/6.31/include/,/usr/share/inform/6.31/module/,/usr/share/inform/6.31/include/gwindows/,/usr/share/inform/6.31/include/other/ -G $gameFile.inf
	$bresc_location/bresc $gameFile.res
	mv $gameFile.blb ../$gameFile.blb
	rm $gameFile.ulx

	echo " "
	echo -n "Pulsa cualquier tecla para ejecutar la aplicación ('q' para salir): "
	read key

	if [ "$key" = "q" ]; then exit 0;
	fi
	if [ "$key" = "Q" ]; then exit 0;
	fi
	cd ..
	$glulx_interpreter $gameFile.blb

#===============================================================================
# Compilar el relato para MÁQUINA-Z
#-------------------------------------------------------------------------------
else
	echo "============================================="
	echo "COMPILANDO PARA MÁQUINA-Z..."
	echo "---------------------------------------------"
	inform +include_path=,/usr/share/inform/include/,/usr/share/inform/module/,/usr/share/inform/6.31/include/,/usr/share/inform/6.31/module/,/usr/share/inform/6.31/include/gwindows/,/usr/share/inform/6.31/include/other/ $gameFile.inf ../$gameFile.z5

	echo " "
	echo -n "Pulsa cualquier tecla para ejecutar la aplicación ('q' para salir): "
	read key

	if [ "$key" = "q" ]; then exit 0;
	fi
	if [ "$key" = "Q" ]; then exit 0;
	fi
	cd ..
	$zcode_interpreter $gameFile.z5
fi

exit 0;

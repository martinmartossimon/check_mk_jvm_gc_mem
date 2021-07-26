#!/bin/bash

#################################################################################################################
# Titulo:
#
# Descripcion:
#
# Detalle:
# COMANDO COLECTOR: 
#
# Autor: Martin Martos Simon - martinmartossimon@gmail.com
# MIT License
# 
# Copyright (c) 2020 Martin Martos Simon - martinmartossimon@gmail.com
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# #
#################################################################################################################

#Linea a parsear y extraer info: <start>-<end>: <type> <before>KB-><after>KB (<heap>KB), <time> ms, sum of pauses <pause> ms

########################## DEBUG
#set -x

########################## PARAMETRIZACION
PATH_LOG="/path/to/log.log"



########################## FUNCIONES



########################## MAIN
#Leo la ultima linea del log limpiada
ULTIMA_LINEA=$(cat $PATH_LOG | grep 'KB->' | grep -v '<start>' | tail -1)
ULTIMA_METRICA=$(cat $PATH_LOG | grep 'KB->' | grep -v '<start>' | tail -1 | awk '{print $10}')
#Entrega algo asi: 6196595KB->1278263KB
#echo $ULTIMA_METRICA

BEFORE=$(echo $ULTIMA_METRICA | awk -F"->" '{print $1}' | sed 's/KB//')
AFTER=$(echo $ULTIMA_METRICA | awk -F"->" '{print $2}' | sed 's/KB//')

#echo "$BEFORE|$AFTER"

let "DIFERENCIA = $BEFORE - $AFTER"
#echo "$DIFERENCIA"


#Salida en formato de check_mk. No hay umbrales ni alarmas definidas, solo metricas.
FECHA_CHEQUEO=$(date +'%d/%m/%Y %H:%M:%S')

printf "0 JVM_GC_MEMORIA before=%s;;;|after=%s;;;|diferencia=%s Chequeo de %s. Valores leidos %s. Linea leida: %s \n" "$BEFORE" "$AFTER" "$DIFERENCIA" "$FECHA_CHEQUEO" "$ULTIMA_METRICA" "$ULTIMA_LINEA"

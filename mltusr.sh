#!/bin/bash
#exercici 1 mltusr.sh
#Pol Sanz
#
declare -r UID_INIC=3001
declare -r GROUP=users
declare -r SHELL=/bin/bash

clear

#descarreguem el fitxer .ods amb el nom dels usuaris
wget http://www.collados.org/asix2/m06/uf2/usuaris.ods

#convertim el fitxer .ods en .csv
libreoffice --headless --convert-to csv usuaris.ods

#copiem el contingut del arxiu .csv a usuaris2, pero treient la coma i el numero
cat usuaris.csv | cut -d "," -f 2 > usuaris2

uid=$UID_INIC
for nom in $(cut -d ',' -f 2 usuaris.csv)

do
	#directori personal dels usuaris
	dir=/home/$nom
	#genero una contrasenya aleatoria per els usuaris
	pass=$(mkpasswd " ")
	#echo $nom
	#creem els usuaris amb el uid indicat, el grup indicat, el directori personal, el shell indicat i la contrasenya aleatoria encriptada
	useradd $nom -u $uid -g $GROUP -d $dir -m -s $SHELL -p $(mkpasswd $pass)
	#fem que cada cop que es crea un usuari sumi +1 al uid
	uid=$(expr $uid + 1)
done


exit 0
